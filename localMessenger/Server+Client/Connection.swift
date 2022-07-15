//
//  Connection.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/9/22.
//

import Foundation
import Network

//var sharedConnection: Connection?

class Connection {
    let connection: NWConnection
    init(endPoint: NWEndpoint) {
        log("PeerConnection ougoing endPoint \(endPoint)")
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2
        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        connection = NWConnection(to: endPoint, using: parameters)
        start()
    }
    init(connection: NWConnection) {
        log("PeerConnection incoming connection \(connection)")
        self.connection = connection
        start()
    }
    func start() {
        connection.stateUpdateHandler = { newState in
            log("connection.stateUpdateHandler \(newState)")
            if case .ready = newState {
                self.receiveMessage()
            }
        }
        connection.start(queue: .main)
    }
    func send(_ message: String) {
        connection.send(content: message.data(using: .utf8),
                        contentContext: .defaultMessage,
                        isComplete: true,
                        completion: .contentProcessed({ error in
            log("Connection send error: \(String(describing: error))")
        }))
    }
    func receiveMessage() {
        connection.receive(minimumIncompleteLength: 1,
                           maximumLength: 100, completion: { data, _, _, _ in
            if let data = data {
                let message = String(data: data, encoding: .utf8)
                log("Connection received message \(String(describing: message))")
            }
            self.receiveMessage()
        })
    }
}
