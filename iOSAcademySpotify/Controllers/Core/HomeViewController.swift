//
//  ViewController.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayNewReleases(viewModels: [NewReleases.Releases.ViewModel])
    func displayNewReleasesError(viewModel: NewReleases.Releases.ViewModelError)
}

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleases.Releases.ViewModel])
    case featuredPlaylists(viewModels: [NewReleases.Releases.ViewModel])
    case recommendedTracks(viewModels: [NewReleases.Releases.ViewModel])
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
    
    // MARK: - Variables
    fileprivate var newReleaseInteractor: NewReleasesBusinessLogic?
    fileprivate var recommendedTracksInteractor: RecommendedTracksBusinessLogic?
    fileprivate var featuredPlaylistsInteractor: FeaturedPlaylistsBusinessLogic?
    private var sections = [BrowseSectionType]()

    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupView()
        newReleaseInteractor?.doNewReleases()
        recommendedTracksInteractor?.doRecommendedGenres()
        featuredPlaylistsInteractor?.doFeaturedPlaylists()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: Private Functions
    private func setup() {
        let viewController = self
        
        // New Releases
        let newReleaseInteractor = NewReleasesInteractor()
        let newReleasePresenter = NewReleasesPresenter()
        viewController.newReleaseInteractor = newReleaseInteractor
        newReleaseInteractor.presenter = newReleasePresenter
        newReleasePresenter.viewController = viewController
        
        // RecommendedTracks
        let recommendedTracksInteractor = RecommendedTracksInteractor()
        let recommendedTracksPresenter = RecommendedTracksPresenter()
        viewController.recommendedTracksInteractor = recommendedTracksInteractor
        recommendedTracksInteractor.presenter = recommendedTracksPresenter
        recommendedTracksPresenter.viewController = viewController
        
        // FeaturedPlaylists
        let featuredPlaylistsInteractor = FeaturedPlaylistsInteractor()
        let featuredPlaylistsPresenter = FeaturedPlaylistsPresenter()
        viewController.featuredPlaylistsInteractor = featuredPlaylistsInteractor
        featuredPlaylistsInteractor.presenter = featuredPlaylistsPresenter
        featuredPlaylistsPresenter.viewController = viewController
    }
    
    // Mudar
//    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
//        // Configure Models
//        sections.append(.newReleases(viewModels: newAlbums.compactMap({
//            return NewReleasesCellViewModel(
//                name: $0.name,
//                artworkURL: URL(string: $0.images.first?.url ?? ""),
//                numberOfTracks: $0.total_tracks,
//                artistName: $0.artists.first?.name ?? "-"
//            )
//        })))
//        sections.append(.featuredPlaylists(viewModels: []))
//        sections.append(.recommendedTracks(viewModels: []))
//        collectionView.reloadData()
//    }
    
    private func createSectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return NewReleasesCollectionView.shared.setCollectionViewLayout()
            case 1:
                return FeaturedPlaylistsCollectionView.shared.setCollectionViewLayout()
            case 2:
                return RecommendedTracksCollectionView.shared.setCollectionViewLayout()
            default:
                return UICollectionView().dafaultSectionLayout
            }
        })
    }
    
    private func registerCollectionViewCells(collectionView: UICollectionView) {
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.register(
            NewReleasesCollectionViewCell.self,
            forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier
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

// MARK: - View Code
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

// MARK: - Collection View
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .orange
            return cell
        }
    }
}

// MARK: - Home Display Logic
extension HomeViewController: HomeDisplayLogic {
    func displayNewReleases(viewModels: [NewReleases.Releases.ViewModel]) {
        DispatchQueue.main.async {
            self.sections.append(.newReleases(viewModels: viewModels))
            self.collectionView.reloadData()
        }
    }
    
    func displayNewReleasesError(viewModel: NewReleases.Releases.ViewModelError) {
        DispatchQueue.main.async {
            let label = UILabel(frame: .zero)
            label.text = "Indisponibiidade no sistema, erro na busca das new releases. Tente novamente :/"
            label.sizeToFit()
            label.textColor = .secondaryLabel
            self.view.addSubview(label)
            label.center = self.view.center
        }
    }
}

