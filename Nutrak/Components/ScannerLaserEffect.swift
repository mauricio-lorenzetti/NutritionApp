//
//  ScannerLaserEffect.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 27/03/25.
//


import SwiftUI

struct ScannerLaserEffect: View {
    @State private var position: CGFloat = 0
    @State private var movingDown = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Laser line
                Rectangle()
                    .fill(Color.green)
                    .frame(width: geometry.size.width, height: 4)
                    .offset(y: position)
                    .opacity(0.6)
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                    position = movingDown ? geometry.size.height : 0
                    movingDown.toggle()
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        RoundedRectangle(cornerRadius: 24)
            .stroke(Color.white, lineWidth: 2)
            .frame(width: 300, height: 300)
        
        ScannerLaserEffect()
            .frame(width: 300, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    .frame(width: 400, height: 400)
}
