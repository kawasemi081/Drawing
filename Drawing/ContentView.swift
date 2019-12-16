//
//  ContentView.swift
//  Drawing
//
//  Created by misono on 2019/12/16.
//  Copyright © 2019 misono. All rights reserved.
//  Text: https://www.hackingwithswift.com/100/swiftui/43

import SwiftUI

struct ContentView: View {

    var body: some View {
        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
        .stroke(Color.blue, lineWidth: 10)
        .frame(width: 300, height: 300)
//        Triangle()
//        /// - Note: Shapes also support the same StrokeStyle parameter for creating more advanced strokes
//        .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
////        .fill(Color.red)
//        .frame(width: 300, height: 300)
    }

//    var body: some View {
//        /// - Note: Paths have lots of methods for creating shapes with squares, circles, arcs, and lines. For our triangle we need to move to a stating position, then add three lines like this
//        Path { path in
//            path.move(to: CGPoint(x: 200, y: 100))
//            path.addLine(to: CGPoint(x: 100, y: 300))
//            path.addLine(to: CGPoint(x: 300, y: 300))
//            path.addLine(to: CGPoint(x: 200, y: 100))
//            /// - Note: One way to fix the top corner is broken is just to draw the first line again, which means the last line has a connecting line to match up with
////            path.addLine(to: CGPoint(x: 100, y: 300))
//        }
//        /// - Note: This is particularly useful because one of the options for join and cap is .round, which creates gently rounded shapes
//        ///   With that in place you can remove the extra line from our path, because it’s no longer needed.
//        ///   Using rounded corners solves the problem of our rough edges, but it doesn’t solve the problem of fixed coordinates.
//        .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//        /**
//         - Note: That doesn’t look quite right, though – the bottom corners of our triangle are nice and sharp, but the top corner is broken. This happens because SwiftUI makes sure lines connect up neatly with what comes before and after rather than just being a series of individual lines, but our last line has nothing after it so there’s no way to make a connection.
//         */
////       .stroke(Color.blue, lineWidth: 10)
////        .fill(Color.blue)
//
//    }

    
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        /**
         SwiftUI implements Shape as a protocol with a single required method: given the following rectangle, what path do you want to draw? This will still create and return a path just like using a raw path directly, but because we’re handed the size the shape will be used at we know exactly how big to draw our path – we no longer need to rely on fixed coordinates.

         - Note: That job is made much easier by CGRect, which provides helpful properties such as minX (the smallest X value in the rectangle), maxX (the largest X value in the rectangle), and midX (the mid-point between minX and maxX).
         */
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

/**
 The key to understanding the difference between Path and Shape is reusability: paths are designed to do one specific thing, whereas shapes have the flexibility of drawing space and can also accept parameters to let us customize them further.

 To demonstrate this, we could create an Arc shape that accepts three parameters: start angle, end angle, and whether to draw the arc clockwise or not. This might seem simple enough, particularly because Path has an addArc() method, but as you’ll see it has a couple of interesting quirks.
 */
struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    /**
    If you look at the preview of our arc, chances are it looks nothing like you expect. We asked for an arc from 0 degrees to 110 degrees with a clockwise rotation, but we appear to have been given an arc from 90 degrees to 200 degrees with a counterclockwise rotation.

    What’s happening here is two-fold:

    1. In the eyes of SwiftUI 0 degrees is not straight upwards, but instead directly to the right.
    2. Shapes measure their coordinates from the bottom-left corner rather than the top-left corner, which means SwiftUI goes the other way around from one angle to the other. This is, in my not very humble opinion, extremely alien.
    - Note: We can fix both of those problems with a new path(in:) method that subtracts 90 degrees from the start and end angles, and also flips the direction so SwiftUI behaves the way nature intended:
    */
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }

//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
//
//        return path
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
