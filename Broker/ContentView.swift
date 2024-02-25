//
//  ContentView.swift
//  Broker
//
//  Created by 何偉銘 on 2/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "person")
                }
            HomeView()
                .tabItem {
                    Label("news", systemImage: "square.text.square.fill")
                }
            HomeView()
                .tabItem {
                    Label("Club", systemImage: "star")
                }
            HomeView()
                .tabItem {
                    Label("Lecture", systemImage: "books.vertical.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
