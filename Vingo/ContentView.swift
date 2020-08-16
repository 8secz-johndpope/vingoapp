//
//  ContentView.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 17.07.2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var app: AppStore

    var body: some View {
        ZStack {
            NavigationView {
                MainView().environmentObject(self.app).background(BackgroundParalax())
            }.zIndex(1)

            VStack {
                if self.app.storyMode {
                    Story()
                        .environmentObject(self.app)
                        .transition(AnyTransition.move(edge: .bottom))
                }
            }.zIndex(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
