//
//  ContentView.swift
//  Drawing
//
//  Created by misono on 2019/12/16.
//  Copyright © 2019 misono. All rights reserved.
//  Text: https://www.hackingwithswift.com/100/swiftui/45

import SwiftUI

struct ContentView: View {
    /**
     There are lots of other blend modes to choose from, and it’s worth spending some time experimenting to see how they work. Another popular effect is called screen, which does the opposite of multiply: it inverts the colors, performs a multiply, then inverts them again, resulting in a brighter image rather than a darker image.
     
     As an example, we could render three circles at various positions inside a Stack, then use a slider to control their size and overlap
     */
    @State private var amount: CGFloat = 0.0
    var body: some View {
        VStack {
            ZStack {
                /**
                 There are a host of other real-time effects we can apply, and we already looked at blur() back in project 3. So, let’s look at just one more before we move on: saturation(), which adjusts how much color is used inside a view. Give this a value between 0 (no color, just grayscale) and 1 (full color).

                 We could write a little code to demonstrate both blur() and saturation() in the same view
                 */
                Image("Henri")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .saturation(Double(amount))
                .blur(radius: (1 - amount) * 20)
            }.frame(width: 300, height: 300)
            Slider(value: $amount).padding()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
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
