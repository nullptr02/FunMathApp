//
//  ViewController.swift
//  FunMathApp
//
//  Created by Michael on 2021-11-29.
//

import UIKit
import CoreData

var scores: [Int] = [0, 0, 0, 0]

class ViewController: UIViewController {

    
    //Buttons
    @IBOutlet weak var startAddition: UIButton!
    @IBOutlet weak var startMultiplication: UIButton!
    @IBOutlet weak var startSubtraction: UIButton!
    @IBOutlet weak var startDivision: UIButton!
    
    //High Scores
    @IBOutlet weak var additionScore: UILabel!
    @IBOutlet weak var multiplicationScore: UILabel!
    @IBOutlet weak var subtractionScore: UILabel!
    @IBOutlet weak var divisionScore: UILabel!
    
    //Identifiers
    let additionSegueID = "additionSegue"
    let multiplicationSegueID = "multiplicationSegue"
    let subtractionSegueID = "subtractionSegue"
    let divisionSegueID = "divisionSegue"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eraseHighScores()
        setScores()
        
        self.startAddition.layer.cornerRadius = 25
        self.startAddition.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
        
        self.startSubtraction.layer.cornerRadius = 25
        self.startSubtraction.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
        
        self.startMultiplication.layer.cornerRadius = 25
        self.startMultiplication.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
        
        self.startDivision.layer.cornerRadius = 25
        self.startDivision.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateScores()
    }
    
    func eraseHighScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // entity to save the scores in CoreData
        let scoresEntity = NSEntityDescription.insertNewObject(forEntityName: "SavedScoresEntity", into:context)

        // set the initial scores
        scoresEntity.setValue(0, forKey: "addition")
        scoresEntity.setValue(0, forKey: "subtraction")
        scoresEntity.setValue(0, forKey: "multiplication")
        scoresEntity.setValue(0, forKey: "division")

        // save the changes
        do {
            try context.save()
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func setScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedScoresEntity")
        
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        // add date from Core Data to the scores list
        for scoresEntity in fetchedResults! {
            scores[0] = scoresEntity.value(forKey: "addition") as! Int
            scores[1] = scoresEntity.value(forKey: "subtraction") as! Int
            scores[2] = scoresEntity.value(forKey: "multiplication") as! Int
            scores[3] = scoresEntity.value(forKey: "division") as! Int
        }
    }
    
    func updateScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // store the scores in Core Data
        let scoresEntity = NSEntityDescription.insertNewObject(forEntityName: "SavedScoresEntity", into:context)

        // set the initial scores
        scoresEntity.setValue(scores[0], forKey: "addition")
        scoresEntity.setValue(scores[1], forKey: "subtraction")
        scoresEntity.setValue(scores[2], forKey: "multiplication")
        scoresEntity.setValue(scores[3], forKey: "division")

        // commit the changes
        do {
            try context.save()
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        self.additionScore.text = String(scores[0])
        self.subtractionScore.text = String(scores[1])
        self.multiplicationScore.text = String(scores[2])
        self.divisionScore.text = String(scores[3])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as! GameViewController
        
        // selects the segue's selected operator
        if segue.identifier == additionSegueID {
            gameVC.indicatedOperator = "plus"
        } else if segue.identifier == subtractionSegueID {
            gameVC.indicatedOperator = "minus"
        } else if segue.identifier == multiplicationSegueID {
            gameVC.indicatedOperator = "multiply"
        } else if segue.identifier == divisionSegueID {
            gameVC.indicatedOperator = "divide"
        }
        
        gameVC.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func returnToHome(segue: UIStoryboardSegue) {}
}

