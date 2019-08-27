# deltachat-ios

Email-based instant messaging for iOS.

![Screenshot Chat List](docs/images/screenshot_chat_list.png) ![Screenshot Chat View](docs/images/screenshot_chat_view.png)


## Testing

Betas are distributed via Testflight. Just scan this QR code with the camera app of your iPhone/iPad

<img src=https://delta.chat/assets/home/deltachat_testflight_qrcode.png width=160>

or open this link

https://testflight.apple.com/join/uEMc1NxS

on your iPhone or iPad to try Deltachat iOS Beta.

Check the Changelog (for TestFlight builds) at the bottom to see what's included.


## How to build with Xcode

You need to install [rustup](https://rustup.rs/) with rust, as well as [cargo-lipo](https://github.com/TimNN/cargo-lipo#installation).

```bash
$ git clone git@github.com:deltachat/deltachat-ios.git
$ cd deltachat-ios
$ git submodule update --init --recursive
# Make sure the correct rust version is installed
$ rustup toolchain install `cat deltachat-ios/libraries/deltachat-core-rust/rust-toolchain`
$ open deltachat-ios.xcworkspace # do not: open deltachat-ios.xcodeproj
```

This should open Xcode. Then make sure that at the top left in Xcode there is *deltachat-ios* selected as scheme (see screenshot below).

![Screenshot](docs/images/screenshot_scheme_selection.png)

Now build and run - e.g. by pressing Cmd-r - or click on the triangle at the top:

![Screenshot](docs/images/screenshot_build_and_run.png)

If Xcode complains about missing header files (different mac versions may or may not install all headers),
you can force-install them with the following command:

```bash
$ sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
```
