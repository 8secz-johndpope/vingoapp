import SwiftUI
import URLImage

struct Story: View {
    @Binding var active: Bool
    @Binding var element: MuseumElement
    @State private var draggedOffset = CGSize.zero
    @State var maxSwipes = 0
    @State var index = 0

    // Animation
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var rotation: Double = 0
    @State var delta: Double = 0

    func getRotate() -> Double {
        return Double(self.index * 180) + Double(self.draggedOffset.width/10)
    }

    func makeCardRect() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height-200)
    }
    
    func makeContent() -> AnyView {
        if let room = self.element as? Room {
            return AnyView(VStack(alignment: .leading) {
                Text(room.title)
                        .font(.custom("Futura", size: 25))
                        .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                        .fontWeight(.bold)
                        .kerning(-1.55)
                        .padding(.top, -12.0)
                
                    
                Text(room.description)
                        .font(.custom("PT Sans", size: 16))
                        .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                        .fontWeight(.bold)
                        .kerning(-0.75)
                        .lineSpacing(-5)
                        .padding(.top, 5.0)
                }.padding())
        }
        
        if let picture = self.element as? Picture {
            let stories = picture.description?.split(separator: ".") ?? [""]
            DispatchQueue.main.async {
                self.maxSwipes += stories.count
            }

            return AnyView(VStack(alignment: .leading) {
                Spacer()
                Text(stories.count != 0 ? stories[self.index] : "")
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .kerning(-1.3)
                        .shadow(radius: 5)
                Text("\(self.index)/\(stories.count)")
                        .font(.custom("Futura", size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .kerning(-1)
                        .padding(.top, 10)
                }.padding())
        }
        
        return AnyView(Text(""))
    }
    
    func makeBackground() -> AnyView {
        if self.element is Room {
            return AnyView(self.makeCardRect())
        }
        
        if let picture = self.element as? Picture {
            return AnyView(URLImage(URL(string: picture.original_image ?? "")!, placeholder: { _ in self.makeCardRect() }) { proxy in
                proxy.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height-200)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    .scaleEffect(CGSize(width: 1 * (self.index % 2 == 0 ? 1 : -1), height: 1))
                    .animation(.none)
                })
        }
        
        return AnyView(Text(""))
    }

    var body: some View {
            VStack(alignment: .center) {
                Group {
                    self.makeContent()
                }
                .animation(.none)
                .scaleEffect(CGSize(width: 1 * (index % 2 == 0 ? 1 : -1), height: 1))
            }
            .background(self.makeBackground())
            .offset(y: self.active ? max(-10, draggedOffset.height) : UIScreen.main.bounds.height)
            .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height-200)
            .padding(.horizontal, 10.0)
            .animation(.spring())

            .rotation3DEffect(.degrees(self.getRotate()), axis: (x: 0.0, y: 1.0, z: 0.0))
            .rotation3DEffect(.degrees(self.rotation), axis: (x: 0.0, y: 1.0, z: 0.0))
            .onReceive(self.timer) {data in
                self.delta += 0.1
                self.rotation = 10 * sin(self.delta)
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
                        self.active = false;
                        self.index = 0
                        return
                    }
        
                    if (value.translation.width < -100 && self.index > 0) {
                        self.index -= 1
                    }
                    
                    if (value.translation.width > 100 && self.index < self.maxSwipes-1) {
                        self.index += 1
                    }
                })
    }
}
 
