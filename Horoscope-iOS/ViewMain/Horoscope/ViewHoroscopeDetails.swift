//
//  ViewHoroscopeDetails.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 8/4/24.
//

import Foundation

import UIKit

class ViewHoroscopeDetails: UIViewController{
   
    
        
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHoroscope: UIImageView!
    @IBOutlet weak var dateHoroscope: UILabel!
    @IBOutlet weak var horoscopeData: UILabel!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedHoroscope: Horoscope? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        titleLabel.text = selectedHoroscope?.name.uppercased()
        imageHoroscope.image=selectedHoroscope?.image
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        
        fetchHoroscope()
        
    }
    
    
    func fetchHoroscopeFromAPI(selected:String) async throws -> HoroscopeData {
        let url = URL(string: "https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily?sign=\(selected)&day=TODAY")!
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden=false
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden=true
        
        let decoded = try JSONDecoder().decode(HoroscopeResponse.self, from: data)
        
        
        
        return decoded.data
    }
    func fetchHoroscope() {
        guard let selectedHoroscope = selectedHoroscope else {
            print("No se proporcionó ningún signo del zodiaco seleccionado")
            return
        }
        
        Task {
            do {
                let horoscope = try await fetchHoroscopeFromAPI(selected: selectedHoroscope.id)
                
                DispatchQueue.main.async {
                    
                    self.dateHoroscope.text = horoscope.date
                    self.horoscopeData.text = horoscope.horoscopeData
                    print(horoscope)
                }
            } catch {
                DispatchQueue.main.async {
                    // Aquí puedes mostrar un mensaje de error al usuario o realizar otras acciones según sea necesario
                    print("Error al obtener el horóscopo: \(error)")
                }
            }
        }
    }
}
    
    

