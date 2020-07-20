import SwiftUI

struct QuestBadge: View {
    public let active: Bool
    public let picture: Int
    
    public func isActive(_ id: Int) -> Bool {
        return self.active && self.picture == id
    }

    var body: some View {
        Group {
            HStack(alignment: .center) {
                ForEach(0 ..< 5) { id in
                    Circle()
                        .stroke(self.isActive(id) ? Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)) : Color.gray, style: StrokeStyle(lineWidth: 4))
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                }
            }.padding(.all, 10)
        }.background(RoundedRectangle(cornerRadius: 50).foregroundColor(.white))
    }
}

struct RoomBadge: View {
    public let active: Bool

    var body: some View {
        Text("100")
            .font(.custom("Futura", size: 14))
            .fontWeight(.bold)
            .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .border(self.active ? Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)) : Color.clear, width: 4)
                    .foregroundColor(.white)
        )
    }
}

struct MapLine: View {
    public let room: Int
    public let picture: Int
    
    var body: some View {
            HStack {
                ForEach(0..<3) { i in
                    QuestBadge(active: i == self.room, picture: self.picture)
                    RoomBadge(active: i == self.room && self.picture == 0)
                }
            }
    }
}
