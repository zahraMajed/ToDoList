//
//  ViewController.swift
//  ToDoList
//
//  Created by admin on 16/12/2021.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController, AddToDoDelegates {
    var toDosArray: [ToDosStruct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        toDosArray = getToDos()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDoTableViewCell
        cell.toDoTitle.text = toDosArray[indexPath.row].toDoTitle
        cell.toDoNote.text = toDosArray[indexPath.row].toDoNote
        cell.toDoDate.text = toDosArray[indexPath.row].toDoDueDate
        if toDosArray[indexPath.row].isDone {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            updateIsTaskDone(indexP: indexPath.row, statuse: false)
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            updateIsTaskDone(indexP: indexPath.row, statuse: true)
        }
    }
    
    //commit editing style (to add delete featute when you drag cell to the left)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteToDo(indexP: indexPath.row)
        toDosArray = getToDos()
        tableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addToDoVC = segue.destination as! AddToDoViewController
        print("assign delegates")
        addToDoVC.delegate = self
    }
    
    //implemnting delegates methods
    func addToDos(title: String, note: String, date: String) {
        print("enter addTodDo() ToDoVC")
        addToDoRecoerd(toDoStruct: ToDosStruct(toDoTitle: title, toDoNote: note, toDoDueDate: date, isDone: false))
        toDosArray = getToDos()
        tableView.reloadData()
    }
    
    
}

struct ToDosStruct {
    var toDoTitle: String
    var toDoNote: String
    var toDoDueDate: String
    var isDone: Bool
}

extension ToDoViewController {
    
    func getToDos() -> [ToDosStruct] {

        var tasksArrayToReturn: [ToDosStruct] = []
        // refer to appdelegate in order to be abel accessing persistentContainer
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        // create context from persistentContainer -context is mu DB-
        let context = appDelegate.persistentContainer.viewContext
        // get fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksEntity")
        
        do {
           let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            //here i am getting all data in contxt and store them in array
            for data in result {
                let toDoTitle = data.value(forKey: "taskTitle") as! String
                let toDoNote = data.value(forKey: "taskNote") as! String
                let toDoDueDate = data.value(forKey: "taskDueDate") as? String ?? "MM-dd-yyyy HH:mm"
                let isDone = data.value(forKey: "isTaskDone") as! Bool
                tasksArrayToReturn.append(ToDosStruct(toDoTitle: toDoTitle, toDoNote: toDoNote, toDoDueDate: toDoDueDate, isDone: isDone))
            }
        }catch {
            print("===Error getToDos Function===")
        }
        return tasksArrayToReturn
    }
    
    func addToDoRecoerd(toDoStruct:ToDosStruct){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        guard let tasksEntity = NSEntityDescription.entity(forEntityName: "TasksEntity", in: context) else {return}
        
        //create record and set value to it
        let task = NSManagedObject(entity: tasksEntity, insertInto: context)
        task.setValue(toDoStruct.toDoTitle, forKey: "taskTitle")
        task.setValue(toDoStruct.toDoNote, forKey: "taskNote")
        task.setValue(toDoStruct.toDoDueDate, forKey: "taskDueDate")
        task.setValue(toDoStruct.isDone, forKey: "isTaskDone")
        // save changes to database (context)
        do{
            try context.save()
        }catch {
            print("===Error addToDoRecoerd Function===")
        }
    }
    
    func deleteToDo(indexP:Int) {
        // refer to appdelegate in order to be abel accessing persistentContainer
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        // create context from persistentContainer -context is mu DB-
        let context = appDelegate.persistentContainer.viewContext
        // get fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksEntity")
        
        do{
            let result = try context.fetch(fetchRequest)
            let objectToDel = result[indexP] as! NSManagedObject
            context.delete(objectToDel)
            try context.save()
        }catch{
            print("======Error Delete function========")
        }
    }
    
    func updateIsTaskDone(indexP: Int, statuse:Bool)  {
        
        // refer to appdelegate in order to be abel accessing persistentContainer
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        // create context from persistentContainer -context is mu DB-
        let context = appDelegate.persistentContainer.viewContext
        // get fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksEntity")
        
        do {
           let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[indexP].setValue(statuse, forKey: "isTaskDone")
            try context.save()
        }catch {
            print("===Error updateTaks Function===")
        }
   }
}
