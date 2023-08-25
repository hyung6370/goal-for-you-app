//
//  GoalViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/24.
//

import UIKit
import Firebase

class GoalViewController: UIViewController {
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    
    let db = Firestore.firestore()
    
    var journeys: [Journey] = []
    
    var goalTitle: String?
    var goalDescription: String?
    
    var goalDocumentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addButtonCreated()
        fetchMain()
        
        itemTableView.register(UINib(nibName: "GoalTableViewCell", bundle: nil), forCellReuseIdentifier: "GoalsCell")
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadJourneys()
    }
    
    
    func loadJourneys() {
        print("Current UID: \(Auth.auth().currentUser?.uid ?? "No UID")")
        print("Goal Document ID: \(goalDocumentId ?? "No Goal Document ID")")
        
        guard let uid = Auth.auth().currentUser?.uid, let goalId = goalDocumentId else {
            print("UID or Goal Document ID is missing")
            return
        }
        
        db.collection("users").document(uid).collection("goals").document(goalId).collection("journeys").getDocuments { (snapshot, error) in
            if let e = error {
                print("Error fetching journeys from Firestore: \(e.localizedDescription)")
                return
            }
            
            self.journeys = []
            
            if let documents = snapshot?.documents {
                for doc in documents {
                    let data = doc.data()
                    if let journeyTitle = data["journeyTitle"] as? String, let journeyDescription = data["journeyDescription"] as? String {
                        let newJourney = Journey(journeyTitle: journeyTitle, journeyDescription: journeyDescription)
                        self.journeys.append(newJourney)
                    }
                }
                
                self.itemTableView.reloadData()
            }
        }
    }
    
    func fetchMain() {
        mainTitle.text = goalTitle
        mainDescription.text = goalDescription
    }
    
    func addButtonCreated() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hexCode: "9524ED")
    }
    
    @objc func addButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let addJourneyVC = storyboard.instantiateViewController(identifier: "AddJourneyVC") as? AddJourneyViewController {
            
            
            self.navigationController?.pushViewController(addJourneyVC, animated: true)
        }
    }
}


extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalsCell", for: indexPath) as! GoalTableViewCell
        
        let journey = journeys[indexPath.row]
        cell.titleLabel.text = journey.journeyTitle
        cell.descriptionLabel.text = journey.journeyDescription
        
        return cell
    }
}
