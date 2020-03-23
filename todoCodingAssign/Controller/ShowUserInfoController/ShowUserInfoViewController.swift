//
//  ShowUserInfoViewController.swift
//  todoCodingAssign
//
//  Created by Ruoming Gao on 3/21/20.
//  Copyright © 2020 Ruoming Gao. All rights reserved.
//

import UIKit

class ShowUserInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var nameInputString: String?
    var currentCoreDataPerson = try? CoreDataManager.coreDataManager.fetchAll(entity: Person.self)
    
    override func viewDidLoad() {
        let addButton = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addNewUser))
        self.navigationItem.rightBarButtonItem = addButton
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ShowUserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }
    
    @objc func addNewUser() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "fillOutViewController") as? FillOutViewController else { return }
        vc.saveUserDelegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension ShowUserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCoreDataPerson?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case tableView:
            let completeTableCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! ShowUserInfoTableViewCell
            completeTableCell.getConfigure(model: currentCoreDataPerson?[indexPath.row])
            cell = completeTableCell
        default:
            print("error")
        }
        return cell
    }
}

extension ShowUserInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "fillOutViewController") as? FillOutViewController else { return }
        vc.saveUserDelegate = self
        guard let person = currentCoreDataPerson?[indexPath.row] else { return }
        vc.savedPerson = person
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            guard let object = currentCoreDataPerson?[indexPath.row] else { return }
            currentCoreDataPerson?.remove(at: indexPath.row)
            CoreDataManager.coreDataManager.delete(entity: object)
            try? CoreDataManager.coreDataManager.save()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension ShowUserInfoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentCoreDataPerson = try? CoreDataManager.coreDataManager.fetchAll(entity: Person.self)
        let coreDataPerson = currentCoreDataPerson
        currentCoreDataPerson = coreDataPerson?.filter({ (person) -> Bool in
            guard let text = searchBar.text else { return false }
            return person.name?.contains(text) ?? false
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        currentCoreDataPerson = try? CoreDataManager.coreDataManager.fetchAll(entity: Person.self)
        let coreDataPerson = currentCoreDataPerson
        switch selectedScope {
        case 0:
            currentCoreDataPerson = coreDataPerson
        case 1:
            currentCoreDataPerson = coreDataPerson?.filter({ (person) -> Bool in
                person.status == true
            })
        case 2:
            currentCoreDataPerson = coreDataPerson?.filter({ (person) -> Bool in
                person.status == false
            })
        default:
            break
        }
        tableView.reloadData()
    }
}

extension ShowUserInfoViewController: UpdateUserProtocol {
    func updateUserTableView() {
        currentCoreDataPerson = try? CoreDataManager.coreDataManager.fetchAll(entity: Person.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

