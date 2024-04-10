//
//  ViewController.swift
//  Horoscope-iOS
//
//  Created by Mañanas on 3/4/24.
//

import UIKit


class ViewController: UIViewController {

 
    @IBOutlet var heightText: UILabel!
    @IBOutlet var weightText: UILabel!
    @IBOutlet var imc: UILabel!
    @IBOutlet var heightEnhancer: UIStepper!
    @IBOutlet var weightEnhancer: UIStepper!
    var weight: Double = 40
    var height: Double = 100
    var calculo: Double = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inicio()
        
    }
    
    

    func inicio(){
        
        heightEnhancer.value=100
        weightEnhancer.value=40
       
    }
    
    
    @IBAction func alturaEntry(_ sender: UIStepper) {
        
        heightText.text="\(Int(heightEnhancer.value)) cm"
        height=Double(heightEnhancer.value)
    }
    
    @IBAction func pesoEntry(_ sender: Any) {
        
        weightText.text="\(Int(weightEnhancer.value)) kg"
        weight=Double(weightEnhancer.value)
    }
    
    @IBAction func calculate(_ sender: Any) {
        
        let double=height/100
        
        
        calculo=weight/(double*double)
        
        let imcFormateado = formatearNumero(calculo)
        
        imc.text="\(imcFormateado)"
    }
    
    
    func formatearNumero(_ numero: Double) -> String {
        let formateador = NumberFormatter()
        formateador.numberStyle = .decimal
        formateador.maximumFractionDigits = 2 // Limitar a dos decimales
        
        if let imcFormateado = formateador.string(from: NSNumber(value: numero)) {
                return imcFormateado
            } else {
                return "NaN" // Valor por defecto si no se puede formatear
            }
    }
}

