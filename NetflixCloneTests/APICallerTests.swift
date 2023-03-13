//
//  APICallerTests.swift
//  NetflixCloneTests
//
//  Created by Agata Menes on 09/03/2023.
//
import OHHTTPStubsSwift
import OHHTTPStubs
import XCTest
@testable import NetflixClone
final class APICallerTests: XCTestCase {
    var sut: APICaller!
    
    override func setUpWithError() throws {
        sut = APICaller()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testGettingTitlesFromDB() {
        let data = dataFrom(filename: "TestJSONTitle")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let title = try! decoder.decode(Title.self, from: data)
        XCTAssertEqual(title.title, "Operation Fortune: Ruse de Guerre")
        XCTAssertEqual(title.original_title, "Operation Fortune: Ruse de Guerre")
        XCTAssertEqual(title.id, 739405)
        XCTAssertEqual(title.overview, "Special agent Orson Fortune and his team of operatives recruit one of Hollywood's biggest movie stars to help them on an undercover mission when the sale of a deadly new weapons technology threatens to disrupt the world order.")
        XCTAssertEqual(title.poster_path, "/vQGw9lzfh9hEoYSOWAE5XbZ6J7s.jpg")
        XCTAssertEqual(title.vote_count, 102)
        XCTAssertEqual(title.vote_average, 6.794)
        XCTAssertEqual(title.release_date, "2023-01-04")
    }
    
    func testGetTopRated() {
        let expectation = XCTestExpectation(description: "Fetching data from server")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/top_rated") ) { _ in
            let stubPath = OHPathForFile("fullJsonTitleResponse.json", type(of: self))
            return fixture(
                filePath: stubPath!,
                status: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        APICaller.shared.getTopRated { result in
            switch result {
            case .success(let films):
                XCTAssertEqual(films.count, 20)
                XCTAssertEqual(films.first?.id, 238)
                expectation.fulfill()
            case .failure(_):break
                
            }
        }
        
        wait(for: [expectation], timeout: 2)
        HTTPStubs.removeAllStubs()
    }

    func testUpcomingFilms() {
        let expectation = XCTestExpectation(description: "Fetching data from server")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/upcoming") ) { _ in
            let stubPath = OHPathForFile("upcomingTitles.json", type(of: self))
            return fixture(
                filePath: stubPath!,
                status: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        APICaller.shared.getUpcomingMovies { result in
            switch result {
            case .success(let films):
                XCTAssertEqual(films.count, 20)
                XCTAssertEqual(films.first?.id, 315162)
                expectation.fulfill()
            case .failure(_): break
            }
        }
        
        wait(for: [expectation], timeout: 2)
        HTTPStubs.removeAllStubs()
    }
    
    func testPopularFilms() {
        let expectation = XCTestExpectation(description: "Fetching data from server")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/popular") ) { _ in
            let stubPath = OHPathForFile("popularTitles.json", type(of: self))
            return fixture(
                filePath: stubPath!,
                status: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        APICaller.shared.getPopularMovies { result in
            switch result {
            case .success(let films):
                XCTAssertEqual(films.count, 20)
                XCTAssertEqual(films.first?.id, 631842)
                expectation.fulfill()
            case .failure(_): break
                
            }
        }
        wait(for: [expectation], timeout: 2)
        HTTPStubs.removeAllStubs()
    }
    
    func testDiscoveredMovies() {
        let expectation = XCTestExpectation(description: "Fetching data from server")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/discover/movie") ) { _ in
            let stubPath = OHPathForFile("discoveredMovies.json", type(of: self))
            return fixture(
                filePath: stubPath!,
                status: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        APICaller.shared.getDiscoveredMovies { result in
            switch result {
            case .success(let films):
                XCTAssertEqual(films.count, 20)
                XCTAssertEqual(films.first?.id, 631842)
                expectation.fulfill()
            case .failure(_): break
            }
        }
        
        wait(for: [expectation], timeout: 2)
        HTTPStubs.removeAllStubs()
    }
    
    func testGettingFilmFromYoutube() {
        let expectation = XCTestExpectation(description: "Fetching data from server")
        
        stub(condition: isHost("youtube.googleapis.com") && isPath("/youtube/v3/search") ) { _ in
            let stubPath = OHPathForFile("youtubeResponse.json", type(of: self))
            return fixture(
                filePath: stubPath!,
                status: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        APICaller.shared.getMovieFromYouTube(with: "harry", completion: { result in
            switch result {
            case .success(let film):
                XCTAssertEqual(film.id.kind, "youtube#video")
                XCTAssertEqual(film.id.videoId, "z4K2F_OALPQ")
                expectation.fulfill()
            case .failure(_): break
            }
        })
        wait(for: [expectation], timeout: 2)
        HTTPStubs.removeAllStubs()
    }
    
    func testSearchingForFilms() {
        let expectation = XCTestExpectation(description: "Fetching data from server")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/search/movie") ) { _ in
            let stubPath = OHPathForFile("searchFilms.json", type(of: self))
            return fixture(
                filePath: stubPath!,
                status: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        APICaller.shared.search(for: "Harry") { result in
            switch result {
            case .success(let films):
                XCTAssertEqual(films.count, 20)
                XCTAssertEqual(films.first?.id, 671)
                expectation.fulfill()
            case .failure(_):
                break
            }
        }
        wait(for: [expectation], timeout: 2)
        HTTPStubs.removeAllStubs()
    }
    
}

extension XCTestCase {
    func dataFrom(filename: String) -> Data {
        let path = Bundle(for: APICallerTests.self).path(forResource: filename, ofType: "json")!
        return NSData(contentsOfFile: path)! as Data
    }
}
