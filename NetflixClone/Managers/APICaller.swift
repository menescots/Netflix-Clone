//
//  APICaller.swift
//  NetflixClone
//
//  Created by Agata Menes on 06/02/2023.
//

import Foundation

struct Constants {
    static let API_Key = "baad3ad985cdacaacf17410291267bfe"
    static let dbURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToFetch
}

class APICaller {
    static let shared = APICaller()

    func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.dbURL)/3/trending/all/day?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(MoviesResults.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
