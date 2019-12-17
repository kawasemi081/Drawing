//
//  ContentView.swift
//  Drawing
//
//  Created by misono on 2019/12/16.
//  Copyright © 2019 misono. All rights reserved.
//  Text: https://www.hackingwithswift.com/100/swiftui/45

import SwiftUI

struct ContentView: View {
    
    @State private var insetAmount: CGFloat = 50

    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                /**
                 Every time you tap the trapezoid, insetAmount gets set to a new value, causing the shape to be redrawn.

                 Wouldn’t it be nice if we could animate the change in inset? Sure it would – try changing the onTapGesture() closure
                 
                - Note: Now run it again, and… nothing has changed. We’ve asked for animation, but we aren’t getting animation – what gives?

                When looking at animations previously, I asked you to add a call to print() inside the body property, then said this:

                ”What you should see is that it prints out 2.0, 3.0, 4.0, and so on. At the same time, the button is scaling up or down smoothly – it doesn’t just jump straight to scale 2, 3, and 4. What’s actually happening here is that SwiftUI is examining the state of our view before the binding changes, examining the target state of our views after the binding changes, then applying an animation to get from point A to point B.”

                So, as soon as self.insetAmount is set to a new random value, it will immediately jump to that value and pass it directly into Trapezoid – it won’t pass in lots of intermediate values as the animation happens. This is why our trapezoid jumps from inset to inset; it has no idea an animation is even happening.
                 
                 - Attention: We can fix this in only four lines of code, one of which is just a closing brace.
                    However, even though this code is simple, the way it works might bend your brain.
                 
                 ## when we use withAnimation()
                 SwiftUI immediately changes our state property to its new value, but behind the scenes it’s also keeping track of the changing value over time as part of the animation. As the animation progresses, **SwiftUI will set the animatableData property of our shape to the latest value**, and it’s down to us to decide what that means – in our case we assign it directly to insetAmount, because that’s the thing we want to animate.
                 */
                withAnimation {
                    self.insetAmount = CGFloat.random(in: 10...90)
                }
//                self.insetAmount = CGFloat.random(in: 10...90)
            }
         
    }
    
    
    /**
     There are lots of other blend modes to choose from, and it’s worth spending some time experimenting to see how they work. Another popular effect is called screen, which does the opposite of multiply: it inverts the colors, performs a multiply, then inverts them again, resulting in a brighter image rather than a darker image.
     
     As an example, we could render three circles at various positions inside a Stack, then use a slider to control their size and overlap
     */
//    @State private var amount: CGFloat = 0.0
//    var body: some View {
//        VStack {
//            ZStack {
//                /**
//                 There are a host of other real-time effects we can apply, and we already looked at blur() back in project 3. So, let’s look at just one more before we move on: saturation(), which adjusts how much color is used inside a view. Give this a value between 0 (no color, just grayscale) and 1 (full color).
//
//                 We could write a little code to demonstrate both blur() and saturation() in the same view
//                 */
//                Image("Henri")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 300)
//                .saturation(Double(amount))
//                .blur(radius: (1 - amount) * 20)
//            }.frame(width: 300, height: 300)
//            Slider(value: $amount).padding()
//        }.frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//        .edgesIgnoringSafeArea(.all)
//    }
//    var body: some View {
//        VStack {
//            ZStack {
//                /**
//                 If you’re particularly observant, you might notice that the fully blended color in the center isn’t quite white – it’s a very pale lilac color. The reason for this is that Color.red, Color.green, and Color.blue aren’t fully those colors; you’re not seeing pure red when you use Color.red. Instead, you’re seeing SwiftUI’s adaptive colors that are designed to look good in both dark mode and light mode, so they are a custom blend of red, green, and blue rather than pure shades.
//
//                 If you want to see the full effect of blending red, green, and blue, you should use custom RGB colors
//                 */
//                Circle()
//                    .fill(Color(red: 1, green: 0, blue: 0))
////                    .fill(Color.red)
//                    .frame(width: 200 * amount)
//                    .offset(x: -50, y: -80)
//                    .blendMode(.screen)
//
//                Circle()
//                    .fill(Color(red: 0, green: 1, blue: 0))
////                    .fill(Color.green)
//                    .frame(width: 200 * amount)
//                    .offset(x: 50, y: -80)
//                    .blendMode(.screen)
//
//                Circle()
//                    .fill(Color(red: 0, green: 0, blue: 1))
////                    .fill(Color.blue)
//                    .frame(width: 200 * amount)
//                    .blendMode(.screen)
//            }
//            .frame(width: 300, height: 300)
//
//            Slider(value: $amount)
//                .padding()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//        .edgesIgnoringSafeArea(.all)
    
        /// - Note: multiply is so common that there’s a shortcut modifier that means we can avoid using a ZStac
//        Image("Henri")
//            .colorMultiply(.red)
        /**
         As an example, we could draw an image inside a ZStack, then add a red rectangle on top that is drawn with the multiply blend mode
         “Multiply” is so named because it multiplies each source pixel color with the destination pixel color – in our case, each pixel of the image and each pixel of the rectangle on top. Each pixel has color values for RGBA, ranging from 0 (none of that color) through to 1 (all of that color), so the highest resulting color will be 1x1, and the lowest will be 0x0.
         */
//        ZStack {
//            Image("Henri")
//            Rectangle()
//                .fill(Color.red)
//                .blendMode(.multiply)
//        }
//        .frame(width: 400, height: 500)
//        .clipped()
//    }
}

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
