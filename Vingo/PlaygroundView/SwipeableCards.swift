import SwiftUI

struct SwipeableCards: View {
    @EnvironmentObject var app: AppStore

    public var width = UIScreen.main.bounds.width
    @State private var draggedOffset = CGSize.zero
    @State var size: CGSize = .zero
    @State var toggleAnim = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(self.app.map, id: \.id) { room in
                Group() {
                    RoomCard(room: room)
                    ForEach(room.pictures, id: \.id) { picture in
                        PictureCard(picture: picture)
                    }
                }.opacity(self.app.activeRoom?.id == room.id ? 1 : 0)
            }
        }.onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {_ in
                self.toggleAnim.toggle()
            }
        }
        .padding()
        .animation(self.toggleAnim ? .spring() : .none)
        .background( GeometryReader { proxy in Color.clear.onAppear {
            self.size = proxy.size
        }})
        .offset(x: CGFloat(Int(self.size.width)/2) - UIScreen.main.bounds.width/2 - 10 - self.draggedOffset.width)
        .gesture(DragGesture()
            .onChanged { value in
                if (abs(value.translation.height) > 10) {
                    self.draggedOffset.height = value.translation.height
                    return
                }
                
                self.draggedOffset.width = self.width * CGFloat(self.app.selectedIndex) - value.translation.width
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

                self.draggedOffset.width = self.width * CGFloat(self.app.selectedIndex)
            })
    }
}
