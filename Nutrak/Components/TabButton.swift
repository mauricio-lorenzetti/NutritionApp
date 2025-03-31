//
//  TabButton.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI

struct TabButton: View {
    @Binding var selectedTab: TabItem
    let tabItem: TabItem
    
    var body: some View {
        let isSelected = selectedTab == tabItem
        
        Button(action: {
            selectedTab = tabItem
        }, label: {
            VStack(spacing: 12) {
                Image(systemName: tabItem.icon)
                    .font(.system(size: 25,
                                  weight: .regular,
                                  design: .default))
                    .foregroundStyle(isSelected ? .black : .gray)
                    .frame(height: 24, alignment: .center)

                Text(tabItem.title)
                    .font(.system(size: 14,
                                  weight: isSelected ? .medium : .bold))
                    .foregroundStyle(isSelected ? .black : .gray)
                    .lineLimit(1)
                    .frame(width: 60, alignment: .center)
            }
        })
    }
}
