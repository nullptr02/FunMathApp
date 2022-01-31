//
//  GameViewController.swift
//  FunMathApp
//
//  Created by Michael on 2021-12-03.
//

import Foundation
import UIKit
import CoreData

class GameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var operandOne: UILabel!
    @IBOutlet weak var operandTwo: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var operation: UIImageView!
    
    
    var indicatedOperator: String?
    var timer: Timer?
    var actualResult: Int?
    
    let returnToHomeSegueIdentifier = "returnToHomeSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.answerField.delegate = self
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.updateOperands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentScore.text = String(0)
        self.timeRemaining.text = String(60)
        self.operation.image = UIImage(systemName: self.indicatedOperator!)
    }
    
    @objc func updateTime() {
        if (Int(self.timeRemaining.text!) == 0) {
            self.timer!.invalidate()
            let alert = UIAlertController(title: "Your time's up!", message: "Your score is \(self.currentScore.text!).", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self]
                _ in
                
                // update the max score for the current operator
                switch self.indicatedOperator {
                case "plus":
                    scores[0] = max(scores[0], Int(self.currentScore.text!)!)
                case "minus":
                    scores[1] = max(scores[1], Int(self.currentScore.text!)!)
                case "multiply":
                    scores[2] = max(scores[2], Int(self.currentScore.text!)!)
                case "divide":
                    scores[3] = max(scores[3], Int(self.currentScore.text!)!)
                default:
                    break
                }
                
                self.performSegue(withIdentifier: returnToHomeSegueIdentifier, sender: self)
            }))

            self.present(alert, animated: true)
        } else {
            // decrement timer every second
            self.timeRemaining.text = String(Int(self.timeRemaining.text!)! - 1)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)

    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        // update score and operands if answer is correct
        if let result = Int(self.answerField.text!),
           result == self.actualResult {
            self.currentScore.text = String(Int(self.currentScore.text!)! + 1)
            updateOperands()
        }
        
        self.answerField.text = ""
    }
    
    func updateOperands() {
        if (indicatedOperator == "plus") {
            self.operandOne.text = String(Int.random(in: 0...99))
            self.operandTwo.text = String(Int.random(in: 0...99))
        } else if (indicatedOperator == "minus") {
            // ensure that answers are non-negative
            let op1 = Int.random(in: 0...99)
            self.operandOne.text = String(op1)
            self.operandTwo.text = String(Int.random(in: 0...op1))
        } else if (indicatedOperator == "multiply") {
            self.operandOne.text = String(Int.random(in: 0...12))
            self.operandTwo.text = String(Int.random(in: 0...12))
        } else if (indicatedOperator == "divide") {
            
            // Only want whole numbers
            let operand = Int.random(in: 1...99)
            let divisors = calculateDivisors(n: operand)
            self.operandOne.text = String(operand)
            self.operandTwo.text = String(divisors[Int.random(in: 0..<divisors.count)])
        }
        
        // store result into operand
        self.actualResult = Int(self.operandOne.text!)
        
        // switch for operation
        switch self.indicatedOperator {
        case "plus":
            self.actualResult! += Int(self.operandTwo.text!)!
        case "minus":
            self.actualResult! -= Int(self.operandTwo.text!)!
        case "multiply":
            self.actualResult! *= Int(self.operandTwo.text!)!
        case "divide":
            self.actualResult! /= Int(self.operandTwo.text!)!
        default:
            break
        }
    }
    
    func calculateDivisors(n: Int) -> [Int] {
        var result: [Int] = []
        for i in 1...n {
            guard n % i == 0  else {continue}
            result.append(i)
        }
        print("FACTORS:", result)
        return result
    }

}

