//
//  PlaceholderView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI

struct PlaceholderView: View {
    let tabItem: TabItem
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Coming Soon: \(tabItem.title)")
                    .font(.title)
                    .foregroundColor(.gray)
                    .background(Color.white)
            }
            .navigationTitle(tabItem.title)
        }
    }
}

#Preview {
    PlaceholderView(tabItem: .profile)
}
