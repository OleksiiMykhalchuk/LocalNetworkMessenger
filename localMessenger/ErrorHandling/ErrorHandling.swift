//
//  ErrorHandling.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/15/22.
//

import Foundation

enum CustomError: Error {
    case sendMessageFailure(Error)
}
