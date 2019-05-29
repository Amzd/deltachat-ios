//
//  ContactListController.swift
//  deltachat-ios
//
//  Created by Friedel Ziegelmayer on 26.12.18.
//  Copyright © 2018 Jonas Reinsch. All rights reserved.
//

import UIKit

class ContactListController: UITableViewController {
  weak var coordinator: ContactListCoordinator?

  let contactCellReuseIdentifier = "xyz"
  var contactIds: [Int] = Utils.getContactIds()
  var contactIdsForGroup: Set<Int> = []

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Contacts"
    navigationController?.navigationBar.prefersLargeTitles = true

    tableView.rowHeight = 80
    tableView.register(ContactCell.self, forCellReuseIdentifier: contactCellReuseIdentifier)
  }

  private func getContactIds() {
    contactIds = Utils.getContactIds()
    tableView.reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
    }

    getContactIds()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = false
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return contactIds.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ContactCell
    if let c = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as? ContactCell {
      cell = c
    } else {
      cell = ContactCell(style: .subtitle, reuseIdentifier: "ChatCell")
    }
    let row = indexPath.row
    let contactRow = row

    if contactRow < contactIds.count {
      let contact = MRContact(id: contactIds[contactRow])
      cell.nameLabel.text = contact.name
      cell.emailLabel.text = contact.email

      cell.selectionStyle = .none

      if let img = contact.profileImage {
        cell.setImage(img)
      } else {
        cell.setBackupImage(name: contact.name, color: contact.color)
      }
      cell.setVerified(isVerified: contact.isVerified)
    }
    return cell
  }

  override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contactId = contactIds[indexPath.row]
		let chatId = dc_create_chat_by_contact_id(mailboxPointer, UInt32(contactId))

		coordinator?.showChat(chatId: Int(chatId))
		// coordinator?.showContactDetail(contactId: contactId)
  }

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let row = indexPath.row

		let contactId = contactIds[row]

		// assigning swipe by delete to chats
		let edit = UITableViewRowAction(style: .default, title: "Edit") {
			[unowned self] _, indexPath in
			self.coordinator?.showContactDetail(contactId: contactId)
		}
		edit.backgroundColor = DCColors.primary
		return [edit]
	}
}
