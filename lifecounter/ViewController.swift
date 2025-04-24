//
//  ViewController.swift
//  lifecounter
//
//  Created by An Nguyen on 4/22/25.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private let initialLifeTotal = 20
    private var playerCount = 4
    private var playerLifeTotals: [Int] = []
    private var gameHistory: [String] = []
    private var gameInProgress = false

    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var bigLifeCounterButtonLabel: UITextField!
    @IBOutlet weak var playersContainerView: UIView!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var gameResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigLifeCounterButtonLabel.keyboardType = .numberPad
        bigLifeCounterButtonLabel.delegate = self
        bigLifeCounterButtonLabel.placeholder = "5"
        bigLifeCounterButtonLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        setupInitialUI()
    }
    
    private func setupInitialUI() {
        for view in playersContainerView.subviews {
            view.removeFromSuperview()
        }
        playerLifeTotals = Array(repeating: initialLifeTotal, count: playerCount)
        gameHistory = []
        gameInProgress = false
        addPlayerButton.isEnabled = true
        updatePlayerBoxes()
        gameResultLabel.text = ""
        gameResultLabel.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonLabels()
    }
    
    private func updateButtonLabels() {
        if let amountText = bigLifeCounterButtonLabel.text, let amount = Int(amountText), amount > 0 {
            for i in 1...playerCount {
                if let playerView = playersContainerView.viewWithTag(i) {
                    for subview in playerView.subviews {
                        if let button = subview as? UIButton {
                            if button.tag == i + 200 {
                                button.setTitle("+ \(amount)", for: .normal)
                            } else if button.tag == i + 300 {
                                button.setTitle("- \(amount)", for: .normal)
                            }
                        }
                    }
                }
            }
        } else {
            for i in 1...playerCount {
                if let playerView = playersContainerView.viewWithTag(i) {
                    for subview in playerView.subviews {
                        if let button = subview as? UIButton {
                            if button.tag == i + 200 {
                                button.setTitle("+ 5", for: .normal)
                            } else if button.tag == i + 300 {
                                button.setTitle("- 5", for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistorySegue" {
            if let historyVC = segue.destination as? HistoryViewController {
                historyVC.gameHistory = self.gameHistory
            }
        }
    }
    
    private func updatePlayerBoxes() {
        for view in playersContainerView.subviews {
            view.removeFromSuperview()
        }
        
        let isLandscape = UIDevice.current.orientation.isLandscape
        let columns = isLandscape ? 4 : 2
        
        let containerWidth = playersContainerView.frame.width
        let horizontalSpacing: CGFloat = 10
        let verticalSpacing: CGFloat = 10
        
        let boxWidth = (containerWidth - (CGFloat(columns + 1) * horizontalSpacing)) / CGFloat(columns)
        let boxHeight: CGFloat = 120
        
        for i in 0..<playerCount {
            let playerBox = generatePlayerBox(for: i + 1)
            playerBox.translatesAutoresizingMaskIntoConstraints = false
            playersContainerView.addSubview(playerBox)
            
            let row = i / columns
            let column = i % columns
            let xPos = CGFloat(column) * (boxWidth + horizontalSpacing) + horizontalSpacing
            let yPos = CGFloat(row) * (boxHeight + verticalSpacing) + verticalSpacing
            
            NSLayoutConstraint.activate([
                playerBox.topAnchor.constraint(equalTo: playersContainerView.topAnchor, constant: yPos),
                playerBox.leadingAnchor.constraint(equalTo: playersContainerView.leadingAnchor, constant: xPos),
                playerBox.widthAnchor.constraint(equalToConstant: boxWidth),
                playerBox.heightAnchor.constraint(equalToConstant: boxHeight)
            ])
        }
        updateButtonLabels()
    }
    
    private func generatePlayerBox(for playerNumber: Int) -> UIView {
        let playerView = UIView()
        playerView.tag = playerNumber
        playerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        playerView.layer.cornerRadius = 8
        
        let playerLabel = UILabel()
        playerLabel.text = "Player \(playerNumber)"
        
        let hpLabel = UILabel()
        hpLabel.text = "HP: \(initialLifeTotal)"
        hpLabel.tag = 100 + playerNumber
        
        let plusOneButton = UIButton(type: .system)
        plusOneButton.setTitle("+ 1", for: .normal)
        plusOneButton.backgroundColor = UIColor.systemGray5
        plusOneButton.layer.cornerRadius = 8
        plusOneButton.tag = playerNumber
        plusOneButton.addTarget(self, action: #selector(playerPlusOneButtonTapped(_:)), for: .touchUpInside)
        
        let plusFiveButton = UIButton(type: .system)
        plusFiveButton.setTitle("+ 5", for: .normal)
        plusFiveButton.backgroundColor = UIColor.systemGray5
        plusFiveButton.layer.cornerRadius = 8
        plusFiveButton.tag = playerNumber + 200
        plusFiveButton.addTarget(self, action: #selector(playerPlusFiveButtonTapped(_:)), for: .touchUpInside)
        
        let minusOneButton = UIButton(type: .system)
        minusOneButton.setTitle("- 1", for: .normal)
        minusOneButton.backgroundColor = UIColor.systemGray5
        minusOneButton.layer.cornerRadius = 8
        minusOneButton.tag = playerNumber
        minusOneButton.addTarget(self, action: #selector(playerMinusOneButtonTapped(_:)), for: .touchUpInside)
        
        let minusFiveButton = UIButton(type: .system)
        minusFiveButton.setTitle("- 5", for: .normal)
        minusFiveButton.backgroundColor = UIColor.systemGray5
        minusFiveButton.layer.cornerRadius = 8
        minusFiveButton.tag = playerNumber + 300
        minusFiveButton.addTarget(self, action: #selector(playerMinusFiveButtonTapped(_:)), for: .touchUpInside)
        
        playerView.addSubview(playerLabel)
        playerView.addSubview(hpLabel)
        playerView.addSubview(plusOneButton)
        playerView.addSubview(plusFiveButton)
        playerView.addSubview(minusOneButton)
        playerView.addSubview(minusFiveButton)
        
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        hpLabel.translatesAutoresizingMaskIntoConstraints = false
        plusOneButton.translatesAutoresizingMaskIntoConstraints = false
        plusFiveButton.translatesAutoresizingMaskIntoConstraints = false
        minusOneButton.translatesAutoresizingMaskIntoConstraints = false
        minusFiveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerLabel.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 10),
            playerLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 10),
            
            hpLabel.topAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 5),
            hpLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 10),
            
            plusOneButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 10),
            plusOneButton.trailingAnchor.constraint(equalTo: plusFiveButton.leadingAnchor, constant: -5),
            plusOneButton.widthAnchor.constraint(equalToConstant: 35),
            plusOneButton.heightAnchor.constraint(equalToConstant: 35),
            
            plusFiveButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 10),
            plusFiveButton.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -10),
            plusFiveButton.widthAnchor.constraint(equalToConstant: 35),
            plusFiveButton.heightAnchor.constraint(equalToConstant: 35),
            
            minusOneButton.topAnchor.constraint(equalTo: plusOneButton.bottomAnchor, constant: 5),
            minusOneButton.trailingAnchor.constraint(equalTo: minusFiveButton.leadingAnchor, constant: -5),
            minusOneButton.widthAnchor.constraint(equalToConstant: 35),
            minusOneButton.heightAnchor.constraint(equalToConstant: 35),
            
            minusFiveButton.topAnchor.constraint(equalTo: plusFiveButton.bottomAnchor, constant: 5),
            minusFiveButton.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -10),
            minusFiveButton.widthAnchor.constraint(equalToConstant: 35),
            minusFiveButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        return playerView
    }
    
    @IBAction func addPlayerbuttonTapped(_ sender: Any) {
        if playerCount == 8 || gameInProgress { return }
        playerCount += 1
        playerLifeTotals.append(initialLifeTotal)
        updatePlayerBoxes()
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
            performSegue(withIdentifier: "showHistorySegue", sender: nil)
        }
        
    @IBAction func resetButtonTapped(_ sender: Any) {
        setupInitialUI()
    }
    
    @objc func playerPlusOneButtonTapped(_ sender: UIButton) {
        let playerIndex = sender.tag - 1
        if playerIndex >= 0 && playerIndex < playerLifeTotals.count {
            playerLifeTotals[playerIndex] += 1
            updatePlayerLife(for: playerIndex + 1, change: 1)
            if !gameInProgress {
                gameInProgress = true
                addPlayerButton.isEnabled = false
            }
        }
    }
    
    @objc func playerPlusFiveButtonTapped(_ sender: UIButton) {
        let playerIndex = (sender.tag - 200) - 1
        if playerIndex >= 0 && playerIndex < playerLifeTotals.count {
            if let amountText = bigLifeCounterButtonLabel.text, let amount = Int(amountText), amount > 0 {
                playerLifeTotals[playerIndex] += amount
                updatePlayerLife(for: playerIndex + 1, change: amount)
            } else {
                playerLifeTotals[playerIndex] += 5
                updatePlayerLife(for: playerIndex + 1, change: 5)
            }
            if !gameInProgress {
                gameInProgress = true
                addPlayerButton.isEnabled = false
            }
        }
    }
    
    @objc func playerMinusOneButtonTapped(_ sender: UIButton) {
        let playerIndex = sender.tag - 1
        if playerIndex >= 0 && playerIndex < playerLifeTotals.count {
            playerLifeTotals[playerIndex] -= 1
            updatePlayerLife(for: playerIndex + 1, change: -1)
            if !gameInProgress {
                gameInProgress = true
                addPlayerButton.isEnabled = false
            }
        }
    }
    
    @objc func playerMinusFiveButtonTapped(_ sender: UIButton) {
        let playerIndex = (sender.tag - 300) - 1
        if playerIndex >= 0 && playerIndex < playerLifeTotals.count {
            if let amountText = bigLifeCounterButtonLabel.text, let amount = Int(amountText), amount > 0 {
                playerLifeTotals[playerIndex] -= amount
                updatePlayerLife(for: playerIndex + 1, change: -amount)
            } else {
                playerLifeTotals[playerIndex] -= 5
                updatePlayerLife(for: playerIndex + 1, change: -5)
            }
            if !gameInProgress {
                gameInProgress = true
                addPlayerButton.isEnabled = false
            }
        }
    }
    
    private func updatePlayerLife(for playerNumber: Int, change: Int) {
        let playerIndex = playerNumber - 1
        if let playerView = playersContainerView.viewWithTag(playerNumber) {
            if let hpLabel = playerView.viewWithTag(100 + playerNumber) as? UILabel {
                hpLabel.text = "HP: \(playerLifeTotals[playerIndex])"
            }
        }
        let action = "Player \(playerNumber) \(change >= 0 ? "gained" : "lost") \(abs(change)) life."
        gameHistory.append(action)
        checkGameResult()
    }
    
    private func checkGameResult() {
            for i in 0..<playerLifeTotals.count {
                if playerLifeTotals[i] <= 0 {
                    gameResultLabel.text = "Player \(i + 1) LOSES!"
                    gameResultLabel.isHidden = false
                    gameHistory.append("Player \(i + 1) LOSES!")
                    gameInProgress = false
                    addPlayerButton.isEnabled = true
                    return
                }
            }
            gameResultLabel.isHidden = true
        }
}
