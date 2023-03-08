//
//  SearchMoviesViewController.swift
//  NetflixClone
//
//  Created by Agata Menes on 08/02/2023.
//

import UIKit
protocol searchMoviesViewControllerDelegate: AnyObject {
    func searchMoviesViewControllerDidTapItem(_ viewModel: YoutubePreviewViewModel)
}
class SearchMoviesViewController: UIViewController {
    weak var delegate: searchMoviesViewControllerDelegate?
    
    public var titles = [Title]()
    
    public let searchMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout )
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchMoviesCollectionView)
        
        searchMoviesCollectionView.delegate = self
        searchMoviesCollectionView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchMoviesCollectionView.frame = view.bounds
    }

}

extension SearchMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let film = titles[indexPath.row]

        APICaller.shared.getMovieFromYouTube(with: film.original_title ?? "") { [weak self] result in
            print(result)
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchMoviesViewControllerDidTapItem(YoutubePreviewViewModel(title: film.original_title ?? "", youtubeView: videoElement, titleOverview: film.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

