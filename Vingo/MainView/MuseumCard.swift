//
//  MuseumCard.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 18.07.2020.
//

import SwiftUI

struct MuseumCard: View {
    public let museum: Museum
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(museum.image).resizable()
                .renderingMode(.original)
                .frame(width: UIScreen.main.bounds.width-80.0, height: 400.0)
                .mask(RoundedRectangle(cornerRadius: 40.0))
                .shadow(radius: 10.0)
                .scaledToFill()
            
            RoundedRectangle(cornerRadius: 40.0)
                .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                .frame(width: UIScreen.main.bounds.width-80.0, height: 400.0)
                .mask(ZStack {
                    Circle().frame(width: 300, height: 300).offset(x: 50, y: 220)
                    Circle().stroke(lineWidth: 5).frame(width: 330, height: 330).offset(x: 50, y: 220)
                })
            
            VStack(alignment: .leading, spacing: 10.0) {
                Text(museum.subtitle)
                    .font(.custom("Futura", size: 35))
                    .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .kerning(-2.3)
                
                Text(museum.title)
                    .font(.custom("Futura", size: 35))
                    .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .kerning(-2.3)
                    .padding(.top, -25.0)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(width: 200, height: 5)
                    .foregroundColor(.white)
            }.padding(.all, 30.0)
        }.padding(.top, 20.0)
    }
}
