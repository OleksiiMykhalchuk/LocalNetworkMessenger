//
//  ViewController.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/8/22.
//

import UIKit

class ViewController: UIViewController, NetServiceBrowserDelegate {
    var chatManager = ChatManager.shared
    var peers: [String] = []
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
//        chatManager.delegate = self
        // Do any additional setup after loading the view.
//        let service = NetService(domain: "",
//                                 type: "_superapp._tcp",
//                                 name: UIDevice.current.name,
//                                 port: 52177)
//        service.publish()
//        let serviceBrowser = NetServiceBrowser()
//        serviceBrowser.delegate = self
//        serviceBrowser.searchForServices(ofType: "_superapp._tcp", inDomain: "")
        hostBtn.layer.borderWidth = 1
        hostBtn.layer.cornerRadius = 10
        joinBtn.layer.borderWidth = 1
        joinBtn.layer.cornerRadius = 10
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "host" {
            let controller = segue.destination as? HostViewController
//            controller?.chatManager = chatManager
        } else if segue.identifier == "join" {
            let controller = segue.destination as? HostViewController
//            controller?.chatManager = chatManager
            controller?.isJoin = true
        }
    }
}
