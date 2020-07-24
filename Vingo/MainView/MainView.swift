import SwiftUI

struct MainView: View {
    @EnvironmentObject var app: AppStore

    var body: some View {
        VStack(alignment: .leading) {
            Text("Vingo")
                .font(.custom("Futura", size: 50))
                .fontWeight(.bold)
                .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                .kerning(-3)
            Text("🔥 Explore museums with fun")
                .font(.custom("Futura", size: 22))
                .foregroundColor(Color(#colorLiteral(red: 0.7097406387, green: 0.7098445296, blue: 0.7097179294, alpha: 1)))
                .fontWeight(.regular)
                .kerning(-1.24)
                .padding(.top, 10.0)
            
            HStack {
                ForEach(app.museums) { museum in
                    NavigationLink(destination: MuseumView().environmentObject(self.app), tag: museum.id, selection: self.$app.activeMuseum) {
                        MuseumCard(museum: museum)
                    }
                }
            }
        }
    }
}
