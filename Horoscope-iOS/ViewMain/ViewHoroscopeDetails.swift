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
    var selectedHoroscope: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchHoroscope()
        
    }
    
    
    func fetchHoroscopeFromAPI(selected:String) async throws -> HoroscopeData {
        let url = URL(string: "https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily?sign=\(selected)&day=TODAY")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
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
                let horoscope = try await fetchHoroscopeFromAPI(selected: selectedHoroscope)
                
                DispatchQueue.main.async {
                    self.titleLabel.text = selectedHoroscope
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
    
    

