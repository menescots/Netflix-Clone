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

    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.dbURL)/3/trending/movie/day?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResults.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToFetch))
            }
        }
        task.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.dbURL)/3/trending/tv/day?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResults.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToFetch))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.dbURL)/3/movie/upcoming?api_key=\(Constants.API_Key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResults.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToFetch))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.dbURL)/3/movie/popular?api_key=\(Constants.API_Key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResults.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToFetch))
            }
        }
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.dbURL)/3/movie/top_rated?api_key=\(Constants.API_Key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResults.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToFetch))
            }
        }
        task.resume()
    }
}

//https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1
