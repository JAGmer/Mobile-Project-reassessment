//
//  ToDoTableViewCell.swift
//  To Do List
//
//  Created by JAGmer J on 07/02/2026.
//

import UIKit

protocol ToDoTableViewCellDelegate: AnyObject
{
    func checkmarkTapped(sender: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell, ToDoTableViewCellDelegate {

    @IBOutlet weak var isCompletedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    
    weak var delegate: ToDoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func completedButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    func checkmarkTapped(sender: ToDoTableViewCell) { }
    
}
