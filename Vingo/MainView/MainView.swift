import SwiftUI

struct MuseumButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0, anchor: .center)
    }
}

struct MainView: View {
    @EnvironmentObject var app: AppStore
    
    @State private var draggedOffset = CGSize.zero
    @State var size: CGSize = .zero
    @State private var current = 0
    public var width = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Vingo")
                    .font(.custom("Futura", size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                    .kerning(-3)
                Text("🔥 Explore museums with fun")
                    .font(.custom("Futura", size: 22))
                    .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                    .fontWeight(.regular)
                    .kerning(-1.24)
                    .padding(.top, 10.0)
                    .shadow(radius: 5)

                
                HStack(alignment: .center, spacing: 0) {
                    ForEach(app.museums) { museum in
                        NavigationLink(destination: MuseumView().environmentObject(self.app)) {
                            MuseumCard(museum: museum)
                        }
                        .disabled(museum.locked)
                        .buttonStyle(MuseumButtonStyle())
                        .frame(width: self.width)
                        .scaleEffect(museum.id == self.current ? 1 : 0.7)
                        .animation(.spring())
                    }
                }
                .animation(.spring())
                .background( GeometryReader { proxy in Color.clear.onAppear {
                    self.size = proxy.size
                }})
                .offset(x: CGFloat(Int(self.size.width)/2) - UIScreen.main.bounds.width/2 - self.draggedOffset.width)
                .highPriorityGesture(DragGesture()
                    .onChanged { value in
                        self.draggedOffset.width = self.width * CGFloat(self.current) - value.translation.width
                    }
                    .onEnded { value in
                        if (value.translation.width < -100 && self.current < self.app.museums.count-1) {
                            self.current += 1
                        }
                        if (value.translation.width > 100 && self.current > 0) {
                            self.current -= 1
                        }
                        self.draggedOffset.width = self.width * CGFloat(self.current)
                    })
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
