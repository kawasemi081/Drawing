//
//  ContentView.swift
//  Drawing
//
//  Created by misono on 2019/12/16.
//  Copyright © 2019 misono. All rights reserved.
//  Text: https://www.hackingwithswift.com/100/swiftui/46

import SwiftUI

/**
 # Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 1. Create an Arrow shape made from a rectangle and a triangle – having it point straight up is fine.
 2. Make the line thickness of your Arrow shape animatable.
 3. Create a ColorCyclingRectangle shape that is the rectangular cousin of ColorCyclingCircle, allowing us to control the position of the gradient using a property.
 */

struct ContentView: View {
    @State private var amount: CGFloat = 1.0
    @State private var colorCycle = 0.0
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Arrow()
                .stroke(Color.red, style: StrokeStyle(lineWidth: amount, lineCap: .round, lineJoin: .round))
                .frame(width: 300, height: 300)
//                .border(Color.green, width: 1)
            Spacer()
            Group {
                Text("Amount: \(amount, specifier: "%.2f")")
                Slider(value: $amount, in: 1.0...10.0, step: 1.0)
                    .padding([.bottom])
            }
            Spacer()
            ColorCyclingRectangle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            Spacer()
            Group {
                Text("ColorRectangle: \(colorCycle, specifier: "%.2f")")
                Slider(value: $colorCycle)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Arrow: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let quarterX = rect.midX / 2

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - quarterX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - quarterX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + quarterX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + quarterX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }

}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)

            }

        }.drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}
