//
//  CoreDataHelper.swift
//  Spring Planning Tools
//
//  Created by mendel bellaiche on 23/06/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    private init() {}
    
    // MARK: - Methods for Planning
    
    /**
        Recuperation tous les plannings
     */
    func getAllPlannings() -> [Planning]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Planning>(entityName: "Planning")
        
        do {
            let plannings = try managedContext.fetch(fetchRequest)
            return plannings
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    /**
        Recuperation d'un planning par son ID
     */
    func getPlanning(with id: UUID) -> Planning? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Planning>(entityName: "Planning")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print(error)
        }
        
        return nil
        
    }
    
    /**
        Création d"un planning
     */
    func createPlanning(title: String) -> Planning? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Planning", in: managedContext)!
        let planning = NSManagedObject(entity: entity, insertInto: managedContext) as! Planning
        planning.id = UUID()
        planning.title = title
        planning.startDate = Date()
        
        do {
            try managedContext.save()
            return planning
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func updatePlanning(idPlanning: UUID, title: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Planning>(entityName: "Planning")
        fetchRequest.predicate = NSPredicate(format: "id == %@", idPlanning as CVarArg)
        
        do {
            let planning: Planning? = try managedContext.fetch(fetchRequest).first
            
            if planning != nil {
                planning?.title = title
                try managedContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    /**
        Suppression d'un planning
     */
    func deletePlanning(with id: UUID) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Planning>(entityName: "Planning")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let planning = try managedContext.fetch(fetchRequest).first
            let tasks = planning?.tasks?.allObjects as? [Task]
            
            for task in tasks! {
                managedContext.delete(task)
            }
            
            managedContext.delete(planning!)
            
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    // MARK: - Methods for Task
    
    /**
        Recuperation tous les taches
     */
    func getAllTasks() -> [Task]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let plannings = try managedContext.fetch(fetchRequest)
            return plannings
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    /**
        Recuperation d'une tache par son ID
     */
    func getTask(with id: UUID) -> Task? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print(error)
        }
        
        return nil
        
    }
    
    /**
        Création d'un tache et association à un planning
     */
    func createTask(idPlanning: UUID, title: String, priority: Int, etat: Int) -> Task? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext) as! Task
        task.id = UUID()
        task.title = title
        task.priority = Int16(priority)
        task.desc = ""
        task.etat = Int16(etat)
        task.createdDate = Date()
        
        let planning = self.getPlanning(with: idPlanning)
        planning?.addToTasks(task)
        
        do {
            try managedContext.save()
            return task
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    /**
        Mise à jour d'une tache
     */
    func updateTask(idTask: UUID, title: String, desc: String, priority: Int, etat: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", idTask as CVarArg)
        
        do {
            let task: Task? = try managedContext.fetch(fetchRequest).first
            
            if task != nil {
                task?.title = title
                task?.desc = desc
                task?.priority = Int16(priority)
                task?.etat = Int16(etat)
                
                try managedContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    /**
        Suppression d'une tache
     */
    func deleteTask(with id: UUID) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let task = try managedContext.fetch(fetchRequest).first
            managedContext.delete(task!)
            
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    
    // MARK: - Methods for Author
    
    
    /**
        Recuperation tous les taches
     */
    func getAllAuthors() -> [Author]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Author>(entityName: "Author")
        
        do {
            let plannings = try managedContext.fetch(fetchRequest)
            return plannings
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    /**
        Recuperation d'une tache par son ID
     */
    func getAuthor(with id: UUID) -> Author? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Author>(entityName: "Author")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print(error)
        }
        
        return nil
        
    }
    
    
    // createAuthor
        // recuperation du Planning et de la Task
        // creation de l'Author
        // Association de l'Author au Planning et à la Task
        // Sauver le context
    
    
    func createTask(idPlanning: UUID, fullname: String, email: String, role: String) -> Author? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Author", in: managedContext)!
        let author = NSManagedObject(entity: entity, insertInto: managedContext) as! Author
        author.id = UUID()
        author.fullname = fullname
        author.email = email
        author.role = role
        
        let planning = self.getPlanning(with: idPlanning)
        planning?.addToAuthor(author)
        
        do {
            try managedContext.save()
            return author
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    // updateAuthor
    
    // deleteAuthor
    
}



