//
//  SwipeableCards.swift
//  Vingo
//
//  Created by Andrey Zhevlakov on 22.07.2020.
//

import SwiftUI

struct SwipeableCards: View {
    public let map: [Room]

    @State private var current = 0
    @State private var draggedOffset = CGSize.zero
    public var width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack() {
            ForEach(self.map, id: \.id) { room in
                Group() {
                    RoomCard(room: room)
                    ForEach(room.pictures) { picture in
                        PictureCard(picture: picture)
                    }
                }
            }
        }
        .padding()
        .animation(.spring())
        .offset(x: self.draggedOffset.width)
        .gesture(DragGesture()
            .onChanged { value in
                self.draggedOffset.width = self.width * CGFloat(self.current) + value.translation.width
            }
            .onEnded { value in
                if (value.translation.width > 200 && self.current < 1) {
                    self.current += 1
                }
                if (value.translation.width < -200 && self.current > -1) {
                    self.current -= 1
                }
                self.draggedOffset.width = self.width * CGFloat(self.current)
            })
    }
}
