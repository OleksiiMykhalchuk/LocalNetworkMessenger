//
//  ChatMessage.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/13/22.
//

import UIKit

struct ChatMessage: Identifiable, Codable, Equatable {
    var id = UUID()
    let displayName: String
    let body: String
    var time = Date()
    var isUser: Bool {
        return displayName == UIDevice.current.name
    }
}
