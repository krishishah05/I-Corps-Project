//
//  HomeView.swift
//  Broker
//
//  Created by 何偉銘 on 2/25/24.
//

import SwiftUI
import AudioToolbox

class ConversationViewModel: ObservableObject {
    @Published var messages: [Message] = []

    func addMessage(_ text: String, isIncoming: Bool) {
        let newMessage = Message(text: text, isIncoming: isIncoming)
        DispatchQueue.main.async {
            self.messages.append(newMessage)
        }
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
                .animation(.easeInOut, value: viewModel.messages.count)
            }
            let audioRecorder = AudioRecorder()
            let audioFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("recording.aif")
            Button(action: {}) {
                Text("Hold to Record")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10, pressing: { isPressing in
                if isPressing {
                    // Start recording
                    audioRecorder.startRecording(filePath: audioFilename)
                } else {
                    // Stop recording
                    audioRecorder.stopRecording()
                    let systemSoundID: SystemSoundID = 1001
                    AudioServicesPlaySystemSound(systemSoundID)
                    Task {
                        let transcribedMessage = await sendAudio(filePath: audioFilename)
                        awaitResponse(transcribedMessage)
                    }
                }
            }, perform: {})
            HStack {
                TextField("Type a message...", text: $messageText)
                    .padding()

                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding()
            }
            .padding()
            //Button(action: audioRecorder.playSound) {Text("Play")} // For test
        }
    }
    
    struct ResponseItem: Decodable {
        let generated_text: String
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        viewModel.addMessage(messageText, isIncoming: false)
        awaitResponse(messageText)
        messageText = ""
    }
    
    private func awaitResponse(_ inputs: String) {
        guard let url = URL(string: "https://api-inference.huggingface.co/models/mistralai/Mixtral-8x7B-Instruct-v0.1") else {
            fatalError("Invalid URL")
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try JSONSerialization.data(withJSONObject: ["inputs": "<s> [INST] \(inputs) [/INST]"], options: [])
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
    }
    
    struct AudioResponseItem: Decodable {
        let text: String
    }
    
    private func sendAudio(filePath: URL) async -> String {
        let url = URL(string: "https://api-inference.huggingface.co/models/openai/whisper-base")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, fromFile: filePath)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Handle server error or invalid response scenario
                print("Server error or invalid response.")
                return ""
            }
            
            // If you're expecting a JSON response and need to decode it
            do {
                let decodedData = try JSONDecoder().decode(AudioResponseItem.self, from: data)
                viewModel.addMessage(decodedData.text, isIncoming: false)
                return decodedData.text
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
            print("Audio uploaded successfully.")
            
        } catch {
            print("Error occurred during upload: \(error)")
        }
        return ""
    }

    
    private func sendAudio1(filePath: URL) {
        let url = URL(string: "https://api-inference.huggingface.co/models/openai/whisper-large-v3")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        // Attempt to load the audio file data
        do {
            let fileData = try Data(contentsOf: filePath)
            request.httpBody = fileData
            
            // Create and resume a URLSessionDataTask
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle the response here
                if let error = error {
                    // Handle error scenario
                    print("Error occurred during upload: \(error)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Success scenario, handle accordingly
                    print("Audio uploaded successfully.")
                } else {
                    // Handle server error or invalid response scenario
                    print("Server error or invalid response.")
                }
                guard let data = data else {
                    print("No data in response")
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(AudioResponseItem.self, from: data)
                    viewModel.addMessage(decodedData.text, isIncoming: false)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            task.resume()
            
        } catch {
            // Handle error loading the file
            print("Failed to load file data: \(error)")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
