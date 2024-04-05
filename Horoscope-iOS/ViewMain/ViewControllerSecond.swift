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
    @IBOutlet var posterImageView: UIImageView! // Conexión IBOutlet a tu UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        posterImageView.contentMode = .scaleAspectFill
        
        fetchMovie()
    }
    
    let apiKey = "5a61c33"
    
    func fetchMovieFromAPI() async throws -> Movie {
        let url = URL(string: "http://www.omdbapi.com/?i=tt8551028&apikey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(Movie.self, from: data)
        
        return decoded
    }
    
    func fetchMovie() {
        Task {
            do {
                let movie = try await fetchMovieFromAPI()
                
                // Actualizar la interfaz de usuario en el hilo principal
                DispatchQueue.main.async {
                    self.titleLabel.text = movie.Title
                    // Mostrar el título de la película
                    
                    if let posterURL = URL(string: movie.Poster) {
                        // Cargar la imagen desde la URL
                        URLSession.shared.dataTask(with: posterURL) { data, response, error in
                            if let data = data {
                                // Convertir los datos en una imagen
                                let image = UIImage(data: data)
                                
                                // Actualizar la vista de imagen en el hilo principal
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
