//
//  LecturesView.swift
//  Broker
//
//  Created by 何偉銘 on 2/25/24.
//

import SwiftUI

struct LecturesView: View {
    var body: some View {
        VStack {
            NavigationStack {
                List{
                    Section(header: Text("Level 1")) {
                        ForEach(lectures.level1, id: \.self) { lecture in
                            Text(lecture)
                                .padding()
                        }
                    }
                    Section(header: HStack() {
                        Image(systemName: "lock.square.fill")
                        Text("Level 2")
                    }) {
                        ForEach(lectures.level2, id: \.self) { lecture in
                            Text(lecture)
                                .padding()
                        }
                    }
                    Section(header: HStack() {
                        Image(systemName: "lock.square.fill")
                        Text("Level 3")
                    }) {
                        ForEach(lectures.level3, id: \.self) { lecture in
                            Text(lecture)
                                .padding()
                        }
                    }
                    Section(header: HStack() {
                        Image(systemName: "lock.square.fill")
                        Text("Level 4")
                    }) {
                        ForEach(lectures.level4, id: \.self) { lecture in
                            Text(lecture)
                                .padding()
                        }
                    }
                    Section(header: HStack() {
                        Image(systemName: "lock.square.fill")
                        Text("Level 5")
                    }) {
                        ForEach(lectures.level5, id: \.self) { lecture in
                            Text(lecture)
                                .padding()
                        }
                    }
                }
                .navigationTitle("Lectures")
            }
        }
    }
}

struct LecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesView()
    }
}
