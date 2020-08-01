//
//  AchievementView.swift
//  Vingo
//
//  Created by Andrey Zhevlakov on 31.07.2020.
//

import SwiftUI

var colors = [Color(#colorLiteral(red: 0.9953433871, green: 0, blue: 0.5229544044, alpha: 0.1237425086)), Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 0.125775899)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 0.2520601455))]

struct Achiv: View {
    public var data: Achievement

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: data.rx).foregroundColor(colors[Int.random(in: 0..<3)])
            Text(data.icon).font(.system(size: min(data.height-10, data.width/2))).grayscale(0.95)
        }
        .offset(x: data.x, y: data.y)
        .frame(width: data.width, height: data.height)
        .overlay(RoundedRectangle(cornerRadius: data.rx)
            .strokeBorder(style: StrokeStyle(lineWidth: 4))
            .foregroundColor(Color.clear)
            .offset(x: data.x, y: data.y))
    }
}

struct AchievementView: View {
    public var achievements: [Achievement]
    @EnvironmentObject var app: AppStore

    var body: some View {
        ScrollView(Axis.Set.horizontal, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                ForEach(achievements) { item in
                    Achiv(data: item).onTapGesture {
                        self.app.activeAchievement = item
                        self.app.storyMode = true
                    }
                }
                Image("rama").offset(y: 160)
            }
            .padding(.horizontal, 20)
            .frame(width: 1050, height: 280)
            .offset(x: -10, y: -60)
        }
    }
}
