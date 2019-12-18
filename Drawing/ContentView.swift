//
//  ContentView.swift
//  Drawing
//
//  Created by misono on 2019/12/16.
//  Copyright © 2019 misono. All rights reserved.
//  Text: https://www.hackingwithswift.com/100/swiftui/45

import SwiftUI

/**
  “Spirograph” is the trademarked name for a toy where you place a pencil inside a circle and spin it around the circumference of another circle, creating various geometric patterns that are known as roulettes – like the casino game.
 Our algorithm has four inputs

 - The radius of the inner circle.
 - The radius of the outer circle.
 - The distance of the virtual pen from the center of the outer circle.
 - What amount of the roulette to draw. This is optional, but I think it really helps show what’s happening as the algorithm works.
 */
struct ContentView: View {
    /// - Note: we can now use that shape in a view, adding various sliders to control the inner radius, outer radius, distance, amount, and even color
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)

            Spacer()

            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Amount: \(amount, specifier: "%.2f")")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])

                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
            }
        }
    }

}

struct Spirograph: Shape {

    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat

    /**
     The other two values are the difference between the inner radius and outer radius, and how many steps we need to perform to draw the roulette – this is 360 degrees multiplied by the outer radius divided by the greatest common divisor, multiplied by our amount input.

     - Note: We then prepare three values from that data, starting with the greatest common divisor (GCD) of the inner radius and outer radius. Calculating the GCD of two numbers is usually done with Euclid's algorithm, which in a slightly simplified form looks like this
     */
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }
    /**
     I just converted the standard equation to Swift from Wikipedia – this is not something I would dream of memorizing!

     - X is equal to the radius difference multiplied by the cosine of theta, added to the distance multiplied by the cosine of the radius difference divided by the outer radius multiplied by theta.
     - Y is equal to the radius difference multiplied by the sine of theta, subtracting the distance multiplied by the sine of the radius difference divided by the outer radius multiplied by theta.
     */
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount

        /**
         - Note: That’s the core algorithm, but we’re going to make two small changes: we’re going to add to X and Y half the width or height of our drawing rectangle respectively so that it’s centered in our drawing space, and if theta is 0 – i.e., if this is the first point in our roulette being drawn – we’ll call move(to:) rather than addLine(to:) for our path.
         */
        var path = Path()

        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }

}

/**
 # AnimatablePair
 SwiftUI uses **an animatableData property to let us animate changes to shapes**, but what happens when we want two, three, four, or more properties to animate? animatableData is a property, which means it must always be one value, however we get to decide what type of value it is: it might be a single CGFloat, or it might be two values contained in a special wrapper called AnimatablePair.
 */
//struct ContentView: View {
//    @State private var rows = 4
//    @State private var columns = 4
//
//    var body: some View {
//        Checkerboard(rows: rows, columns: columns)
//            .onTapGesture {
//                /**
//                 When that runs you should be able to tap on the black squares to see the checkerboard jump from being 4x4 to 8x16, without animation even though the change is inside a withAnimation() block.
//
//                 As with simpler shapes, the solution here is to implement an animatableData property that will be set with intermediate values as the animation progresses. Here, though, there are two catches:
//                    1. We have two properties that we want to animate, not one.
//                    2. Our row and column properties are integers, and SwiftUI can’t interpolate integers.
//
//                 - Note: To resolve the first problem we’re going to use a new type called AnimatablePair.
//                 */
//                withAnimation(.linear(duration: 3)) {
//                    self.rows = 8
//                    self.columns = 16
//                }
//            }
//    }
//}

/// - Note: To try this out, let’s look at a new shape called Checkerboard, which must be created with some number of rows and columns
struct Checkerboard: Shape {
    /**
     To resolve the second problem we’re just going to do some type conversion: we can convert a Double to an Int just by using Int(someDouble), and go the other way by using Double(someInt).

     So, to make our checkerboard animate changes in the number of rows and columns, add this property
     */
    public var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(Double(rows), Double(columns))
        }
        /**
         # Of course, the next question is: how do we animate three properties? Or four?

         To answer that, let me show you the animatableData property for SwiftUI’s **EdgeInsets** type:

         `AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>`
         Yes, they use three separate animatable pairs, then just dig through them using code such as newValue.second.second.first.

         I’m not going to claim this is the most elegant of solutions, but I hope you can understand why it exists: because SwiftUI can read and write the animatable data for a shape regardless of what that data is or what it means, it doesn’t need to re-invoke the body property of our views 60 or even 120 times a second during an animation – it just changes the parts that actually are changing.
         */
        set {
            /// - Note:  As its name suggests, this contains a pair of animatable values, and because both its values can be animated the AnimatablePair can itself be animated. We can read individual values from the pair using .first and .second.
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }
    var rows: Int
    var columns: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}

