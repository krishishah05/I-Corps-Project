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
            NewsView()
                .tabItem {
                    Label("News", systemImage: "square.text.square.fill")
                }
            ClubView()
                .tabItem {
                    Label("Club", systemImage: "star")
                }
            LecturesView()
                .tabItem {
                    Label("Lectures", systemImage: "books.vertical.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
