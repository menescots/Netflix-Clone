//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Agata Menes on 03/02/2023.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles = [Title]()
    private let searchMoviesTable: UITableView = {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchMoviesViewController())
        controller.searchBar.placeholder = "Search for movies, tv shows..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        searchMoviesTable.delegate = self
        searchMoviesTable.dataSource = self
        view.addSubview(searchMoviesTable)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoveredMovies()
        
        searchController.searchResultsUpdater = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchMoviesTable.frame = view.bounds
    }

    private func fetchDiscoveredMovies() {
        APICaller.shared.getDiscoveredMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchMoviesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "unknown title", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.title else {
            return
        }
        
        APICaller.shared.getMovieFromYouTube(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async{
                    let vc = FilmPreviewViewController()
                    vc.hidesBottomBarWhenPushed = true
                    vc.configure(with: YoutubePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, searchMoviesViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count > 2,
              let resultsController = searchController.searchResultsController as? SearchMoviesViewController else {
            return
        }
        
        resultsController.delegate = self
        APICaller.shared.search(for: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let films):
                    resultsController.titles = films
                    resultsController.searchMoviesCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func searchMoviesViewControllerDidTapItem(_ viewModel: YoutubePreviewViewModel) {
        DispatchQueue.main.async{ [weak self] in
            let vc = FilmPreviewViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
