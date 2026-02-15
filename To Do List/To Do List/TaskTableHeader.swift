//
//  TaskTableHeader.swift
//  To Do List
//
//  Created by JAGmer J on 11/02/2026.
//

import UIKit

class TaskTableHeader: UITableViewHeaderFooterView {

    static let identifier = "TableHeader"
    
    let headerName: UILabel = {
        let label = UILabel()
        label.text = "Category Name"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(headerName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerName.sizeToFit()
        headerName.frame = CGRect(x: 15, y: contentView.frame.size.height - 10 - headerName.frame.size.height, width: contentView.frame.size.width, height: headerName.frame.size.height)
    }
    
}
