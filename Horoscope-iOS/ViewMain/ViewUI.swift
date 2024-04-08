//
//  ViewUI.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 5/4/24.
//

import Foundation
import UIKit


class ViewUI: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var textMovie: UITextField!
    var movies: [Movie] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
        
    let apiKey = "5a61c33"
        
    func fetchMovies(search: String) {
        let urlString = "http://www.omdbapi.com/?s=\(search)&apikey=\(apiKey)"
            
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching movies:", error)
                return
            }
                
            guard let data = data else {
                print("No data received")
                return
            }
                
            do {
                let decoded = try JSONDecoder().decode(MoviesResponse.self, from: data)
                self.movies = decoded.Search
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON:", error)
            }
        }
        task.resume()
    }
        
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie.Title
        cell.year.text=movie.Year
        
        // Cargar la imagen desde la URL
        if let posterURL = URL(string: movie.Poster) {
            URLSession.shared.dataTask(with: posterURL) { data, response, error in
                if let data = data {
                    // Convertir los datos en una imagen
                    let image = UIImage(data: data)
                    
                    // Actualizar la vista de imagen en el hilo principal
                    DispatchQueue.main.async {
                        cell.posterImageView.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
        
    // MARK: - UITableViewDelegate
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        
        // Crear una instancia de la pantalla de detalle de la película
        guard let viewControllerSecond = storyboard?.instantiateViewController(withIdentifier: "ViewControllerSecond") as? ViewControllerSecond else {
            return
        }
        
        // Pasar el ID de la película seleccionada a la pantalla de detalle
        viewControllerSecond.selectedMovieID = selectedMovie.imdbID
        
        // Presentar la pantalla de detalle
        navigationController?.pushViewController(viewControllerSecond, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    @IBAction func seachButton(_ sender: Any) {
        
        var searchMovie:String? = textMovie.text
        
        fetchMovies(search: searchMovie!)
    }
    
    
}

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var year: UILabel!
    // Agrega más outlets según sea necesario
}
