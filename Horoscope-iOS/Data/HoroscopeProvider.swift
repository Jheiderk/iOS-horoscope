//
//  HoroscopeProvider.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 9/4/24.
//

import Foundation
import UIKit


class Horoscope {
    let id: String
    let name: String
    let image: UIImage?
    
    
    init(id: String, name: String, imageName: String) {
        self.id = id
        self.name = name
        self.image = UIImage(named: imageName)
        
    }
    
    static let aries = Horoscope(id: "Aries", name:"aries", imageName: "aries-svgrepo-com")
    static let aquarius = Horoscope(id: "Aquarius", name:"aquarius", imageName: "aquarius-svgrepo-com")
    static let pisces = Horoscope(id: "Pisces", name:"pisces", imageName: "horoscope-pisces-svgrepo-com")
    static let taurus = Horoscope(id: "Taurus", name:"taurus", imageName: "taurus-svgrepo-com")
    static let gemini = Horoscope(id: "Gemini", name:"gemini", imageName: "gemini-svgrepo-com")
    static let cancer = Horoscope(id: "Cancer", name:"cancer", imageName: "horoscope-cancer-svgrepo-com")
    static let leo = Horoscope(id: "Leo", name:"leo", imageName: "leo-svgrepo-com")
    static let virgo = Horoscope(id: "Virgo", name:"virgo", imageName: "horoscope-virgo-svgrepo-com")
    static let libra = Horoscope(id: "Libra", name:"libra", imageName: "libra-svgrepo-com")
    static let scorpio = Horoscope(id: "Scorpio", name:"scorpio", imageName: "scorpius-svgrepo-com")
    static let sagittarius = Horoscope(id: "Sagittarius", name:"sagittarius", imageName: "sagittarius-symbol-svgrepo-com")
    static let capricorn = Horoscope(id: "Capricorn", name:"capricorn", imageName: "capricornius-svgrepo-com")
    
    
    static func allHoroscopes() -> [Horoscope] {
            return [.aries, .aquarius, .pisces, .taurus, .gemini, .cancer, .leo, .virgo, .libra, .scorpio, .sagittarius, .capricorn]
        }
    static subscript(index: Int) -> Horoscope {
            return allHoroscopes()[index]
        }
        
        static func getHoroscope(id: String) -> Horoscope? {
            return allHoroscopes().first { $0.id == id }
        }
    }
