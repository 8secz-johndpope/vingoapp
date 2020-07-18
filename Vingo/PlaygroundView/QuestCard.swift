//
//  QuestCard.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 17.07.2020.
//

import SwiftUI

struct QuestCard: View {
    var location: String
    var question: String
        
    internal init(question: String, location: String) {
         self.location = location
         self.question = question
    }
    
    @State var attempts: Int = 0
     
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(self.location)
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.black)
                    .padding(.all, 8.0)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                        .foregroundColor(.blue))
                
                Spacer()
                ForEach(0 ..< 5) { item in
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.blue)
                }
            }
            Text(self.question).font(.largeTitle)
            Text(self.location)
                .foregroundColor(.black)
                .fontWeight(.black)
                .padding(.top, 5.0)
                .font(.body)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: CGFloat(20)))
        .foregroundColor(.white)
        .onTapGesture { self.attempts += 1 }
        .modifier(Shake(animatableData: CGFloat(self.attempts)))
    }
}

struct QuestCard_Previews: PreviewProvider {
    static var previews: some View {
        QuestCard(question: "😘", location: "Мое сердечко")
    }
}
