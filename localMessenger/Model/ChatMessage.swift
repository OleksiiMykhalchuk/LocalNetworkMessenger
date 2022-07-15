//
//  ChatMessage.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/13/22.
//

import UIKit

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let displayName: String
    let body: String
    let time: Date
    var isUser: Bool {
        return displayName == UIDevice.current.name
    }
}
