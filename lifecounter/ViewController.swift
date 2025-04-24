//
//  ViewController.swift
//  lifecounter
//
//  Created by An Nguyen on 4/22/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let initialLifeTotal = 20
    private var playerCount = 4
    
    @IBOutlet weak var player1LifeLabel: UILabel!
    @IBOutlet weak var player2LifeLabel: UILabel!
    @IBOutlet weak var bigLifeCounterButtonLabel: UITextField!
    @IBOutlet weak var gameResultLabel: UILabel!
    
    private var player1Life = 20 {
        didSet {
            updateLifeTotals()
        }
    }
    
    private var player2Life = 20 {
        didSet {
            updateLifeTotals()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
    }
    
    private func setupInitialUI() {
        player1Life = initialLifeTotal
        player2Life = initialLifeTotal
        
        gameResultLabel.text = ""
        gameResultLabel.isHidden = true
    }
    
    private func updateLifeTotals() {
        player1LifeLabel.text = "HP: \(player1Life)"
        player2LifeLabel.text = "HP: \(player2Life)"
        
        checkGameResult()
    }
    
    private func checkGameResult() {
        if player1Life <= 0 {
            gameResultLabel.text = "Player 1 LOSES!"
            gameResultLabel.isHidden = false
        } else if player2Life <= 0 {
            gameResultLabel.text = "Player 2 LOSES!"
            gameResultLabel.isHidden = false
        } else {
            gameResultLabel.isHidden = true
        }
    }
    
    @IBAction func addPlayerButtonTapped(_ sender: UIButton) {
        playerCount += 1
    }
    
    @IBAction func player1PlusButtonTapped(_ sender: UIButton) {
        player1Life += 1
    }
    
    @IBAction func player1MinusButtonTapped(_ sender: UIButton) {
        player1Life -= 1
    }
    
    @IBAction func player1PlusFiveButtonTapped(_ sender: UIButton) {
        player1Life += 5
    }
    
    @IBAction func player1MinusFiveButtonTapped(_ sender: UIButton) {
        player1Life -= 5
    }
    
    @IBAction func player2PlusButtonTapped(_ sender: UIButton) {
        player2Life += 1
    }
    
    @IBAction func player2MinusButtonTapped(_ sender: UIButton) {
        player2Life -= 1
    }
    
    @IBAction func player2PlusFiveButtonTapped(_ sender: UIButton) {
        player2Life += 5
    }

    @IBAction func player2MinusFiveButtonTapped(_ sender: UIButton) {
        player2Life -= 5
    }
}

