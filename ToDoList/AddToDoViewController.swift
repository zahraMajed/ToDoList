//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by admin on 17/12/2021.
//

import UIKit

class AddToDoViewController: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: AddToDoDelegates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AddToDoBtnPressed(_ sender: Any) {
        if let titleTF = titleTF.text, !titleTF.isEmpty, let noteTV = noteTV.text {
            print("enter if")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let date = dateFormatter.string(from: datePicker.date)
            delegate?.addToDos(title: titleTF, note: noteTV, date: date)
            navigationController?.popViewController(animated: true)
            print("end if")
        }else {
            //alert dialig here
            print("title is empty")
        }
    }
    
}
