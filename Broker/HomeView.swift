//
//  HomeView.swift
//  Broker
//
//  Created by 何偉銘 on 2/25/24.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
