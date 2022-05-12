//
//  ProfileViewController.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var tableViewHeader: UIView = {
        var header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var userImageView: UIImageView = {
        let imageSize: CGFloat = tableViewHeader.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        imageView.center = tableViewHeader.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        return imageView
    }()
    
    // MARK: - Properties
    private var models = [String]()

    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private Functions
    private func fetchProfile() {
        APICaller.shared.getAPI(request: GenericGetModel.Model.Request<UserProfile>.init(endpoint: "/me", completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.updateUI(with: model)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.failedToGetProfile()
                }
                print("ERROR: \(error.localizedDescription)")
            }
        }))
    }
    
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        // configure tableview models
        models.append("Full Name: \(model.display_name)")
        models.append("Email: \(model.email)")
        models.append("ID: \(model.id)")
        models.append("Plan: \(model.product)")
        
        if let urlString = model.images.first?.url, let url = URL(string: urlString) {
            userImageView.sd_setImage(with: url, completed: nil)
        } else {
            tableView.tableHeaderView = nil
        }
        
        tableView.reloadData()
    }
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
}

// MARK: - ViewCode
extension ProfileViewController: iOSViewCode {
    func setupHierarchy() {
        view.addSubview(tableView)
        tableViewHeader.addSubview(userImageView)
    }
    
    func setupConstraints() {
    }
    
    func additionalSetup() {
        title = "Profile"
        view.backgroundColor = .systemBackground
        tableView.tableHeaderView = tableViewHeader
    }
}

// MARK: - TableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}
