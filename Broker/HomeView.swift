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
                    .onChange(of: viewModel.messages.count) {
                        if let lastMessageId = viewModel.messages.last?.id {
                            value.scrollTo(lastMessageId, anchor: .bottom)
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message...", text: $messageText)
                    .padding()

                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding()
            }
            .padding()
        }
    }
    
    struct ResponseItem: Decodable {
        let generated_text: String
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        viewModel.addMessage(messageText, isIncoming: false)
        guard let url = URL(string: "https://api-inference.huggingface.co/models/mistralai/Mixtral-8x7B-Instruct-v0.1") else {
            fatalError("Invalid URL")
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try JSONSerialization.data(withJSONObject: ["inputs": "<s> [INST] \(messageText) [/INST]"], options: [])
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle errors
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data in response")
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode([ResponseItem].self, from: data)
                    if let firstItem = decodedData.first {
                        if let range = firstItem.generated_text.range(of: "[/INST]") {
                            viewModel.addMessage(firstItem.generated_text[range.upperBound...].trimmingCharacters(in: .whitespaces), isIncoming: true)
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            task.resume()
        } catch {
            print("Error serializing message to JSON: \(error)")
        }
        messageText = ""
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
