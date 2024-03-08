//
//  MessageBubble.swift
//  Broker
//
//  Created by 何偉銘 on 3/7/24.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message

    var body: some View {
        HStack {
            if message.isIncoming {
                Spacer()
            }
            Text(message.text)
                .padding(10)
                .foregroundColor(message.isIncoming ? .black : .white)
                .background(message.isIncoming ? Color(white: 0.9) : .blue)
                .cornerRadius(10)
            if !message.isIncoming {
                Spacer()
            }
        }
        .padding(message.isIncoming ? .leading : .trailing, 20)
        .transition(.slide)
        .animation(.easeInOut)
    }
}
