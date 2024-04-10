//
//  ViewUI.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 5/4/24.
//

import Foundation
import UIKit


class ViewUI: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewControllerSecondDelegate {
    
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var textMovie: UITextField!
    var movies: [Movie] = []
    var favoriteMovies: [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        loadFavoriteMovies()
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
    
    func loadFavoriteMovies() {
            if let favorites = UserDefaults.standard.stringArray(forKey: "FavoriteMovies") {
                favoriteMovies = favorites
            }
        }
    
    func saveFavoriteMovies() {
            UserDefaults.standard.set(favoriteMovies, forKey: "FavoriteMovies")
        }
        
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie.Title
        cell.year.text = movie.Year
        
        // Verifica si la película actual está en la lista de películas favoritas
        let isFavorite = favoriteMovies.contains(movie.imdbID)
            cell.configureFavoriteButton(isFavorite: isFavorite)
            
            cell.favoriteButtonAction = { [weak self] in
                guard let self = self else { return }
                if let index = self.favoriteMovies.firstIndex(of: movie.imdbID) {
                    self.favoriteMovies.remove(at: index)
                } else {
                    self.favoriteMovies.append(movie.imdbID)
                }
                self.saveFavoriteMovies()
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        
        // Cargar la imagen desde la URL
        if let posterURL = URL(string: movie.Poster) {
            URLSession.shared.dataTask(with: posterURL) { data, response, error in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.posterImageView.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
        viewControllerSecond.isFavorite = favoriteMovies.contains(selectedMovie.imdbID)
        viewControllerSecond.favoriteMovies = favoriteMovies
        viewControllerSecond.delegate = self  // Configurar el delegado
       
        // Presentar la pantalla de detalle
        navigationController?.pushViewController(viewControllerSecond, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    func didUpdateFavoriteStatus(for movieID: String, isFavorite: Bool) {
            if isFavorite {
                if !favoriteMovies.contains(movieID) {
                    favoriteMovies.append(movieID)
                }
            } else {
                favoriteMovies.removeAll { $0 == movieID }
            }
            saveFavoriteMovies()
            tableView.reloadData()
        }
    
    @IBAction func seachButton(_ sender: Any) {
        
        let searchMovie:String? = textMovie.text
        
        fetchMovies(search: searchMovie!)
        
        print(favoriteMovies)
    }
    
    
}

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    func configureFavoriteButton(isFavorite: Bool) {
            let symbolName = isFavorite ? "heart.fill" : "heart"
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20)
            let symbolImage = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
            favoriteButton.setImage(symbolImage, for: .normal)
        }
    
    
    var favoriteButtonAction: (() -> Void)?
        
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
            favoriteButtonAction?()
    }
    
    // Agrega más outlets según sea necesario
    
}
