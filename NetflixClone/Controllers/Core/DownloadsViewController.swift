//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Agata Menes on 03/02/2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    private var titles: [FilmItem] = [FilmItem]()
    
    private let downloadedMoviesTable: UITableView = {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloads"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        view.addSubview(downloadedMoviesTable)
        downloadedMoviesTable.delegate = self
        downloadedMoviesTable.dataSource = self
        fetchFromCoreData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ReloadTableView"), object: nil, queue: nil) { [weak self]_ in
            self?.fetchFromCoreData()
        }
        
    }

    private func fetchFromCoreData() {
        CoreDataPersistentManager.shared.fetchingFilmsFromCoreData { results in
            switch results {
            case .success(let films):
                
                DispatchQueue.main.async { [weak self] in
                    self?.titles = films
                    self?.downloadedMoviesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedMoviesTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            CoreDataPersistentManager.shared.deleteFilmWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    DispatchQueue.main.async{
                        self?.titles.remove(at: indexPath.row)
                        self?.downloadedMoviesTable.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
