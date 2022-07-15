//
//  HostViewController.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/13/22.
//

import UIKit
import MultipeerConnectivity

class HostViewController: UIViewController {
    var isJoin: Bool?
    private var chatManager = ChatManager.shared
    private var peers: [String] = []
    private var name = ""
    private var constraint: NSLayoutConstraint?
    // MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func leave(_ sender: Any) {
        chatManager.leaveChat()
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if isJoin != nil {
            title = "Join Chat"
            name = chatManager.peers.reduce("") { $0 + $1.displayName + "\n" }
        } else {
            title = "Host Chat"
            name = "No Participants Yet"
        }
        label.text = name
        tableView.register(UINib(resource: R.nib.userMessageCell), forCellReuseIdentifier: "userMessage")
        tableView.register(UINib(resource: R.nib.participantMessageCell), forCellReuseIdentifier: "participantMessage")
        // Notification Observers
        NotificationCenter.default.addObserver(self, selector: #selector(peersNotification),
                                               name: NSNotification.Name(
                                                NotificationName.peerConnected.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(messageReceived),
                                               name: Notification.Name(
                                                NotificationName.messageReceived.rawValue), object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sendMessage),
            name: Notification.Name(NotificationName.sendMessage.rawValue), object: nil)
        textFieldSetup()
        tableViewSetup()
    }
    // MARK: - Selectors
    @objc private func messageReceived() {
        print(chatManager.messages)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .left)
    }
    @objc private func sendMessage() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .right)
    }
    @objc private func peersNotification(_ sender: Any) {
        var name = ""
        name = chatManager.peers.reduce("") { $0 + $1.displayName + "\n" }
        label.text = name
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]
                                      as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
             let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
             let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(
                rawValue: animationCurveRaw)
        constraint?.constant = -endFrame!.height
        UIView.animate(withDuration: duration,
                       delay: 0, options: animationCurve, animations: { self.view.layoutIfNeeded() }, completion: nil)

    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]
                                      as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
             let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
             let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        constraint?.constant = -60
        UIView.animate(withDuration: duration, delay: 0,
                       options: animationCurve, animations: { self.view.layoutIfNeeded() }, completion: nil)
    }
    @objc func touchUpInside() {
        chatManager.send(textField.text!)
        textField.text = ""
    }
    // MARK: - Private Functions
    private func tableViewSetup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        tableView.separatorStyle = .none
    }
    private func textFieldSetup() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        constraint = textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        constraint?.isActive = true
        textField.placeholder = "Enter Message"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.addTarget(self, action: #selector(touchUpInside), for: .editingDidEndOnExit)
    }
}

extension HostViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userCell = tableView.dequeueReusableCell(
            withIdentifier: "userMessage", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        guard let participantCell = tableView.dequeueReusableCell(
            withIdentifier: "participantMessage", for: indexPath) as? ParticipantTableViewCell else {
            return UITableViewCell()
        }
        if chatManager.messages[indexPath.row].isUser {
            userCell.body.text = chatManager.messages[indexPath.row].body
            userCell.timeName.text = " \(chatManager.messages[indexPath.row].displayName)@\(chatManager.messages[indexPath.row].time.customFormatt())"
            userCell.viewMessage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return userCell
        } else {
            participantCell.body.text = chatManager.messages[indexPath.row].body
            participantCell.timeName.text = " \(chatManager.messages[indexPath.row].displayName)@\(chatManager.messages[indexPath.row].time.customFormatt())"
            participantCell.viewMessage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return participantCell
        }
    }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatManager.messages.count
    }
}

// MARK: - UITableViewDelegate
extension HostViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
