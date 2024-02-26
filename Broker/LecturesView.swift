//
//  LecturesView.swift
//  Broker
//
//  Created by 何偉銘 on 2/25/24.
//

import SwiftUI

struct LecturesView: View {
    var body: some View {
        ScrollView{
            VStack {
                Text("Lectures")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                Text("Level 1")
                    .font(.title2)
                
                ForEach(lectures.level1, id: \.self) { lecture in
                    Text(lecture)
                        .padding()
                        .border(Color.secondary)
                }
                .padding()
                
                HStack() {
                    Image(systemName: "lock.square.fill")
                    Text("Level 2")
                        .font(.title2)
                }
                
                ForEach(lectures.level2, id: \.self) { lecture in
                    Text(lecture)
                        .padding()
                        .border(Color.secondary)
                }
                .padding()

                HStack() {
                    Image(systemName: "lock.square.fill")
                    Text("Level 3")
                        .font(.title2)
                }
                
                ForEach(lectures.level3, id: \.self) { lecture in
                    Text(lecture)
                        .padding()
                        .border(Color.secondary)
                }
                .padding()

                HStack() {
                    Image(systemName: "lock.square.fill")
                    Text("Level 4")
                        .font(.title2)
                }
                
                ForEach(lectures.level4, id: \.self) { lecture in
                    Text(lecture)
                        .padding()
                        .border(Color.secondary)
                }
                .padding()

                HStack() {
                    Image(systemName: "lock.square.fill")
                    Text("Level 5")
                        .font(.title2)
                }
                
                ForEach(lectures.level5, id: \.self) { lecture in
                    Text(lecture)
                        .padding()
                        .border(Color.secondary)
                }
                .padding()
            }
        }
    }
}

struct LecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesView()
    }
}
