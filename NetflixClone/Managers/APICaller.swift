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
    static let YTAPI_Key = "AIzaSyCgNGnOivocvxKbfS9hb88jl7wBZunGmFk"
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
    
    func getDiscoveredMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.dbURL)/3/discover/movie?api_key=\(Constants.API_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        print(url)
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
    
    func search(for query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return 
        }
        guard let url = URL(string: "\(Constants.dbURL)/3/search/movie?api_key=\(Constants.API_Key)&query=\(query)") else {
            return }
        print(url)
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
    
    func getMovieFromYouTube(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(Constants.YTAPI_Key)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(YoutubeResponse.self, from: data)
                completion(.success(results.items[2]))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

//https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1
