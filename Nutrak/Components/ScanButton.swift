//
//  ScanButton.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI

struct ScanButton: View {
    @Binding var selectedTab: TabItem
    var onScanButtonTapped: () -> Void
    
    var body: some View {
        Button(action: {
            selectedTab = .scan
            onScanButtonTapped()
        }) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [Color(hex: "FFBF62"), Color.primary]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.primary, Color(hex: "98671E")]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 30
                                ),
                                lineWidth: 1
                            )
                    )
                
                Image(systemName: TabItem.scan.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.black)
            }
        }
        .offset(y: 0)
    }
}

#Preview {
    ScanButton(selectedTab: .constant(.scan)) {}
}
