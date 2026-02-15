//
//  ReminderViewController.swift
//  To Do List
//
//  Created by JAGmer J on 12/02/2026.
//

import UIKit
import MessageUI

protocol ReminderDelegate: AnyObject
{
    func didSaveReminderDate(_ date: Date)
}

class ReminderViewController: UIViewController, UNUserNotificationCenterDelegate {

    weak var delegate: ReminderDelegate?
    var date: Date?
    var selectedTask: ToDo?
    
    private let remindLabel: UILabel = {
        let label = UILabel()
        label.text = "Remind me at..."
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    private let remindButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Set Reminder"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .systemBlue
        config.image = UIImage(systemName: "bell.fill")
        config.imagePadding = 8
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(date: Date)
    {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        datePicker.minimumDate = Date()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func sendNotification(selectedTask: ToDo)
    {
        print("Selected Task: \(selectedTask)")
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = selectedTask.title
        content.body = selectedTask.notes ?? ""
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        
        let reminderDate = datePicker.date
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        print(dateComponents)
        
        var timeMessage: String = ""
        if(dateComponents.hour! > 12)
        {
            let timePM = dateComponents.hour! - 12
            timeMessage = "\(timePM):\(dateComponents.minute!)PM"
        }
        else
        {
            timeMessage = "\(dateComponents.hour!):\(dateComponents.minute!)AM"
        }
        
        guard let hostVC = self.presentingViewController else { return }
        let alert = UIAlertController(title: "Reminder", message: "Reminder set at: \(dateComponents.day ?? 0), \(dateComponents.month ?? 0), \(timeMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        
        print("set notifcation at: \(trigger)")
        
        self.dismiss(animated: true)
        {
            hostVC.present(alert, animated: true, completion: nil)
        }
    }
    func registerCategories()
    {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    @objc private func handleRemindButton()
    {
        delegate?.didSaveReminderDate(datePicker.date)
        sendNotification(selectedTask: selectedTask!)
        dismiss(animated: true)
    }
    
    private func setupUI()
    {
        let verticalStackView = UIStackView(arrangedSubviews: [remindLabel, datePicker, remindButton])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 20
        verticalStackView.alignment = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        remindButton.addTarget(self, action: #selector(handleRemindButton), for: .touchUpInside)
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
