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
                .offset(y: -45)
            Text(self.picture.quest)
                .font(.largeTitle)
                .frame(width: UIScreen.main.bounds.width-30, height: 100)
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
                .offset(y: -45)
            Text(self.room.title)
                .font(.largeTitle)
                .frame(width: UIScreen.main.bounds.width-30, height: 100)
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
                .modifier(Shake(animatableData: CGFloat(self.attempts)))
                .onTapGesture { self.attempts += 1 }
        }
        .padding(.horizontal, 10.0)

    }
}
