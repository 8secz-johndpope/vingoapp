//
//  QuestCard.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 17.07.2020.
//

import SwiftUI

struct FitToWidth: ViewModifier {
    var fraction: CGFloat = 1.0
    func body(content: Content) -> some View {
        GeometryReader { g in
        content
            .font(.system(size: 1000))
            .minimumScaleFactor(0.005)
            .lineLimit(1)
            .frame(width: g.size.width*self.fraction)
        }
    }
}

struct SmallCard<Content: View>: View {
    var content: () -> Content

    @State var attempts: Int = 0
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
     
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(.white)
                .rotationEffect(Angle.degrees(45))
                .frame(width: 20, height: 20)
                .offset(y: -55)
            content().padding()
        }
        .frame(width: UIScreen.main.bounds.width-30, height: 120)
        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
        .modifier(Shake(animatableData: CGFloat(self.attempts)))
        .onTapGesture { self.attempts += 1 }
        .padding(.horizontal, 10.0)
    }
}

struct PictureCard: View {
    var picture: Picture
    var completed: Bool
     
    var body: some View {
        SmallCard {
            if !self.completed {
                Text(self.picture.quest).modifier(FitToWidth())
            } else {
                VStack(alignment: .leading) {
                    Text(self.picture.title)
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                        .kerning(-1.5)
                    Text(self.picture.description ?? "")
                        .font(.custom("PT Sans", size: 14))
                        .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                        .fontWeight(.bold)
                        .kerning(-0.75)
                        .lineSpacing(-5)
                        .padding(.top, 5.0)
                }
            }
        }
    }
}

struct RoomCard: View {
    var room: Room
    
    var body: some View {
        SmallCard {
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
            }
        }
    }
}
