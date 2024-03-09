//
//  HomeView.swift
//  Broker
//
//  Created by 何偉銘 on 2/25/24.
//

import SwiftUI

class ConversationViewModel: ObservableObject {
    @Published var messages: [Message] = []

    func addMessage(_ text: String, isIncoming: Bool) {
        let newMessage = Message(text: text, isIncoming: isIncoming)
        messages.append(newMessage)
    }
}

struct HomeView: View {
    
    @ObservedObject var viewModel = ConversationViewModel()
    @State private var messageText: String = ""

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        value.scrollTo(viewModel.messages.last?.id)
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(30))

                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        viewModel.addMessage(messageText, isIncoming: false)
        guard let url = URL(string: "https://w7xu2c05r1.execute-api.us-east-2.amazonaws.com/prod/mistral") else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "<s>[INST] \(messageText) [/INST]".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Parse the response and add it as an incoming message
            if let data = data, let responseMessage = String(data: data, encoding: .utf8) {
                viewModel.addMessage(responseMessage, isIncoming: true)
            }
        }
        task.resume()
        messageText = ""
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
