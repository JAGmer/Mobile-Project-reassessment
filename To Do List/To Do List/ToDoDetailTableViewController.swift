//
//  ToDoDetailTableViewController.swift
//  To Do List
//
//  Created by JAGmer J on 07/02/2026.
//

import UIKit
import MessageUI

class ToDoDetailTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var isCompletedButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryListTextField: UITextField!
    @IBOutlet weak var dateDetailLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var removeCategoryButton: UIButton!
    @IBOutlet weak var categoryButtonList: UIButton!
    @IBOutlet weak var sendMailButton: UIButton!
    
    var isDatePickerHidden = true
    let categoryIndexPath = IndexPath(row: 0, section: 1)
    let dateLabelIndexPath = IndexPath(row: 0, section: 2)
    let datePickerIndexPath = IndexPath(row: 1, section: 2)
    let notesIndexPath = IndexPath(row: 0, section: 3)
    var oldCategory : String = ""
    var categoryUpdated : Bool = false
    var toDo: ToDo?
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMailButton.isHidden = true
        
        let currentDueDate: Date
        
        if let toDo = toDo
        {
            navigationItem.title = "To-Do"
            oldCategory = toDo.category
            titleTextField.text = toDo.title
            categoryButtonList.titleLabel?.text = toDo.category
            isCompletedButton.isSelected = toDo.isCompleted
            currentDueDate = toDo.dueDate
            notesTextView.text = toDo.notes
            sendMailButton.isHidden = false
        }
        else
        {
            currentDueDate = Date().addingTimeInterval(24*60*60)
        }
        
        if let savedCategories = ToDo.loadCategories()
        {
            categories = savedCategories
        }
        else
        {
            categories = ToDo.loadSampleCategories()
        }
        
        dueDatePicker.date = currentDueDate
        updateDateDetailLabel(date: currentDueDate)
        updateSaveButtonState()
        buttonPopupList()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - Sending mail logic
    
    @IBAction func btnSendMail(_ sender: UIButton) {
        
        let mailComposeViewController = configureMailComposer()
        print("ToDoDetailViewController.swift: Line 88\nMade mailComposeViewController and configured")
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            print("ERROR: Can't send email.")
        }
    }
    func configureMailComposer() -> MFMailComposeViewController
    {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.delegate = self
        mailComposeVC.setSubject(toDo!.title)
        mailComposeVC.setMessageBody(toDo?.notes ?? "\0", isHTML: false)
        print("mail subject: \(toDo!.title)")
        print("mail body: \(toDo?.notes ?? "No Notes")")
        
        return mailComposeVC
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Updating add/edit page
    
    func updateSaveButtonState()
    {
        //let shouldEnableSaveButton = titleTextField.text?.isEmpty == false && categoryButtonList.title(for: .normal) != "Select Category"
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false && categoryListTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    func updateDateDetailLabel(date: Date)
    {
        dateDetailLabel.text = date.formatted(.dateTime.day().month(.defaultDigits).year(.twoDigits).hour().minute())
    }
    @IBAction func updatingCategoryList(_ sender: UITextField) {
        guard let txt = categoryListTextField.text, !txt.isEmpty else { return }
        
        if(categoryButtonList.titleLabel?.text == "Select Category")
        {
            categories.append(txt)
            ToDo.saveCategories(categories)
            buttonPopupList()
            categoryButtonList.setTitle(txt, for: .normal)
            categoryListTextField.text = categoryButtonList.titleLabel?.text
        }
        else
        {
            let selectedCategory = categoryButtonList.titleLabel?.text ?? ""
            if let index = categories.firstIndex(of: selectedCategory)
            {
                categoryUpdated  = true
                categories[index] = txt
                ToDo.saveCategories(categories)
            }
            buttonPopupList()
        }
        
        sender.resignFirstResponder()
    }
    @IBAction func addCategoryButtonTapped(_ sender: UIButton) {
        categoryListTextField.text = ""
        categoryButtonList.titleLabel?.text = "Select Category"
        
        updatingCategoryList(categoryListTextField)
        
    }
    @IBAction func deleteCategoryButtonTapped(_ sender: UIButton) {
        let selectedCategory = categoryButtonList.titleLabel!.text
        
        categories = categories.filter { $0 != selectedCategory }
        ToDo.saveCategories(categories)
        buttonPopupList()
    }
    
    //MARK: - Checking add/edit page elements
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func returnKeyPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func isCompletedButtonTapped(_ sender: UIButton) {
        isCompletedButton.isSelected.toggle()
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateDetailLabel(date: sender.date)
    }
    
    //MARK: - Popup Button List
    
    func buttonPopupList()
    {
        let selectedCategory = toDo?.category ?? ""
        let actionClosure = { (action: UIAction) in print(action.title); self.categoryListTextField.text = action.title; self.updateSaveButtonState() }
        let placeholder = UIAction(title: "Select Category", attributes: .disabled, state: selectedCategory.isEmpty ? .on : .off, handler: { _ in })
        var buttonMenu: [UIMenuElement] = [placeholder]
        
        for category in categories
        {
            let isSelected = (category == selectedCategory)
            buttonMenu.append(UIAction(title: category, state: isSelected ? .on : .off, handler: actionClosure))
        }
        
        categoryButtonList.menu = UIMenu(title: "Categories", options: .displayInline, children: buttonMenu)
        categoryButtonList.showsMenuAsPrimaryAction = true
        categoryButtonList.changesSelectionAsPrimaryAction = true
        categoryListTextField.text = toDo?.category
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath
        {
            case datePickerIndexPath where isDatePickerHidden == true:
                return 0
            case notesIndexPath:
                return 200
            case categoryIndexPath:
                return 150
            default:
                return UITableView.automaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath
        {
            case datePickerIndexPath:
                return 216
            case notesIndexPath:
                return 200
            default:
                return UITableView.automaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath == dateLabelIndexPath)
        {
            isDatePickerHidden.toggle()
            updateDateDetailLabel(date: dueDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    //MARK: - Prepare for segue function and filling toDo variable
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let category = categoryButtonList.titleLabel?.text
        let isCompleted = isCompletedButton.isSelected
        let dueDate = dueDatePicker.date
        let notes = notesTextView.text
        
        if(toDo != nil)
        {
            toDo?.title = title
            toDo?.category = category!
            toDo?.isCompleted = isCompleted
            toDo?.dueDate = dueDate
            toDo?.notes = notes
        }
        else
        {
            toDo = ToDo(title: title, category: category ?? "", isCompleted: isCompleted, dueDate: dueDate, notes: notes)
        }
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
