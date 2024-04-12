//
//  ViewHoroscope.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 8/4/24.
//

import Foundation

import UIKit


class ViewHoroscope: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var horoscope: [Horoscope] = Horoscope.allHoroscopes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return horoscope.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HoroscopeCell", for: indexPath) as! HoroscopeCell
        let item = horoscope[indexPath.row]
        cell.titleHoroscope.text = item.name.uppercased() // Asigna el texto a la etiqueta del título del horóscopo
        cell.imageHoroscope.image=item.image
        print(item.name)
        return cell
    }
        
    // MARK: - UITableViewDelegate
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHoroscope = horoscope[indexPath.row]
        
        // Crear una instancia de la pantalla de detalle de horóscopo
        guard let viewHoroscopeDetails = storyboard?.instantiateViewController(withIdentifier: "ViewHoroscopeDetails") as? ViewHoroscopeDetails else {
            return
        }
        
        // Pasar el horóscopo seleccionado a la pantalla de detalle
        viewHoroscopeDetails.selectedHoroscope = selectedHoroscope.id
        
        // Presentar la pantalla de detalle
        navigationController?.pushViewController(viewHoroscopeDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}


class HoroscopeCell: UITableViewCell {
    @IBOutlet weak var titleHoroscope: UILabel!
    @IBOutlet weak var imageHoroscope: UIImageView!
}
