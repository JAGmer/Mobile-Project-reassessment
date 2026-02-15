//
//  ToDoListTableViewController.swift
//  To Do List
//
//  Created by JAGmer J on 07/02/2026.
//

import UIKit
import MessageUI

class ToDoListTableViewController: UITableViewController, ToDoTableViewCellDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var taskSearchBar: UISearchBar!
    
    //var toDoID = UUID()
    var allToDosList = [ToDo]()
    var filteredToDos = [ToDo]()
    var toDoCategories = [String]()
   // var groupedCategories = [String: [ToDo]]()
    var isSearching: Bool { return !taskSearchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var sectionCategoryName: String = ""
    var toDosByCategory = [ToDo]()
    var toDoByCategoryIndex: Int = 0
    var oldCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TaskTableHeader.self, forHeaderFooterViewReuseIdentifier: "header")

        navigationItem.leftBarButtonItem = editButtonItem
        taskSearchBar.delegate = self
        
        if let savedToDos = ToDo.loadToDos()
        {
            allToDosList = savedToDos
        }
        else
        {
            allToDosList = ToDo.loadSampleToDos()
        }
        filteredToDos = allToDosList
        
      //  groupedCategories = Dictionary(grouping: filteredToDos, by: { $0.category } )
        
        refreshCategories()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            guard granted else { return }
            self?.getNotificationSettings()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
 

    
    func refreshCategories()
    {
        let uniqueCategories = Set(filteredToDos.map { $0.category })
        toDoCategories = uniqueCategories.sorted()
    }
    
    fileprivate func saveToDos() {
        ToDo.saveToDos(filteredToDos)
        allToDosList = ToDo.loadToDos() ?? []
        refreshToDoTableView()
    }
    
    func refreshToDoTableView()
    {
        refreshCategories()
        tableView.reloadData()
        toDoByCategoryIndex = 0
        sectionCategoryName = ""
    }
    
    func getNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
        }
    }
    
    
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
        
        let toDoIndex = sender.tag
        let reminderVC = ReminderViewController(date: filteredToDos[toDoIndex].dueDate)
        
        reminderVC.selectedTask = filteredToDos[toDoIndex]
        reminderVC.modalPresentationStyle = .custom
        reminderVC.transitioningDelegate = self
        present(reminderVC, animated: true)
    }
    
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        let detailsVC = ToDoDetailTableViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return detailsVC }
        tableView.deselectRow(at: indexPath, animated: true)
        
        detailsVC?.toDo = filteredToDos[cell.tag]
        oldCategory = filteredToDos[cell.tag].category
        return detailsVC
    }
    
    func checkmarkTapped(sender: ToDoTableViewCell)
    {
        let toDoIndex = sender.tag
        var toDo = filteredToDos[toDoIndex]
        toDo.isCompleted.toggle()
        filteredToDos[toDoIndex] = toDo
        saveToDos()
       // refreshToDoTableView()
    }
    
    @IBAction func unwindToDoList(segue: UIStoryboardSegue)
    {
        guard segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        
        if let toDo = sourceViewController.toDo
        {
           // sourceViewController.
            print(toDo.category)
            
            if let indexOfExistingToDo = filteredToDos.firstIndex(of: toDo)
            {
                filteredToDos[indexOfExistingToDo] = toDo
                if sourceViewController.categoryUpdated
                {
                    let toDosByOldCategory = filteredToDos.filter{ $0.category == sourceViewController.oldCategory }
                    for i in 0..<toDosByOldCategory.count
                    {
                        let toDosByOldCategory = toDosByOldCategory[i]
                        let toDosByOldCategoryIndex = filteredToDos.firstIndex(of: toDosByOldCategory) ?? -1
                        filteredToDos[toDosByOldCategoryIndex].category = toDo.category
                    }
                }
            }
            else
            {
                filteredToDos.append(toDo)
            }
        }
        saveToDos()
       //refreshToDoTableView()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let category = toDoCategories[section]
        
        return filteredToDos.filter { $0.category == category}.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return toDoCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoTableViewCell
        cell.delegate = self
        
        let dataSource = filteredToDos
        let categoryName = toDoCategories[indexPath.section]
        
        if(sectionCategoryName != categoryName)
        {
            sectionCategoryName = categoryName
            toDosByCategory = dataSource.filter { $0.category == sectionCategoryName }
            toDoByCategoryIndex = 0
        }
        
        let toDo = toDosByCategory[toDoByCategoryIndex]
        
        
        if toDoByCategoryIndex < toDosByCategory.count - 1
        {
            toDoByCategoryIndex += 1
        }
        
        let toDoIndex = dataSource.firstIndex(of: toDo) ?? -1
        cell.titleLabel?.text = toDo.title
        cell.tag = toDoIndex
        cell.notificationButton.tag = toDoIndex
        cell.isCompletedButton.tag = toDoIndex
        cell.isCompletedButton.isSelected = toDo.isCompleted
        
        
        let diff = Calendar.current.dateComponents([.hour], from: Date(), to: toDo.dueDate)
        if let hours = diff.hour, hours < 1
        {
            cell.backgroundColor = UIColor(red: 1.0, green: 90/255, blue: 90/255, alpha: 0.7)
        }
        else if let hours = diff.hour, hours <= 24 && hours > 1
        {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 200/255, alpha: 0.7)
        }
        else
        {
            cell.backgroundColor = .systemBackground
        }
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if let cell = tableView.cellForRow(at: indexPath)
            {
                let toDoIndex = cell.tag
                filteredToDos.remove(at: toDoIndex)
                saveToDos()
              //  refreshToDoTableView()
            }
        }
        else if editingStyle == .insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TaskTableHeader
        header?.headerName.text = toDoCategories[section]
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ToDoListTableViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchBar.showsCancelButton = true
        if(searchText.isEmpty)
        {
            filteredToDos = allToDosList
            searchBar.showsCancelButton = false
        }
        else
        {
            filteredToDos = allToDosList.filter { item in return item.title.lowercased().contains(searchText.lowercased()) }
            searchBar.showsCancelButton = true
        }
        refreshCategories()
        refreshToDoTableView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        print("Cancel button tapped.")
        searchBar.text = ""
        filteredToDos.removeAll()
        filteredToDos = allToDosList
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        refreshCategories()
        refreshToDoTableView()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }
}

extension ToDoListTableViewController: UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
