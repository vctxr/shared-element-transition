//
//  AppCard.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import Foundation

struct AppCard: Decodable {
    let type: CardType
    let backgroundType: BackgroundType
    let largeTitle: String?
    let appName: String
    let appIconName: String?
    let message: String?
    let title: String?
    let subtitle: String?
    let imageName: String
    let shortDescription: String?
    let longDescription: String
    
    enum CardType: String, Decodable {
        case appOfTheDay
        case highlight
        case explore
    }
    
    static func getAppCards() -> [AppCard] {
        let appData = fetchFromJSON(ofType: AppCard.self, fileName: "app-data")
        return appData
    }
}

struct BackgroundType: Decodable {
    let top: [Appearance]
    let bottom: Appearance
    
    enum Appearance: String, Decodable {
        case light
        case dark
    }
}
