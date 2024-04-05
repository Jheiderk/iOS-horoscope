//
//  Struc movie.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 5/4/24.
//

import Foundation

struct MoviesResponse: Decodable{
    let results:[Movie]
}

struct Movie:Decodable{
    let id:Int
    let title:String
    let overview: String
}
