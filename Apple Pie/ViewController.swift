//
//  ViewController.swift
//  Apple Pie
//
//  Created by Никита Раташнюк on 13.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Properties
    var currentGame: Game!
    let maxAttempts = 7
    var totalWins = 0
    var totalLosses = 0
    
    // MARK: - Methods
    func newRound() {
        let i = Int.random(in: 0...listOfFruits.count - 1)
        currentGame = Game(word: listOfFruits[i], remainingAttempts: maxAttempts)
        updateUI()
    }
    
    func updateCorrectWord() {
        var letters = [String]()
        for letter in currentGame.guessedWord {
            letters.append(String(letter))
        }
        correctWordLabel.text = letters.joined(separator: " ")
    }
    
    func updateUI() {
        treeImageView.image = UIImage(named: "Tree\(currentGame.remainingAttempts < 0 ? 0 : currentGame.remainingAttempts)")
        scoreLabel.text = "\(totalWins) Выигрышей, \(totalLosses) Проигрышей"
        updateCorrectWord()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(hex: "#D3CCE3")!.cgColor, UIColor(hex: "#E9E4F0")!.cgColor]//, UIColor(hex: "#24243e")!.cgColor]

        view.layer.insertSublayer(gradient, at: 0)
        
        newRound()
    }

    // MARK: - IB Actions
    @IBAction func letterButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letter = Character(sender.title(for: .normal)!)
        currentGame.playerGuessed(letter: letter)
        updateUI()
    }
    
}

extension UIColor {
    public convenience init?(hex: String, alpha: CGFloat = 1) {
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    self.init(
                            red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(hexNumber & 0x0000FF) / 255.0,
                            alpha: CGFloat(alpha)
                        )
                    return
                }
            }
        }

        return nil
    }
}

