//
//  CustomTabBar.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    var onScanButtonTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                ForEach(TabItem.allCases, id: \.self) { tabItem in
                    Spacer()
                    if case .scan = tabItem {
                        ScanButton(
                            selectedTab: $selectedTab,
                            onScanButtonTapped: onScanButtonTapped
                        )
                    } else {
                        TabButton(selectedTab: $selectedTab,
                                  tabItem: tabItem)
                    }
                    Spacer()
                }
            }
        }
        .background(Color.white)
        .frame(height: 60)
        .padding(12)
        .padding(.bottom, 34)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home)) { }
}
