//
//  HelperFunctions.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

/// Fetches all data of the given type from the local JSON file and return an array of object of the specified type.
func fetchFromJSON<T: Decodable>(ofType: T.Type, fileName: String) -> [T] {
    let data: Data
    
    // Get the file
    let file = Bundle.main.url(forResource: fileName, withExtension: "json")!
    
    // Load the contents of the file
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(fileName).json from main bundle: \n \(error)")
    }
    
    // Parse the JSON and decode it to an array of Tips
    do {
        return try JSONDecoder().decode([T].self, from: data)
    } catch {
        fatalError("Couldn't parse \(fileName).json as \(T.self): \n \(error)")
    }
}
