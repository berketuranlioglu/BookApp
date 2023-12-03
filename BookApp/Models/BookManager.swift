//
//  BookManager.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import Foundation

class BookManager {
    
    // Singleton
    static let shared = BookManager()
    private init(){}
    
    func performRequest(urlString: String, handler: @escaping ((Data?) -> Void)) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("error")
                }
                handler(data)
            }
            task.resume()
        }
    }
}
