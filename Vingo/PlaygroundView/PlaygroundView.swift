//  PlaygroundView.swift
//  Created by Andrey Zhevlakov on 28.04.2020.

import SwiftUI

struct PlaygroundView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var map = [Room(), Room(), Room(), Room()]
    
    var UpperControl: some View {
        HStack {
            BadgeButton(action: { self.presentationMode.wrappedValue.dismiss() }, text: "Back")
            Spacer()
            BadgeButton(action: {}, text: "Vincent Van Gogh")
        }
     }

    var body: some View {
        ZStack(alignment: .leading) {
            CameraViewController()
            VStack(alignment: .leading) {
                UpperControl
                Spacer()

                MapLine(map: self.map)
                SwipeableCards(map: self.map)
            }
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
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

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}
