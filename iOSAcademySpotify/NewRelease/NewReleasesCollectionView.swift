//
//  NewReleasesCollectionView.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 12/05/22.
//

import UIKit
import SDWebImage
import SnapKit

// MARK: - New Releases Collection View Layout
class NewReleasesCollectionView {
    
    static let shared = NewReleasesCollectionView()
    
    func setCollectionViewLayout() -> NSCollectionLayoutSection {
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
    }
}

// MARK: - New Releases Cell
class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var albumNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var numberOfTracksLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setContentView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleases.Releases.ViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    private func setContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.clipsToBounds = true
    }
    
    private func setConstraints() {
        albumCoverImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(220)
        }
        albumNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(albumCoverImageView)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.top.equalTo(albumNameLabel.snp.bottom).offset(5)
        }
        numberOfTracksLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.bottom.equalTo(albumCoverImageView).inset(10)
        }
    }
}

