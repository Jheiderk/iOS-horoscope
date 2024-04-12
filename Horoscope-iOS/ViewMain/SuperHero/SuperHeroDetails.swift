//
//  SuperHeroDetails.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 10/4/24.
//

import Foundation
import UIKit

class SuperHeroDetails: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var IntelligenceBar: UIProgressView!
    @IBOutlet var Strenght: UIProgressView!
    @IBOutlet var Speed: UIProgressView!
    @IBOutlet var Power: UIProgressView!
    @IBOutlet var Combat: UIProgressView!
    
    var hero: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImageView.contentMode = .scaleAspectFill
        fetchMovie()
    }
    
    let apiKey = "5a61c33"
    
    func fetchMovieFromAPI(idHero: String) async throws -> Hero {
        let url = URL(string: "https://superheroapi.com/api/7252591128153666/\(idHero)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(Hero.self, from: data)
        
        return decoded
    }
    
    func fetchMovie() {
           guard let selected = hero else {
               print("No se proporcionó ningún ID de película")
               return
           }
           
           Task {
               do {
                   let movie = try await fetchMovieFromAPI(idHero: selected)
                   
                   DispatchQueue.main.async {
                       self.titleLabel.text = movie.name
                       self.IntelligenceBar.progress=Float(movie.powerstats.intelligence) ?? 0
                       self.Strenght.progress=Float(movie.powerstats.strength) ?? 0
                       self.Speed.progress=Float(movie.powerstats.speed) ?? 0
                       self.Power.progress=Float(movie.powerstats.power) ?? 0
                       self.Combat.progress=Float(movie.powerstats.combat) ?? 0
                       
                       if let posterURL = URL(string: movie.image.url) {
                           URLSession.shared.dataTask(with: posterURL) { data, response, error in
                               if let data = data {
                                   let image = UIImage(data: data)
                                   DispatchQueue.main.async {
                                       self.posterImageView.image = image
                                       
                                   }
                               }
                           }.resume()
                       }
                   }
               } catch {
                   print("Error al obtener la película: \(error)")
               }
           }
       }
}
