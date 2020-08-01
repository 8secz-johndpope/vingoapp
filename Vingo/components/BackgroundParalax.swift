//
//  BackgroundParalax.swift
//  Vingo
//
//  Created by Andrey Zhevlakov on 27.07.2020.
//

import SwiftUI

let emoji = ["🐶","🔥","🏛","🏛"]

struct BackgroundParalax: View {
    var body: some View {
        Group {
            ForEach(-5..<15) { y in
                Group {
                    ForEach(-5..<15) { x in
                        Text(emoji[Int.random(in: 0..<4)])
                            .font(.largeTitle)
                            .position(x: CGFloat(x*50)+20, y: CGFloat(y*45)+20)
                            .opacity(0.2)
                    }
                }
            }
        }.rotationEffect(.degrees(-20))
    }
}

struct BackgroundParalax_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundParalax()
    }
}
