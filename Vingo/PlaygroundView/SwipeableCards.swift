//
//  SwipeableCards.swift
//  Vingo
//
//  Created by Andrey Zhevlakov on 22.07.2020.
//

import SwiftUI

struct SwipeableCards: View {
    public let map: ArraySlice<Room>
    @Binding public var current: Int

    @State private var draggedOffset = CGSize.zero
    @State var size: CGSize = .zero
    public var width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(self.map, id: \.id) { room in
                Group() {
                    RoomCard(room: room)
                    ForEach(room.pictures, id: \.id) { picture in
                        PictureCard(picture: picture)
                    }
                }
            }
        }
        .padding()
        .animation(.spring())
        .background( GeometryReader { proxy in Color.clear.onAppear {
            self.size = proxy.size
        }})
        .offset(x: CGFloat(Int(self.size.width)/2) - UIScreen.main.bounds.width/2 - 10 - self.draggedOffset.width)
        .gesture(DragGesture()
            .onChanged { value in
                self.draggedOffset.width = self.width * CGFloat(self.current) - value.translation.width
            }
            .onEnded { value in
                let count = self.map.count
                if (value.translation.width < -100) {
                    self.current += 1
                }
                if (value.translation.width > 100) {
                    self.current -= 1
                }
                self.draggedOffset.width = self.width * CGFloat(self.current)
            })
    }
}
