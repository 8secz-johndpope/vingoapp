import SwiftUI
import URLImage

struct Story: View {
    @Binding var storyMode: Bool
    public var picture: Picture
    @State private var draggedOffset = CGSize.zero
    @Environment(\.imageCache) var cache: ImageCache
    @State var index = 0
    @State var rotation: Double = 10
    @State var delta: Double = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    func getRotate() -> Double {
        return Double(self.index * 180) + Double(self.draggedOffset.width/10)
    }
    
    func getStories() -> [Substring]? {
        self.picture.description?.split(separator: ".") ?? [""]
    }

    var body: some View {
            VStack(alignment: .center) {
                Group {
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(self.getStories()?.count != 0 ? self.getStories()![self.index] : "")
                                .font(.custom("Futura", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .kerning(-1.3)
                                .shadow(radius: 5)
                        Text(String(self.index) + "/" + String(self.getStories()?.count ?? 0))
                                .font(.custom("Futura", size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .kerning(-1)
                                .padding(.top, 10)
                    }.padding()
                }
                .animation(.none)
                .scaleEffect(CGSize(width: 1 * (index % 2 == 0 ? 1 : -1), height: 1))
            }
            .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height-200)
            .background(URLImage(URL(string: self.picture.original_image ?? "")!) { proxy in
                proxy.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height-200)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    .scaleEffect(CGSize(width: 1 * (self.index % 2 == 0 ? 1 : -1), height: 1))
                    .animation(.none)
                })
            .offset(y: self.storyMode ? max(-10, draggedOffset.height) : UIScreen.main.bounds.height)
            .rotation3DEffect(.degrees(self.getRotate()), axis: (x: 0.0, y: 1.0, z: 0.0))
            .rotation3DEffect(.degrees(self.rotation), axis: (x: 0.0, y: 1.0, z: 0.0))
            .padding(.horizontal, 10.0)
            .animation(.spring())
            .onReceive(self.timer) {data in
                self.delta += 0.1
                self.rotation = self.rotation * sin(self.delta)
            }
            .gesture(DragGesture()
                .onChanged { value in
                    self.draggedOffset.width = value.translation.width
                    self.draggedOffset.height = value.translation.height
                }
                .onEnded { value in
                    self.draggedOffset.height = 0
                    self.draggedOffset.width = 0
                    if (value.translation.height > 100) {
                        self.storyMode = false;
                        self.index = 0
                        return
                    }
        
                    if (value.translation.width < -100 && self.index > 0) {
                        self.index -= 1
                    }
                    
                    if (value.translation.width > 100 && self.index < (self.getStories()?.count ?? 1)-1) {
                        self.index += 1
                    }
                })
    }
}
 
