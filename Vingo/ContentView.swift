//
//  ContentView.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 17.07.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            MainView()
        }.edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
