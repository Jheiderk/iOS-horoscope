//
//  ViewSuperHero.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 10/4/24.
//

import Foundation
import UIKit


class ViewSuperHero: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var textMovie: UITextField!
    var superHero: [Hero] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
        
 
    func fetchMovies(search: String) {
        let urlString = "https://superheroapi.com/api/7252591128153666/search/\(search)"
            
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
                let decoded = try JSONDecoder().decode(HeroResponse.self, from: data)
                self.superHero = decoded.results
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
        return superHero.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let hero = superHero[indexPath.row]
        
        cell.titleLabel.text = hero.name
        cell.year.text=hero.biography.alignment
        
        // Cargar la imagen desde la URL
        if let posterURL = URL(string: hero.image.url) {
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
        let selected = superHero[indexPath.row]
        
        // Crear una instancia de la pantalla de detalle de la película
        guard let SuperHeroDetails = storyboard?.instantiateViewController(withIdentifier: "SuperHeroDetails") as? SuperHeroDetails else {
            return
        }
        
        // Pasar el ID de la película seleccionada a la pantalla de detalle
        SuperHeroDetails.hero = selected.id
        
        // Presentar la pantalla de detalle
        navigationController?.pushViewController(SuperHeroDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    @IBAction func seachButton(_ sender: Any) {
        
        let searchMovie:String? = textMovie.text
        
        fetchMovies(search: searchMovie!)
    }
    
    
}

class SuperCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var year: UILabel!
    // Agrega más outlets según sea necesario
}
