//
//  Struc movie.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 5/4/24.
//

import Foundation

struct MoviesResponse: Decodable{
    let Search:[Movie]
    let totalResults: String
    let Response: String
}

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String    
    let Poster: String

}


struct MovieDetails: Decodable {
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Ratings: [Rating]
    let Metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let Response: String
}

struct Rating: Decodable {
    let Source: String
    let Value: String
}

struct HoroscopeResponse: Decodable {
    let data: HoroscopeData
    let status: Int
    let success: Bool
}

struct HoroscopeData: Decodable {
    let date: String
    let horoscopeData: String

    enum CodingKeys: String, CodingKey {
        case date
        case horoscopeData = "horoscope_data"
    }
}
struct HeroResponse: Codable {
    let response: String
    let results: [Hero]
}

struct Hero: Codable {
    let id: String
    let name: String
    let powerstats: Powerstats
    let biography: Biography
    let appearance: Appearance
    let work: Work
    let connections: Connections
    let image: Image
}

struct Powerstats: Codable {
    let intelligence, strength, speed, durability, power, combat: String
    

}

struct Biography: Codable {
    let fullName, alterEgos: String
    let aliases: [String]
    let placeOfBirth, firstAppearance, publisher, alignment: String

    enum CodingKeys: String, CodingKey {
        case fullName = "full-name"
        case alterEgos = "alter-egos"
        case aliases
        case placeOfBirth = "place-of-birth"
        case firstAppearance = "first-appearance"
        case publisher, alignment
    }
}

struct Appearance: Codable {
    let gender, race: String
    let height, weight: [String]
    let eyeColor, hairColor: String

    enum CodingKeys: String, CodingKey {
        case gender, race, height, weight
        case eyeColor = "eye-color"
        case hairColor = "hair-color"
    }
}

struct Work: Codable {
    let occupation, base: String
}

struct Connections: Codable {
    let groupAffiliation, relatives: String

    enum CodingKeys: String, CodingKey {
        case groupAffiliation = "group-affiliation"
        case relatives
    }
}

struct Image: Codable {
    let url: String
}

