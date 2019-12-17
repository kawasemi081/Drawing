//
//  ContentView.swift
//  Drawing
//
//  Created by misono on 2019/12/16.
//  Copyright © 2019 misono. All rights reserved.
//  Text: https://www.hackingwithswift.com/100/swiftui/44

import SwiftUI

/**
 ## CGAffineTransform
 how a path or view should be rotated, scaled, or sheared
 ## even-odd fills
 to control how overlapping shapes should be rendered
 ## Proctice
 - The mathematics behind this is relatively straightforward, with one catch: CGAffineTransform measures angles in radians rather than degrees.
 - you need to know is this: 3.141 radians is equal to 180 degrees, so 3.141 radians multiplied by 2 is equal to 360 degrees.
 ### what we’re going to do
 1. Create a new empty path.
 2. Count from 0 up to pi multiplied by 2 (360 degrees in radians), counting in one eighth of pi each time – this will give us 16 petals.
 3. Create a rotation transform equal to the current number.
 4. Add to that rotation a movement equal to half the width and height of our draw space, so each petal is centered in our shape.
 5. Create a new path for a petal, equal to an ellipse of a specific size.
 6. Apply our transform to that ellipse so it’s moved into position.
 7. Add that petal’s path to our main path
 This will make more sense once you see the code running, but first I want to add three more small things:

 - Rotating something then moving it does not produce the same result as moving then rotating, because when you rotate it first the direction it moves will be different from if it were not rotated.
 - To really help you understand what’s going on, we’ll be making our petal ellipses use a couple of properties we can pass in externally.
 - Ranges such as 1...5 are great if you want to count through numbers one a time, but if you want to count in 2s, or in our case count in “pi/8”s, you should use **stride(from:to:by:)** instead.
 */

struct ContentView: View {

    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
            /**
             - Note: If we fill our path using a solid color, we get a fairly unimpressive result.
               - If a path has no overlaps it will be filled.
               - If another path overlaps it, the overlapping part won’t be filled.
               - If a third path overlaps the previous two, then it will be filled.
               - …and so on.
             Only the parts that actually overlap are affected by this rule, and it creates some remarkably beautiful results. Even better, Swift UI makes it trivial to use, because whenever we call fill() on a shape we can pass a FillStyle struct that asks for the even-odd rule to be enabled.
             */
             .fill(Color.red, style: FillStyle(eoFill: true))
            /// - Note: But as an alternative, we can fill the shape using the even-odd rule, which decides whether part of a path should be colored depending on the overlaps it contains.
//            .fill(Color.red)
//            .stroke(Color.red, lineWidth: 1)

            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])

            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Flower: Shape {
    // How much to move this petal away from the center
    var petalOffset: Double = -20

    // How wide to make each petal
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {
        // The path that will hold all petals
        var path = Path()

        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            // rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)

            // move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))

            // create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))

            // apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)

            // add it to our main path
            path.addPath(rotatedPetal)
        }

        // now send the main path back
        return path
    }
}
