//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by admin on 16/12/2021.
//

import UIKit


class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var toDoTitle: UILabel!
    @IBOutlet weak var toDoDate: UILabel!
    @IBOutlet weak var toDoNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

