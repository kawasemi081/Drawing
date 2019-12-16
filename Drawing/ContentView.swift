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
        /// - Note: Paths have lots of methods for creating shapes with squares, circles, arcs, and lines. For our triangle we need to move to a stating position, then add three lines like this
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
            /// - Note: One way to fix the top corner is broken is just to draw the first line again, which means the last line has a connecting line to match up with
//            path.addLine(to: CGPoint(x: 100, y: 300))
        }
        /// - Note: This is particularly useful because one of the options for join and cap is .round, which creates gently rounded shapes
        ///   With that in place you can remove the extra line from our path, because it’s no longer needed.
        ///   Using rounded corners solves the problem of our rough edges, but it doesn’t solve the problem of fixed coordinates.
        .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        /**
         - Note: That doesn’t look quite right, though – the bottom corners of our triangle are nice and sharp, but the top corner is broken. This happens because SwiftUI makes sure lines connect up neatly with what comes before and after rather than just being a series of individual lines, but our last line has nothing after it so there’s no way to make a connection.
         */
//       .stroke(Color.blue, lineWidth: 10)
//        .fill(Color.blue)

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
