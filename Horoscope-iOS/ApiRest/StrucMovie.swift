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
