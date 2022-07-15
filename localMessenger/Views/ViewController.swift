//
//  ViewController.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/8/22.
//

import UIKit

class ViewController: UIViewController, NetServiceBrowserDelegate {
    private var chatManager = ChatManager.shared
    @IBOutlet weak var hostBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    @IBAction func joinAction(_ sender: Any) {
        chatManager.join()
    }
    @IBAction func hostAction(_ sender: Any) {
        chatManager.host()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hostBtn.layer.borderWidth = 1
        hostBtn.layer.cornerRadius = 10
        joinBtn.layer.borderWidth = 1
        joinBtn.layer.cornerRadius = 10
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "join" {
            let controller = segue.destination as? HostViewController
            controller?.isJoin = true
        }
    }
}
