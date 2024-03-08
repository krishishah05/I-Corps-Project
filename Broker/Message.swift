//
//  Message.swift
//  Broker
//
//  Created by 何偉銘 on 3/7/24.
//

import Foundation

struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isIncoming: Bool
}
