//
//  HomeViewController.swift
//  HomeViewController
//
//  Created by Никита Раташнюк on 15.09.2021.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.generatePurpleGradient()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        view.generatePurpleGradient()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var listOfWords: Set<String>!
        var category = "Unknown"
        
        switch segue.identifier {
            case "Fruits":
                listOfWords = listOfFruits
                category = "Фрукты"
            case "Countries":
                listOfWords = listOfCountries
                category = "Страны"
            default: listOfWords = listOfFruits
        }
        
        let destinationVC = segue.destination as! ViewController
        destinationVC.listOfWords = listOfWords
        destinationVC.category = category
    }

}
