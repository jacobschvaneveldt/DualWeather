//
//  ViewController.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherController.shared.fetchWeather(searchTerm: "Honolulu") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let numbers):
                    print(numbers)
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        
        
    }
    
    //MARK: - VIEWS
    
    
    //MARK: - FUNCTIONS
    
    

}//End of class

