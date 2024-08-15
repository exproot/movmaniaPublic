//
//  HomeViewController.swift
//  VBMovmania
//
//  Created by Suheda on 12.07.2024.
//

import UIKit
import FirebaseAuth

protocol HomeViewControllerProtocol: AnyObject {
    func prepareNavBar()
    func prepareTableView()
    func reloadTable()
    func presentLoadingView()
    func cancelLoadingView()
}

final class HomeViewController: UIViewController {
    private lazy var viewModel = HomeViewModel()
    private let homeTableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func goToDetails(title: String, description: String, videoKey: String, mediaType: String, mediaID: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = MediaDetailsViewController()
            vc.configure(title: title, desc: description, videoID: videoKey, mediaType: mediaType, mediaID: mediaID)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Selectors
    @objc private func handleTapProfileIcon() {
        navigationController?.present(SettingsViewController(), animated: true)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeTableView)
        homeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: view.topAnchor),
            homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.reuseID, for: indexPath) as? HomeTableCell else { return UITableViewCell()}
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingWeekly.rawValue:
            cell.viewModel.setTableCell(with: viewModel.arrTrendingWeekly)
        case Sections.PopularMovies.rawValue:
            cell.viewModel.setTableCell(with: viewModel.arrPopularMovies)
        case Sections.PopularSeries.rawValue:
            cell.viewModel.setTableCell(with: viewModel.arrPopularSeries)
        case Sections.Upcoming.rawValue:
            cell.viewModel.setTableCell(with: viewModel.arrUpcoming)
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let tableHeader = view as? UITableViewHeaderFooterView else { return }
        
        var contentConfiguration = tableHeader.defaultContentConfiguration()
        contentConfiguration.text = viewModel.sectionTitles[section]
        contentConfiguration.textProperties.color = .label
        contentConfiguration.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        tableHeader.contentConfiguration = contentConfiguration
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension HomeViewController: HomeTableCellDelegate {
    func tableCellCollectionViewDidTap(cell: HomeTableCell, title: String, description: String, videoID: String, mediaType: String, mediaID: String) {
        goToDetails(title: title, description: description, videoKey: videoID, mediaType: mediaType, mediaID: mediaID)
    }
}

extension HomeViewController: HeaderTitleViewDelegate {
    func headerTitleViewDidTap(view: UIView, title: String, description: String, videoID: String, mediaType: String, mediaID: String) {
        goToDetails(title: title, description: description, videoKey: videoID, mediaType: mediaType, mediaID: mediaID)
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func cancelLoadingView() {
        dismissLoadingView()
    }
    
    func presentLoadingView() {
        showLoadingView()
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
    
    func prepareNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(handleTapProfileIcon))
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    func prepareTableView() {
        homeTableView.register(HomeTableCell.self, forCellReuseIdentifier: HomeTableCell.reuseID)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        let headerView = HeaderTitleView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 520))
        homeTableView.tableHeaderView = headerView
        headerView.delegate = self
    }
}
