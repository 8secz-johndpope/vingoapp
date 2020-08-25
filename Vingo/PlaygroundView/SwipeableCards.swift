import SwiftUI

struct SwipeableCards: View {
    @EnvironmentObject var app: AppStore

    public var width = UIScreen.main.bounds.width
    @State private var draggedOffset = CGSize.zero
    @State var size: CGSize = .zero
    @State var toggleAnim = false
    @State var offset: CGFloat = 0;
    
    func makeView(_ element: MuseumElement) -> AnyView {
        if let room = element as? Room {
            return AnyView(RoomCard(room: room))
        } else if let picture = element as? Picture {
            return AnyView(PictureCard(picture: picture, completed: self.app.completed.contains(picture.id)))
        } else {
            return AnyView(Text(""))
        }
    }
    
    func getOffset() -> CGFloat {
        let start = CGFloat(Int(self.size.width)/2) - UIScreen.main.bounds.width/2 - 10;
        let offset = self.width * CGFloat(self.app.selectedIndex);
    
        return start - offset;
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ForEach(self.app.map[max(0, self.app.selectedIndex-2)..<min(self.app.selectedIndex+3, self.app.map.count)], id: \.id) { element in
                self.makeView(element).offset(x: CGFloat(element.index)*UIScreen.main.bounds.width)
            }
        }
        .padding()
        .offset(x: self.offset)
        .animation(.easeOut)
        .background( GeometryReader { proxy in Color.clear.onAppear {
            self.size = proxy.size
        }})
        .gesture(DragGesture()
            .onChanged { value in
                self.offset = self.getOffset() + value.translation.width
            }
            .onEnded { value in
                if (value.translation.width < -100) {
                    self.app.selectedIndex += 1
                }

                if (value.translation.width > 100) {
                    self.app.selectedIndex -= 1
                }
                
                if (value.translation.height < -50) {
                    self.app.activeStory = self.app.map[self.app.selectedIndex]
                    self.app.storyMode = true
                }

                self.offset = self.getOffset()
            })
    }
}
