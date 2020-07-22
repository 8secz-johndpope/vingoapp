//
//  Model.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 17.07.2020.
//

import Foundation
import Combine

struct Picture: Codable, Identifiable {
    let id = UUID()
    let quest = "dog"
    let title = "Moonlight"
    let description = "About..."
    let completed = false
    let image = "url"
}

struct Room {
    let id = UUID()
    let title = "Van Gogh"
    let description = "About..."
    let pictures = [Picture(), Picture(), Picture()]
    let number = 1
}
