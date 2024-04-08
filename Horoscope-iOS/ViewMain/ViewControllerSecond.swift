//
//  ViewControllerSecond.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 5/4/24.
//

import Foundation
import UIKit

class ViewControllerSecond: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    var selectedMovieID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImageView.contentMode = .scaleAspectFill
        fetchMovie()
    }
    
    let apiKey = "5a61c33"
    
    func fetchMovieFromAPI(imdbID: String) async throws -> MovieDetails {
        let url = URL(string: "http://www.omdbapi.com/?i=\(imdbID)&apikey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(MovieDetails.self, from: data)
        
        return decoded
    }
    
    func fetchMovie() {
           guard let selectedMovieID = selectedMovieID else {
               print("No se proporcionó ningún ID de película")
               return
           }
           
           Task {
               do {
                   let movie = try await fetchMovieFromAPI(imdbID: selectedMovieID)
                   
                   DispatchQueue.main.async {
                       self.titleLabel.text = movie.Title
                       if let posterURL = URL(string: movie.Poster) {
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
