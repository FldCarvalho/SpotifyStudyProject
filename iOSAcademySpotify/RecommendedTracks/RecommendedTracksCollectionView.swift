//
//  RecommendedTracksCollectionView.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 12/05/22.
//

import UIKit

// MARK: - Recommended Tracks Collection View Layout
class RecommendedTracksCollectionView: UIViewController {
    
    static let shared = RecommendedTracksCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCollectionViewLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            ),
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - Recommended Tracks Cell
class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
}

