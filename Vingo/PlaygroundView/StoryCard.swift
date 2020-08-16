import SwiftUI
import URLImage

struct Story: View {
    @EnvironmentObject var app: AppStore

    let width = UIScreen.main.bounds.width-80
    let height = max(500, UIScreen.main.bounds.height-400)
    
    @State var index = 0
    @State var maxSwipes = 1
    @State var dragActive = false
    @State private var draggedOffset = CGSize.zero

    // Animation
    let timer = Timer.publish(every: 1/30, on: .main, in: .common).autoconnect()
    @State var rotation: Double = 0
    @State var delta: Double = 0
    @State var achivScale = 0

    func getRotate() -> Double {
        return Double(self.index * 180) + Double(self.draggedOffset.width/10) + self.rotation
    }

    func makeCardRect() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.white)
            .frame(width: self.width, height: self.height)
    }
    
    func makeContent() -> AnyView {
        if self.index == self.maxSwipes {
            return AnyView(ZStack {
                Text("🐶").modifier(FitToWidth(fraction: 0.4))
            })
        }
        
        if let achievement = self.app.activeStory as? Achievement {
            return AnyView(ZStack {
                VStack {
                    Spacer()
                    Text(achievement.icon).font(.system(size: 100))
                    Text(achievement.title).font(.custom("Futura", size: 30))
                    Text(achievement.description).font(.custom("Futura", size: 20))
                    Spacer()
                }
            })
        }
        
        
        if let room = self.app.activeStory as? Room {
            return AnyView(VStack(alignment: .leading) {
                Text(room.title)
                        .font(.custom("Futura", size: 25))
                        .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                        .fontWeight(.bold)
                        .kerning(-1.55)
                    
                Text(room.description)
                        .font(.custom("PT Sans", size: 16))
                        .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                        .fontWeight(.bold)
                        .kerning(-0.75)
                        .lineSpacing(-5)
                        .padding(.top, 10.0)
                Spacer()
            }.padding())
        }
        
        if let picture = self.app.activeStory as? Picture {
            var stories = (picture.description?.split(separator: ".") ?? [""])
            stories.append("")
    
            DispatchQueue.main.async {
                self.maxSwipes = stories.count
            }

            return AnyView(
                ZStack(alignment: .bottom) {
                    LinearGradient(gradient: Gradient(colors: [.clear, Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.597067637))]), startPoint: .top, endPoint: .bottom)
                        .frame(height: self.height/2)
                        .cornerRadius(20)

                    VStack(alignment: .leading) {
                        Spacer()
                        Text(stories.count > 0 ? stories[self.index] : "")
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
                    }.padding()
                })
        }
        
        return AnyView(Text(""))
    }
    
    func makeBackground() -> AnyView {
        if let picture = self.app.activeStory as? Picture {
            return AnyView(URLImage(URL(string: picture.original_image ?? "")!, placeholder: { _ in self.makeCardRect() }) { proxy in
                proxy.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: self.width, height: self.height)
                    .mask(RoundedRectangle(cornerRadius: 20))
                })
        }
        
        return AnyView(self.makeCardRect())
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                Group {
                    self.makeContent()
                }
                .scaleEffect(CGSize(width: 1 * (self.index % 2 == 0 ? 1 : -1), height: 1))
                .animation(self.dragActive ? nil : .easeOut)
            }
            .background(self.makeBackground().shadow(radius: 10))
            .position(x: self.width/2, y: self.height/2+self.draggedOffset.height)
            .frame(width: self.width, height: self.height)
            .rotation3DEffect(.degrees(self.getRotate()), axis: (x: 0.0, y: 1.0, z: 0.0))
            .padding(.horizontal, 10.0)
            .animation(.easeOut)
            .onReceive(self.timer) {data in
                self.delta += 0.01
                self.rotation = 5 * sin(self.delta)
            }
            .gesture(DragGesture()
                .onChanged { value in
                    self.draggedOffset.width = value.translation.width
                    self.draggedOffset.height = value.translation.height
                    self.dragActive = false
                }
                .onEnded { value in
                    self.draggedOffset = .zero
                    if (value.translation.height > 100) {
                        self.app.storyMode = false;
                        self.index = 0
                        return
                    }
        
                    if (value.translation.width < -100 && self.index > 0) {
                        self.dragActive = true
                        self.index -= 1
                    }
                    
                    if (value.translation.width > 100 && self.index < self.maxSwipes-1) {
                        self.dragActive = true
                        self.index += 1
                    }
                })
        }
    }
}
 
