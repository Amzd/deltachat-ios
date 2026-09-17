#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'xcodeproj'

ROOT = Pathname.new(__dir__).parent
XTOOL_DIR = ROOT.join('xtool')
PROJECT_PATH = ROOT.join('deltachat-ios.xcodeproj')
CORE_PROJECT_PATH = ROOT.join('DcCore', 'DcCore.xcodeproj')

TARGETS = {
  'deltachat-ios' => 'DeltaChatApp',
  'DcShare' => 'DcShareExtension',
  'DcNotificationService' => 'DcNotificationServiceExtension',
  'DcWidget' => 'DcWidgetExtension'
}.freeze

CONFIG_LINKS = {
  'DeltaChatApp/Info.plist' => 'deltachat-ios/Info.plist',
  'DeltaChatApp/deltachat-ios.entitlements' => 'deltachat-ios/deltachat-ios.entitlements',
  'DcShare/Info.plist' => 'DcShare/Info.plist',
  'DcShare/DcShare.entitlements' => 'DcShare/DcShare.entitlements',
  'DcNotificationService/Info.plist' => 'DcNotificationService/Info.plist',
  'DcNotificationService/DcNotificationService.entitlements' => 'DcNotificationService/DcNotificationService.entitlements',
  'DcWidget/Info.plist' => 'DcWidget/Info.plist',
  'Shared/PrivacyInfo.xcprivacy' => 'PrivacyInfo.xcprivacy'
}.freeze

SUPPORT_LINKS = {
  'AppIcon.png' => 'deltachat-ios/Assets.xcassets/AppIcon.appiconset/appicon-any.png',
  'libdeltachat.a' => 'deltachat-ios/libraries/libdeltachat.a'
}.freeze

def reset_dir(path)
  FileUtils.rm_rf(path)
  FileUtils.mkdir_p(path)
end

def symlink(source_path, destination_path)
  source_path = source_path.expand_path
  destination_path = destination_path.expand_path
  destination_path.dirname.mkpath
  FileUtils.rm_rf(destination_path)
  relative_source = source_path.relative_path_from(destination_path.dirname)
  File.symlink(relative_source, destination_path)
end

def project_relative(pathname)
  pathname.expand_path.relative_path_from(ROOT)
end

project = Xcodeproj::Project.open(PROJECT_PATH.to_s)
core_project = Xcodeproj::Project.open(CORE_PROJECT_PATH.to_s)

reset_dir(XTOOL_DIR.join('Targets'))
reset_dir(XTOOL_DIR.join('Config'))
reset_dir(XTOOL_DIR.join('Support'))

cdelta = XTOOL_DIR.join('Targets', 'CDeltaChat')
FileUtils.mkdir_p(cdelta.join('include'))
symlink(ROOT.join('deltachat-ios', 'libraries', 'deltachat-core-rust', 'deltachat-ffi', 'deltachat.h'), XTOOL_DIR.join('Support', 'deltachat.h'))
symlink(ROOT.join('DcCore', 'DcCore', 'DC', 'wrapper.c'), cdelta.join('wrapper.c'))
symlink(ROOT.join('DcCore', 'DcCore', 'DC', 'wrapper.h'), cdelta.join('include', 'wrapper.h'))
symlink(XTOOL_DIR.join('Support', 'deltachat.h'), cdelta.join('include', 'deltachat.h'))

CONFIG_LINKS.each do |destination, source|
  symlink(ROOT.join(source).expand_path, XTOOL_DIR.join('Config', destination))
end

SUPPORT_LINKS.each do |destination, source|
  symlink(ROOT.join(source).expand_path, XTOOL_DIR.join('Support', destination))
end

core_target = core_project.targets.find { |item| item.name == 'DcCore' }
raise 'Missing target DcCore' unless core_target

core_sources_root = XTOOL_DIR.join('Targets', 'DcCore', 'Sources')
FileUtils.mkdir_p(core_sources_root)
wrapper_source = ROOT.join('DcCore', 'DcCore', 'DC', 'wrapper.c').expand_path
core_target.source_build_phase.files_references.each do |file_ref|
  source = file_ref.real_path.expand_path
  next if source == wrapper_source

  relative = project_relative(source)
  symlink(source, core_sources_root.join(relative))
end

TARGETS.each do |xcode_target_name, swiftpm_target_name|
  target = project.targets.find { |item| item.name == xcode_target_name }
  raise "Missing target #{xcode_target_name}" unless target

  target_root = XTOOL_DIR.join('Targets', swiftpm_target_name)
  sources_root = target_root.join('Sources')
  resources_root = target_root.join('Resources')
  FileUtils.mkdir_p(sources_root)
  FileUtils.mkdir_p(resources_root)
  linked_resource_sources = []

  target.source_build_phase.files_references.each do |file_ref|
    source = file_ref.real_path.expand_path
    relative = project_relative(source)
    symlink(source, sources_root.join(relative))
  end

  if xcode_target_name == 'DcWidget'
    Dir.glob(File.join(ROOT.to_s, 'DcWidget', '*.swift')).sort.each do |source_path|
      source = Pathname.new(source_path)
      relative = project_relative(source)
      symlink(source, sources_root.join(relative))
    end
  end

  target.resources_build_phase.files.each do |build_file|
    file_ref = build_file.file_ref
    next unless file_ref

    if file_ref.isa == 'PBXVariantGroup'
      file_ref.children.each do |child|
        linked_resource_sources << child.real_path.expand_path
      end
    else
      linked_resource_sources << file_ref.real_path.expand_path
    end
  end

  if xcode_target_name == 'DcWidget'
    linked_resource_sources << ROOT.join('DcWidget', 'Assets.xcassets').expand_path
  end

  linked_resource_sources
    .uniq
    .sort_by { |path| path.each_filename.count }
    .each do |source|
      next if linked_resource_sources.any? { |other| other != source && source.to_s.start_with?(other.to_s + File::SEPARATOR) }

      relative = project_relative(source)
      symlink(source, resources_root.join(relative))
    end
end
