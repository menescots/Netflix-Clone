//
//  FilmPreviewViewController.swift
//  NetflixClone
//
//  Created by Agata Menes on 07/03/2023.
//

import UIKit
import WebKit

class FilmPreviewViewController: UIViewController {
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .systemBackground
        return webView
    }()
    
    private let filmTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemGray4
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(filmTitleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        view.addSubview(webView)
        view.backgroundColor = .systemBackground
        configureConstaints()
    }


    func configureConstaints() {
        let webViewConstaints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: (view.frame.height/3) - 20)
        ]
        
        let titleConstraints = [
            filmTitleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            filmTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filmTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        let overView = [
            overviewLabel.topAnchor.constraint(equalTo: filmTitleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(webViewConstaints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(overView)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: YoutubePreviewViewModel) {
        filmTitleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let id = model.youtubeView.id.videoId else { return }
        guard let url = URL(string: "https://www.youtube.com/embed/\(id)") else {
            return
        }
        print(url)
        let request = URLRequest(url: url)
        DispatchQueue.main.async{ [weak self] in
            self?.webView.load(request)
        }
    }
}
