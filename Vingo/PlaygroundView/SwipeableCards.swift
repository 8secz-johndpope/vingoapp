import SwiftUI


struct Test: View {
     var map: [MuseumElement]
     var ind: Int

    static func makeView(_ element: MuseumElement) -> AnyView {
        print(element)
        
        if let room = element as? Room {
            return AnyView(RoomCard(room: room))
        } else if let picture = element as? Picture {
            return AnyView(PictureCard(picture: picture))
        } else {
            return AnyView(Text("ПОШЕЛ НАХУЙ"))
        }
    }

    var body: some View {
        ForEach(self.map[max(0, self.ind-1)..<self.ind+4], id: \.id) { element in
            Test.makeView(element)
        }
    }
    
}


struct SwipeableCards: View {
    @EnvironmentObject var app: AppStore

    public var width = UIScreen.main.bounds.width
    @State private var draggedOffset = CGSize.zero
    @State var size: CGSize = .zero
    @State var toggleAnim = false

    var body: some View {
        
        CarouselView(index: self.$app.selectedIndex, storyMode: self.$app.storyMode, itemHeight: 100, views: [
            Test.makeView(self.app.map[max(0, self.app.selectedIndex-3)]),
            Test.makeView(self.app.map[max(0, self.app.selectedIndex-2)]),
            Test.makeView(self.app.map[max(0, self.app.selectedIndex-1)]),
            Test.makeView(self.app.map[max(0, self.app.selectedIndex)]),
            Test.makeView(self.app.map[max(0, self.app.selectedIndex+1)]),
            Test.makeView(self.app.map[max(0, self.app.selectedIndex+2)]),
            Test.makeView(self.app.map[max(0, self.app.selectedIndex+3)]),
        ])

        /**
        HStack(alignment: .bottom, spacing: 10) {
            Test(map: self.app.map, ind: self.app.selectedIndex)
        }.onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {_ in
                self.toggleAnim.toggle()
            }
        }
        .padding()
        .background( GeometryReader { proxy in Color.clear.onAppear {
            self.size = proxy.size
        }})
        .offset(x: CGFloat(Int(self.size.width)/2) - UIScreen.main.bounds.width - 10  + self.draggedOffset.width)
        .gesture(DragGesture()
            .onChanged { value in
                if (abs(value.translation.height) > 10) {
                    self.draggedOffset.height = value.translation.height
                    return
                }
                
                self.draggedOffset.width = value.translation.width
            }
            .onEnded { value in
                if (value.translation.width < -100) {
                    self.app.selectedIndex += 1
                }
                if (value.translation.width > 100) {
                    self.app.selectedIndex -= 1
                }
                
                if (value.translation.height < -50) {
                    self.app.storyMode = true
                }

                withAnimation(.spring()) {
                    self.draggedOffset.width = self.width * CGFloat(self.app.selectedIndex)
                }
                self.draggedOffset.width = 0
            })
        **/
    }
}
