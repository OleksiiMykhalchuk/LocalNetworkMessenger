//
//  Server.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/9/22.
//

import Foundation
import Network
import UIKit

let server = try? Server()

class Server {
    let listener: NWListener
    var connections: [Connection] = []

    init() throws {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2
        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        listener = try NWListener(using: parameters)
        listener.service = NWListener.Service(name: "server", type: "_superapp._tcp")
    }
    func start() {
        listener.stateUpdateHandler = { newState in
            log("listener.stateUpdateHandler \(newState)")
        }
        listener.newConnectionHandler = { [weak self] newConnectiion in
            log("listener.newConnectionHandler \(newConnectiion)")
            let connection = Connection(connection: newConnectiion)
            self?.connections += [connection]
        }
        listener.start(queue: .main)
    }
    func send() {
        connections.forEach {
            $0.send("supermessage fron server! \(Int(Date().timeIntervalSince1970))")
        }
    }
    func stop() {
        listener.cancel()
    }
}
