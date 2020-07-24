//
//  QuestCard.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 17.07.2020.
//

import SwiftUI

struct PictureCard: View {
    var picture: Picture
    
    @State var attempts: Int = 0
     
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(.white)
                .rotationEffect(Angle.degrees(45))
                .frame(width: 20, height: 20)
                .offset(y: -55)
            Text(self.picture.quest)
                .font(.largeTitle)
                .frame(width: UIScreen.main.bounds.width-30, height: 120)
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
                .modifier(Shake(animatableData: CGFloat(self.attempts)))
                .onTapGesture { self.attempts += 1 }
        }
        .padding(.horizontal, 10.0)

    }
}

struct RoomCard: View {
    var room: Room
    
    @State var attempts: Int = 0
     
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(.white)
                .rotationEffect(Angle.degrees(45))
                .frame(width: 20, height: 20)
                .offset(y: -55)
            VStack(alignment: .leading) {
                Text(self.room.title)
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                    .kerning(-1.5)
                Text(self.room.description)
                    .font(.custom("PT Sans", size: 14))
                    .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .fontWeight(.bold)
                    .kerning(-0.75)
                    .lineSpacing(-5)
                    .padding(.top, 5.0)
            }.padding()
            .frame(width: UIScreen.main.bounds.width-30, height: 120)
            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
            .modifier(Shake(animatableData: CGFloat(self.attempts)))
            .onTapGesture { self.attempts += 1 }
        }
        .padding(.horizontal, 10.0)

    }
}
