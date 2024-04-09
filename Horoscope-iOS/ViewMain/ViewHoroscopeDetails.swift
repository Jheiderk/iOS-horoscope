//
//  ViewHoroscopeDetails.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 8/4/24.
//

import Foundation

import UIKit

class ViewHoroscopeDetails: UIViewController{
    
    var selectedHoroscope: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //fetchHoroscopeAPI()
        
    }
    
    
    func fetchHoroscopeAPI() async throws -> MovieDetails {
        let url = URL(string: "https://horoscope-app-api.vercel.app/api/v1/get-horoscope/weekly?sign=")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(MovieDetails.self, from: data)
        
        return decoded
    }
    
    
}
