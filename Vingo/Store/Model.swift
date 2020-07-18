//
//  Model.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 17.07.2020.
//

import Foundation
import Combine

struct Picture: Codable, Identifiable {
    let userId: Int;
    let id: Int;
    let title: String;
    let completed: Bool
    
    static var placeholder: Self {
        Picture(userId: 0, id: 0, title: "", completed: false)
    }
}

struct VingoAPI {
    static let shared = VingoAPI()
    private let baseURL = "https://jsonplaceholder.typicode.com/";
    
    public func fetchPictures() -> AnyPublisher<Picture, Never> {
        let url = URL(string: baseURL + "todos/1")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Picture.self, decoder: JSONDecoder())
            .catch { error in Just(Picture.placeholder) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

