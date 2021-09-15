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
    @IBOutlet weak var nextWordButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    // MARK: - Properties
    var currentGame: Game!
    var listOfWords: Set<String>!
    var category: String = ""
    let maxAttempts = 7
    var totalWins = 0 { didSet { endOfRound() } }
    var totalLosses = 0 { didSet { endOfRound() } }
    var usedWords = Set<String>()
    
    // MARK: - Methods
    func enableAllButtons(_ enable: Bool = true) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func endOfRound() {
        nextWordButton.isHidden = false
        enableAllButtons(false)
        updateUI()
        correctWordLabel.text = currentGame.word
    }
    
    func newRound() {
        let remainedWords = listOfWords.subtracting(usedWords)
        guard remainedWords.count > 0 else {
            backButtonTapped()
            return
        }
        let newWord = remainedWords.randomElement()!
        usedWords.insert(newWord)
        currentGame = Game(word: newWord, remainingAttempts: maxAttempts)
        
        nextWordButton.isHidden = true
        correctWordLabel.backgroundColor = .systemYellow
        updateUI()
        enableAllButtons()
    }
    
    func updateCorrectWord() {
        var letters = [String]()
        for letter in currentGame.guessedWord {
            letters.append(String(letter))
        }
        correctWordLabel.text = letters.joined(separator: " ")
    }
    
    func updateState() {
        if currentGame.remainingAttempts < 1 {
            totalLosses += 1
            correctWordLabel.backgroundColor = UIColor.red
        } else if currentGame.guessedWord == currentGame.word {
            totalWins += 1
            correctWordLabel.backgroundColor = UIColor.green
        } else {
            updateUI()
        }
    }
    
    func updateUI() {
        treeImageView.image = UIImage(named: "Tree\(currentGame.remainingAttempts < 0 ? 0 : currentGame.remainingAttempts)")
        scoreLabel.text = "\(totalWins) Выигрышей, \(totalLosses) Проигрышей"
        categoryLabel.text = "Категория: \(category)"
        updateCorrectWord()
    }
    
    @objc func rotated() {
        view.generatePurpleGradient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.generatePurpleGradient()
        newRound()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        view.generatePurpleGradient()
//    }

    // MARK: - IB Actions
    @IBAction func letterButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letter = Character(sender.title(for: .normal)!)
        currentGame.playerGuessed(letter: letter)
        updateState()
    }
    
    @IBAction func nextRoundTapped(_ sender: UIButton) {
        newRound()
    }
    
    @IBAction func backButtonTapped() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension UIView {
    func generatePurpleGradient() {
        // deleting previos sublayer
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                if layer.name == "purpleGradient" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [UIColor(hex: "#D3CCE3")!.cgColor, UIColor(hex: "#E9E4F0")!.cgColor]//, UIColor(hex: "#24243e")!.cgColor]
        gradient.name = "purpleGradient"

        // if view.layer.sublayers != nil, view.layer.sublayers!.count > 0 { view.layer.sublayers!.remove(at: 0) }
        self.layer.insertSublayer(gradient, at: 0)
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

