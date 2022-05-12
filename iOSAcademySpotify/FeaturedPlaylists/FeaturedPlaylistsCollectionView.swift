//
//  FeaturedPlaylistsCollectionView.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 12/05/22.
//

import UIKit

// MARK: - Featured Playlists Collection View
class FeaturedPlaylistsCollectionView: UIViewController {
    
    static let shared = FeaturedPlaylistsCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCollectionViewLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(200)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
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
        
        let section = NSCollectionLayoutSection(
            group: horizontalGroup
        )
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}

// MARK: - Featured Playlists Cell
class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
}
