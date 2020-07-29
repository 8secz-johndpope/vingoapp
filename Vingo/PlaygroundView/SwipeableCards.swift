import SwiftUI

struct SwipeableCards: View {
    @EnvironmentObject var app: AppStore

    public var width = UIScreen.main.bounds.width
    @State private var draggedOffset = CGSize.zero
    @State var size: CGSize = .zero
    @State var toggleAnim = false
    
    func makeView(_ element: MuseumElement) -> AnyView {
        if let room = element as? Room {
            return AnyView(RoomCard(room: room))
        } else if let picture = element as? Picture {
            return AnyView(PictureCard(picture: picture))
        } else {
            return AnyView(Text("ПОШЕЛ НАХУЙ"))
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ForEach(self.app.map[max(self.app.selectedIndex-3, 0)..<self.app.selectedIndex+3], id: \.id) { element in
                self.makeView(element).offset(x: CGFloat(element.index)*UIScreen.main.bounds.width)
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
