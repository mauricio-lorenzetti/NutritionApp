//
//  RoundedRectangleCutout.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 27/03/25.
//

import SwiftUI

struct RoundedRectangleOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            let cutoutHeight = UIScreen.main.bounds.height * 0.36
            let cutoutWidth = cutoutHeight
            let cutoutX = geometry.size.width / 2
            let cutoutY = geometry.size.height * 0.45
            let cornerRadius = 20.0
            let lineWidth = 3.0
            
            ZStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white)
                        .frame(width: cutoutWidth, height: cutoutHeight)
                        .position(x: cutoutX, y: cutoutY)
                        .blendMode(.destinationOut)
                    
                    ScannerLaserEffect()
                        .frame(width: cutoutWidth - cornerRadius,
                               height: cutoutHeight - lineWidth)
                        .position(x: cutoutX, y: cutoutY)
                    
                    RoundedCornerBrackets(width: cutoutWidth,
                                          height: cutoutHeight,
                                          cornerRadius: cornerRadius)
                    .stroke(Color.white, lineWidth: lineWidth)
                    .frame(width: cutoutWidth, height: cutoutHeight)
                    .position(x: cutoutX, y: cutoutY)
                }
                .compositingGroup()
            }
        }
        .ignoresSafeArea()
    }
}

struct RoundedCornerBrackets: Shape {
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    let cornerLength: CGFloat = 30
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top left corner
        path.move(to: CGPoint(x: 0, y: cornerRadius + cornerLength))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: cornerRadius + cornerLength, y: 0))
        
        // Top right corner
        path.move(to: CGPoint(x: width - cornerRadius - cornerLength, y: 0))
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addArc(
            center: CGPoint(x: width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: width, y: cornerRadius + cornerLength))
        
        // Bottom right corner
        path.move(to: CGPoint(x: width, y: height - cornerRadius - cornerLength))
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        path.addArc(
            center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: width - cornerRadius - cornerLength, y: height))
        
        // Bottom left corner
        path.move(to: CGPoint(x: cornerRadius + cornerLength, y: height))
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: 0, y: height - cornerRadius - cornerLength))
        
        return path
    }
}
#Preview {
    ZStack {
        Color.teal
        RoundedRectangleOverlay()
    }
    .frame(width: .infinity, height: .infinity, alignment: .center)
    .ignoresSafeArea()
}
