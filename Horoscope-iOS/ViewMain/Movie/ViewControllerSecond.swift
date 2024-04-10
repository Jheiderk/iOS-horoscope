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
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    weak var delegate: ViewControllerSecondDelegate?
    
    
    var selectedMovieID: String?
    var isFavorite: Bool = false
    var favoriteMovies: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImageView.contentMode = .scaleAspectFill
        fetchMovie()
        loadFavoriteMovies()
        updateFavoriteButton()
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
    
    func saveFavoriteMovies() {
            UserDefaults.standard.set(favoriteMovies, forKey: "FavoriteMovies")
        }
        
        // Método para cargar la lista de películas favoritas desde UserDefaults
        func loadFavoriteMovies() {
            if let favorites = UserDefaults.standard.stringArray(forKey: "FavoriteMovies") {
                favoriteMovies = favorites
                
                isFavorite = favoriteMovies.contains(selectedMovieID ?? "")
            }
        }
    
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        isFavorite.toggle()
        updateFavoriteButton()
        
        // Notificar al delegado que el estado de "favorito" ha cambiado
        delegate?.didUpdateFavoriteStatus(for: selectedMovieID ?? "", isFavorite: isFavorite)
        // Actualizar el estado de favorito en la lista de películas favoritas
        if isFavorite {
            favoriteMovies.append(selectedMovieID!)
        } else {
            if let index = favoriteMovies.firstIndex(of: selectedMovieID!) {
                favoriteMovies.remove(at: index)
            }
        }
        saveFavoriteMovies()
    }
    
        // Método para actualizar la apariencia del botón de favorito
    func updateFavoriteButton() {
        let symbolName = isFavorite ? "heart.fill" : "heart"
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20)
                let symbolImage = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
                favoriteButton.image = symbolImage
        }
}
protocol ViewControllerSecondDelegate: AnyObject {
    func didUpdateFavoriteStatus(for movieID: String, isFavorite: Bool)
}