//struct ContentView: View {
//
//    @State private var insetAmount: CGFloat = 50
//
//    var body: some View {
//        Trapezoid(insetAmount: insetAmount)
//            .frame(width: 200, height: 100)
//            .onTapGesture {
//                /**
//                 Every time you tap the trapezoid, insetAmount gets set to a new value, causing the shape to be redrawn.
//
//                 Wouldn’t it be nice if we could animate the change in inset? Sure it would – try changing the onTapGesture() closure
//
//                - Note: Now run it again, and… nothing has changed. We’ve asked for animation, but we aren’t getting animation – what gives?
//
//                When looking at animations previously, I asked you to add a call to print() inside the body property, then said this:
//
//                ”What you should see is that it prints out 2.0, 3.0, 4.0, and so on. At the same time, the button is scaling up or down smoothly – it doesn’t just jump straight to scale 2, 3, and 4. What’s actually happening here is that SwiftUI is examining the state of our view before the binding changes, examining the target state of our views after the binding changes, then applying an animation to get from point A to point B.”
//
//                So, as soon as self.insetAmount is set to a new random value, it will immediately jump to that value and pass it directly into Trapezoid – it won’t pass in lots of intermediate values as the animation happens. This is why our trapezoid jumps from inset to inset; it has no idea an animation is even happening.
//
//                 - Attention: We can fix this in only four lines of code, one of which is just a closing brace.
//                    However, even though this code is simple, the way it works might bend your brain.
//
//                 ## when we use withAnimation()
//                 SwiftUI immediately changes our state property to its new value, but behind the scenes it’s also keeping track of the changing value over time as part of the animation. As the animation progresses, **SwiftUI will set the animatableData property of our shape to the latest value**, and it’s down to us to decide what that means – in our case we assign it directly to insetAmount, because that’s the thing we want to animate.
//                 */
//                withAnimation {
//                    self.insetAmount = CGFloat.random(in: 10...90)
//                }
////                self.insetAmount = CGFloat.random(in: 10...90)
//            }
//
//    }
//
//
//    /**
//     There are lots of other blend modes to choose from, and it’s worth spending some time experimenting to see how they work. Another popular effect is called screen, which does the opposite of multiply: it inverts the colors, performs a multiply, then inverts them again, resulting in a brighter image rather than a darker image.
//
//     As an example, we could render three circles at various positions inside a Stack, then use a slider to control their size and overlap
//     */
////    @State private var amount: CGFloat = 0.0
////    var body: some View {
////        VStack {
////            ZStack {
////                /**
////                 There are a host of other real-time effects we can apply, and we already looked at blur() back in project 3. So, let’s look at just one more before we move on: saturation(), which adjusts how much color is used inside a view. Give this a value between 0 (no color, just grayscale) and 1 (full color).
////
////                 We could write a little code to demonstrate both blur() and saturation() in the same view
////                 */
////                Image("Henri")
////                .resizable()
////                .scaledToFit()
////                .frame(width: 300, height: 300)
////                .saturation(Double(amount))
////                .blur(radius: (1 - amount) * 20)
////            }.frame(width: 300, height: 300)
////            Slider(value: $amount).padding()
////        }.frame(maxWidth: .infinity, maxHeight: .infinity)
////        .background(Color.black)
////        .edgesIgnoringSafeArea(.all)
////    }
////    var body: some View {
////        VStack {
////            ZStack {
////                /**
////                 If you’re particularly observant, you might notice that the fully blended color in the center isn’t quite white – it’s a very pale lilac color. The reason for this is that Color.red, Color.green, and Color.blue aren’t fully those colors; you’re not seeing pure red when you use Color.red. Instead, you’re seeing SwiftUI’s adaptive colors that are designed to look good in both dark mode and light mode, so they are a custom blend of red, green, and blue rather than pure shades.
////
////                 If you want to see the full effect of blending red, green, and blue, you should use custom RGB colors
////                 */
////                Circle()
////                    .fill(Color(red: 1, green: 0, blue: 0))
//////                    .fill(Color.red)
////                    .frame(width: 200 * amount)
////                    .offset(x: -50, y: -80)
////                    .blendMode(.screen)
////
////                Circle()
////                    .fill(Color(red: 0, green: 1, blue: 0))
//////                    .fill(Color.green)
////                    .frame(width: 200 * amount)
////                    .offset(x: 50, y: -80)
////                    .blendMode(.screen)
////
////                Circle()
////                    .fill(Color(red: 0, green: 0, blue: 1))
//////                    .fill(Color.blue)
////                    .frame(width: 200 * amount)
////                    .blendMode(.screen)
////            }
////            .frame(width: 300, height: 300)
////
////            Slider(value: $amount)
////                .padding()
////        }
////        .frame(maxWidth: .infinity, maxHeight: .infinity)
////        .background(Color.black)
////        .edgesIgnoringSafeArea(.all)
//
//        /// - Note: multiply is so common that there’s a shortcut modifier that means we can avoid using a ZStac
////        Image("Henri")
////            .colorMultiply(.red)
//        /**
//         As an example, we could draw an image inside a ZStack, then add a red rectangle on top that is drawn with the multiply blend mode
//         “Multiply” is so named because it multiplies each source pixel color with the destination pixel color – in our case, each pixel of the image and each pixel of the rectangle on top. Each pixel has color values for RGBA, ranging from 0 (none of that color) through to 1 (all of that color), so the highest resulting color will be 1x1, and the lowest will be 0x0.
//         */
////        ZStack {
////            Image("Henri")
////            Rectangle()
////                .fill(Color.red)
////                .blendMode(.multiply)
////        }
////        .frame(width: 400, height: 500)
////        .clipped()
////    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Trapezoid: Shape {
    /// - Note: First, the code – add this new computed property to the Trapezoid struct now
    var animatableData: CGFloat {
        get { insetAmount }
        set {
            /**
              - Important:
                Remember, SwiftUI evaluates our view state before an animation was applied and then again after. It can see we originally had code that evaluated to Trapezoid(insetAmount: 50), but then after a random number was chosen we ended up with (for example) Trapezoid(insetAmount: 62). So, it will interpolate between 50 and 62 over the length of our animation, each time setting the animatableData property of our shape to be that latest interpolated value – 51, 52, 53, and so on, until 62 is reached.
             */
//            print("insetAmount\(newValue)")
            self.insetAmount = newValue }
    }
    var insetAmount: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
   }
}
