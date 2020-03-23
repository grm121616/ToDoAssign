//
//  FillOutViewController.swift
//  todoCodingAssign
//
//  Created by Ruoming Gao on 3/21/20.
//  Copyright © 2020 Ruoming Gao. All rights reserved.
//

import UIKit
import CoreData

class FillOutViewController: UIViewController {
    
    var user: User?
    var users: [User] = []
    var isSubmit: Bool?
    var saveUserDelegate: UpdateUserProtocol?
    var savedUserName: String?
    var savedUserGender: String?
    var savedPerson: Person?
    
    @IBOutlet weak var nameInput: UITextField!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        getUserInfo(status: false)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let name = nameInput.text
        user?.name = name
        isSubmit = true
        if user?.name == "" {
            nameInput.layer.borderWidth = 1
            nameInput.layer.borderColor = UIColor.red.cgColor
            isSubmit = false
        }
        if user?.gender == "" {
            maleButton.setTitleColor(.red, for: .normal)
            femaleButton.setTitleColor(.red, for: .normal)
            isSubmit = false
        }
        if isSubmit == true {
            getUserInfo(status: true)
        }
    }
 
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBAction func genderSelect(_ sender: UIButton) {
        if sender == maleButton {
            maleButton.backgroundColor = UIColor.blue
            femaleButton.backgroundColor = UIColor.white
            user?.gender = "male"
        } else if sender == femaleButton {
            maleButton.backgroundColor = UIColor.white
            femaleButton.backgroundColor = UIColor.red
            user?.gender = "female"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let name = savedPerson?.name, let gender = savedPerson?.gender else { return user = User(name: "", gender: "")}
        user = User(name: name, gender: gender)
        nameInput.text = name
        if gender == "male" {
            maleButton.backgroundColor = UIColor.blue
        } else if gender == "female" {
            femaleButton.backgroundColor = UIColor.red
        }
    }
    
    func getUserInfo(status: Bool) {
        let name = nameInput.text
        user?.name = name
        if let user = user {
            users.append(user)
        } else {
            print("no data")
        }
        if let savedPersonData = savedPerson {
            savedPersonData.name = user?.name
            savedPersonData.gender = user?.gender
            savedPersonData.status = status
        } else {
            guard let coreDataObject = try? CoreDataManager.coreDataManager.createObject(entity: Person.self) else { return }
            coreDataObject.name = user?.name
            coreDataObject.gender = user?.gender
            coreDataObject.status = status
        }
        saveUserDelegate?.updateUserTableView()
        try? CoreDataManager.coreDataManager.save()
        dismiss(animated: true, completion: nil)
    }
}

protocol UpdateUserProtocol {
    func updateUserTableView()
}

