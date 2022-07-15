//
//  Client.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/9/22.
//

import Foundation

let client = Client()

class Client {
    let browser = Browser()
    var connection: Connection?
    func start() {
        browser.start { [weak self] result in
            guard let self = self else { return }
            log("Client Handler Result \(result)")
            self.connection = Connection(endPoint: result.endpoint)
        }
    }
    func send() {
        connection?.send("Message from Client")
    }
    func stop() {
        browser.browser.cancel()
    }
}
