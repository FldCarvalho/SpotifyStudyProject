//
//  ViewController.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [NewReleasesCellViewModel])
    case recommendedTracks(viewModels: [NewReleasesCellViewModel])
}

class HomeViewController: UIViewController {
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createSectionLayout())
        registerCollectionViewCells(collectionView: collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private lazy var topRightButton: UIBarButtonItem = {
        var btn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        return btn
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()

    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: Private Functions
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendedTracks: RecommendationsResponse?
        
        // New Releases
        APICaller.shared.getAPI(request: GenericGetModel.Model.Request<NewReleasesResponse>.init(endpoint: APIEndpoints.newReleases.rawValue + "?limit=50", completion: { result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model):
                newReleases = model
            case . failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }))
        
        // Features Playlists
        APICaller.shared.getAPI(request: GenericGetModel.Model.Request<FeaturedPlaylistsResponse>.init(endpoint: APIEndpoints.featuredPlaylists.rawValue, completion: { result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model):
                featuredPlaylists = model
            case . failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }))
        
        // Recommended Tracks
        APICaller.shared.getAPI(request: GenericGetModel.Model.Request<RecommendedGenresResponse>.init(endpoint: APIEndpoints.recommendedGenres.rawValue, completion: { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }

                APICaller.shared.getAPI(request: GenericGetModel.Model.Request<RecommendationsResponse>.init(endpoint: APIEndpoints.recommendations.rawValue + seeds.joined(separator: ","), completion: { result in
                    defer {
                        group.leave()
                    }
                    
                    switch result {
                    case .success(let model):
                        recommendedTracks = model
                    case . failure(let error):
                        print("ERROR: \(error.localizedDescription)")
                    }
                }))

            case . failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }))
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = recommendedTracks?.tracks else {
                      return
                  }
            self.configureModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
        }
    }
    
    // Mudar
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
        // Configure Models
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-"
            )
        })))
        sections.append(.featuredPlaylists(viewModels: []))
        sections.append(.recommendedTracks(viewModels: []))
        collectionView.reloadData()
    }
    
    private func createSectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Vertical Group in Horizontal Group
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(390)
                    ),
                    subitem: item,
                    count: 3
                )
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.9),
                        heightDimension: .absolute(390)
                    ),
                    subitem: verticalGroup,
                    count: 1
                )
                
                // Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            case 1:
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(200)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Vertical Group in Horizontal Group
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: item,
                    count: 2
                )
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: verticalGroup,
                    count: 1
                )
                
                // Section
                let section = NSCollectionLayoutSection(
                    group: horizontalGroup
                )
                section.orthogonalScrollingBehavior = .continuous
                return section
            case 2:
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(80)
                    ),
                    subitem: item,
                    count: 1
                )
                // Section
                let section = NSCollectionLayoutSection(group: group)
                return section
            default:
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(390)
                    ),
                    subitem: item,
                    count: 1
                )
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        })
    }
    
    private func registerCollectionViewCells(collectionView: UICollectionView) {
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.register(
            NewReleaseCollectionViewCell.self,
            forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier
        )
        collectionView.register(
            FeaturedPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier
        )
        collectionView.register(
            RecommendedTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
        )
    }
    
    // MARK: Actions
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: iOSViewCode {
    func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(spinner)
    }
    
    func setupConstraints() {
    }
    
    func additionalSetup() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = topRightButton
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath
            ) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath
            ) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .orange
            return cell
        }
    }
}

