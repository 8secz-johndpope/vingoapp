//  PlaygroundView.swift
//  Created by Andrey Zhevlakov on 28.04.2020.

import SwiftUI

struct PlaygroundView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var UpperControl: some View {
        HStack {
            BadgeButton(action: { self.presentationMode.wrappedValue.dismiss() }, text: "Back")
            Spacer()
            BadgeButton(action: {}, text: "Menu")
        }
     }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            CameraViewController()
            VStack(alignment: .leading) {
                UpperControl
                Spacer()
                QuestCard(question: "😘", location: "Мое сердечко")
            }.padding()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}

struct BadgeButton: View {
    let action: () -> Void
    let text: String
    
    var body: some View {
        Button(action: self.action) {
            Text(self.text)
                .foregroundColor(.black)
                .padding(.vertical, 5.0)
                .padding(.horizontal, 10.0)
        }
        .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(.white))
    }
}
