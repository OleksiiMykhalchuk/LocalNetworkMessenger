//
//  ChatManager.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/13/22.
//

import Foundation
import MultipeerConnectivity

class ChatManager: NSObject {
    private static let service = "chat"
    var peers: [MCPeerID] = []
    var messages: [ChatMessage] = []
    var connetedToChat = false

    static var shared = ChatManager()

    private var advertiserAssistant: MCNearbyServiceAdvertiser?
    let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession?
    private var isHosting = false

    func join() {
        peers.removeAll()
        messages.removeAll()
        session = MCSession(
            peer: myPeerID,
            securityIdentity: nil,
            encryptionPreference: .required)
        session?.delegate = self
        guard let window = UIApplication.shared.windows.first, let session = session else { return }
        let mcBrowserViewController = MCBrowserViewController(
            serviceType: ChatManager.service,
            session: session)
        mcBrowserViewController.delegate = self
        window.rootViewController?.present(mcBrowserViewController, animated: true)
    }
    func sendHistory(to peer: MCPeerID) {
        let tempFile = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("messages.data")
        guard let historyData = try? JSONEncoder().encode(messages) else { return }
        try? historyData.write(to: tempFile)
        session?.sendResource(at: tempFile, withName: "Chat_History", toPeer: peer) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func host() {
        isHosting = true
        peers.removeAll()
        messages.removeAll()
        connetedToChat = true
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        advertiserAssistant = MCNearbyServiceAdvertiser(
            peer: myPeerID, discoveryInfo: nil, serviceType: ChatManager.service)
        advertiserAssistant?.delegate = self
        advertiserAssistant?.startAdvertisingPeer()
    }
    func leaveChat() {
        isHosting = false
        connetedToChat = false
        advertiserAssistant?.stopAdvertisingPeer()
        messages.removeAll()
        session = nil
        advertiserAssistant = nil
    }
    func send(_ message: String) {
        let chatMessage = ChatMessage(id: UUID(), displayName: myPeerID.displayName, body: message, time: Date())
        messages.insert(chatMessage, at: 0)
        NotificationCenter.default.post(name: Notification.Name(NotificationName.sendMessage.rawValue), object: nil)
        guard let session = session,
        let data = message.data(using: .utf8),
        !session.connectedPeers.isEmpty else {
            return
        }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ChatManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension ChatManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else { return }
        let chatMessage = ChatMessage(id: UUID(), displayName: peerID.displayName, body: message, time: Date())
        DispatchQueue.main.async {
            self.messages.insert(chatMessage, at: 0)
            NotificationCenter.default.post(name: Notification.Name(
                NotificationName.messageReceived.rawValue), object: nil)
        }
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                if let index = self.peers.firstIndex(of: peerID) {
                    self.peers.remove(at: index)
                    NotificationCenter.default.post(name: NSNotification.Name(
                        NotificationName.peerConnected.rawValue), object: nil)
                }
                if self.peers.isEmpty && !self.isHosting {
                    self.connetedToChat = false
                }
            }
        case .connecting:
            print("Connecting to \(peerID.displayName)")
        case .connected:
            if  !peers.contains(peerID) {
                DispatchQueue.main.async {
                    self.peers.insert(peerID, at: 0)
                    NotificationCenter.default.post(name: NSNotification.Name(
                        NotificationName.peerConnected.rawValue), object: nil)
                }
                if isHosting {
                    sendHistory(to: peerID)
                }
            }
        @unknown default:
            print("Unknow")
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving chat history")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        guard let localURL = localURL,
        let data = try? Data(contentsOf: localURL),
        let messages = try? JSONDecoder().decode([ChatMessage].self, from: data) else {
            return
        }
        DispatchQueue.main.async {
            self.messages.insert(contentsOf: messages, at: 0)
        }
    }
}

extension ChatManager: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
        self.connetedToChat = true
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        session?.disconnect()
        browserViewController.dismiss(animated: true)
    }
}
