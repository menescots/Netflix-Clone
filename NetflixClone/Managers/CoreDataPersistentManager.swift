//
//  CoreDataPersistentManager.swift
//  NetflixClone
//
//  Created by Agata Menes on 08/03/2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataPersistentManager {
    
    enum CoredataError: Error {
        case failedToSave
        case failedToFetch
        case failedToDelete
    }
    static let shared = CoreDataPersistentManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void,Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = FilmItem(context: context)
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average ?? 0
        
        do {
           try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoredataError.failedToSave))
        }
    }
    
    func fetchingFilmsFromCoreData(completion: @escaping (Result<[FilmItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        var request: NSFetchRequest<FilmItem>
        request = FilmItem.fetchRequest()
        
        do {
           let films = try context.fetch(request)
            completion(.success(films))
        } catch {
            
            completion(.failure(CoredataError.failedToFetch))
        }
    }
    
    func deleteFilmWith(model: FilmItem, completion: @escaping (Result<Void,Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoredataError.failedToDelete))
        }
    }
}
