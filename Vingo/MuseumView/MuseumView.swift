//
//  MuseumView.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 18.07.2020.
//

import SwiftUI

struct MuseumView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hermitage")
                .font(.custom("Futura", size: 40))
                .fontWeight(.bold)
                .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                .kerning(-2.3)

            Text("Main Staff")
                .font(.custom("Futura", size: 25))
                .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                .fontWeight(.bold)
                .kerning(-1.55)
                .padding(.top, -12.0)
            
            Text("The State Hermitage Museum is a museum of art and culture in Saint Petersburg, Russia. The second largest art museum in the world, it was founded in 1764.")
                .font(.custom("PT Sans", size: 16))
                .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                .fontWeight(.bold)
                .kerning(-0.75)
                .lineSpacing(-5)
                .padding(.top, 5.0)
                .frame(width: UIScreen.main.bounds.width-20, height: 80)
            
            RoundedRectangle(cornerRadius: 10.0)
                .frame(width: 200, height: 5)
                .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                .padding(.top, 5.0)

            Button(action: {}) {
                Text("Start Explore")
                    .font(.custom("Futura", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                    .kerning(-2.3)
                    .padding()
            }.background((RoundedRectangle(cornerRadius: 10.0).foregroundColor(.white)))
            
            Spacer()
        }
    }
}

struct MuseumView_Previews: PreviewProvider {
    static var previews: some View {
        MuseumView()
    }
}
