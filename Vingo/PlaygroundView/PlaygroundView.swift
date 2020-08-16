//  PlaygroundView.swift
//  Created by Andrey Zhevlakov on 28.04.2020.

import SwiftUI

struct PlaygroundView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var app: AppStore
    @State private var safeAreaTop: CGFloat = 0;
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraView(onFrame: { buffer in self.app.predict(buffer) })
                    .position(x: self.width/2, y: self.height/2)
                    .frame(width: self.width, height: self.height)
        
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.white, lineWidth: 4)
                    .frame(width: self.width/2, height: self.width/2).opacity(0.3)
                            
                VStack {
                    HStack {
                        BadgeButton(action: {
                            self.app.storyMode = false
                            self.presentationMode.wrappedValue.dismiss()
                        }, text: "Back")
                        Spacer()
                        BadgeButton(action: {}, text: self.app.activeRoom?.title ?? "")
                    }
                    .animation(.spring())
                    .frame(width: UIScreen.main.bounds.width-40, height: 30)
                    .padding(.horizontal, 20)
                    .padding(.top, self.safeAreaTop)
                    .offset(y: self.app.storyMode ? -100 : 0)
                    .onAppear {
                        self.safeAreaTop = geometry.safeAreaInsets.top;
                    }
                    
                    Spacer()
                    Group {
                        MapLine(map: self.app.museum.rooms, current: self.$app.activeElement, completed: self.app.completed)
                        SwipeableCards().environmentObject(self.app)
                    }.offset(y: self.app.storyMode ? 1000 : 0)
                }
            }
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct BadgeButton: View {
    let action: () -> Void
    let text: String
    
    var body: some View {
        Button(action: self.action) {
            Text(self.text).font(.custom("Futura", size: 15))
                .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                .fontWeight(.bold)
                .kerning(-1)
                .padding(.vertical, 5.0)
                .padding(.horizontal, 10.0)
        }
        .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(.white))
    }
}
