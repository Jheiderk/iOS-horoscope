//
//  ViewHoroscopeDetails.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 8/4/24.
//

import Foundation

import UIKit

class ViewHoroscopeDetails: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHoroscope: UIImageView!
    @IBOutlet weak var dateHoroscope: UILabel!
    @IBOutlet weak var horoscopeData: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedHoroscope: String? {
        didSet {
            // Cuando se establece un nuevo horóscopo seleccionado, actualizamos el índice selectedIndex
            if let index = horoscopes.firstIndex(where: { $0.id == selectedHoroscope }) {
                selectedIndex = index
            }
        }
    }
    var horoscopes: [Horoscope] = Horoscope.allHoroscopes()
    var selectedIndex: Int = 0 {
        didSet {
            // Asegurémonos de que selectedIndex siempre esté dentro del rango válido
            if selectedIndex < 0 {
                selectedIndex = horoscopes.count - 1
            } else if selectedIndex >= horoscopes.count {
                selectedIndex = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        updateHoroscopeDetails()
    }
    
    func updateHoroscopeDetails() {
        guard let selectedHoroscope = selectedHoroscope,
              let currentHoroscope = Horoscope.getHoroscope(id: selectedHoroscope) else {
            return
        }
        
        titleLabel.text = currentHoroscope.name.uppercased()
        imageHoroscope.image = currentHoroscope.image
        fetchHoroscope(selected: currentHoroscope.id)
    }
    
    func fetchHoroscope(selected: String) {
        guard let url = URL(string: "https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily?sign=\(selected)&day=TODAY") else {
            print("Invalid URL")
            return
        }
        
        activityIndicator.startAnimating()
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(HoroscopeResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.dateHoroscope.text = decoded.data.date
                    self.horoscopeData.text = decoded.data.horoscopeData
                }
            } catch {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    print("Error fetching horoscope:", error)
                }
            }
        }
    }
    
    @IBAction func previousHoroscope(_ sender: UIBarButtonItem) {
        selectedIndex -= 1
        selectedHoroscope = horoscopes[selectedIndex].id
        updateHoroscopeDetails()
    }
    
    @IBAction func nextHoroscope(_ sender: UIBarButtonItem) {
        selectedIndex += 1
        selectedHoroscope = horoscopes[selectedIndex].id
        updateHoroscopeDetails()
    }
}
