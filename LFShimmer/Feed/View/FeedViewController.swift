//
//  FeedViewController.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/19/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    var refetchWithStatusButton: UIBarButtonItem!
    
    lazy var viewModel: FeedPostListViewModel = {
        return FeedPostListViewModel(state: .loading, tableViewUpdateDelegate: self)
    }()
    
    lazy var tableView: LFTableView = {
        let tv = LFTableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.register(FeedCell.self)
        return tv
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "LFState"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        viewModel.getFeedPost(withStatus: .data)
    }
    
    func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        navigationController?.navigationBar.barTintColor = UIColor(r: 59, g: 89, b: 152)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        

        refetchWithStatusButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshWithStatus))
        refetchWithStatusButton.isEnabled = false
        refetchWithStatusButton.tintColor = Color.gray20
        navigationItem.rightBarButtonItem = refetchWithStatusButton
        
    }
    
    func enableRefetchWithStatusButton(_ enable: Bool) {
        refetchWithStatusButton.isEnabled = enable
        refetchWithStatusButton.tintColor = enable ? .white : Color.gray20

    }
    
    
    @objc func refreshWithStatus() {
    
        let dataFetch = UIAlertAction(title: "Success 😀", style: .default) { (alert) in
            self.viewModel.getFeedPost(withStatus: .data)
        }
        
        let noContentFetch = UIAlertAction(title: "No Content 🤨", style: .default) { (alert) in
            self.viewModel.getFeedPost(withStatus: .noContent)
        }
        
        let noNetworkFetch = UIAlertAction(title: "No Network 🛰", style: .default) { (alert) in
            self.viewModel.getFeedPost(withStatus: .noNetwork)
        }
        
        let serverErrorFetch = UIAlertAction(title: "Server Error 🐞", style: .default) { (alert) in
            self.viewModel.getFeedPost(withStatus: .serverError)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let fetchOptionAlert = UIAlertController(title: "Select a refresh mode", message: nil, preferredStyle: .actionSheet)
        fetchOptionAlert.addAction(dataFetch)
        fetchOptionAlert.addAction(noContentFetch)
        fetchOptionAlert.addAction(noNetworkFetch)
        fetchOptionAlert.addAction(serverErrorFetch)
        fetchOptionAlert.addAction(cancel)
        self.present(fetchOptionAlert, animated: true, completion: nil)
    }

}

extension FeedViewController: UITableViewDelegate {}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .loading:
            return 3
        case .loaded:
            return viewModel.numberOfCells
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FeedCell.self, for: indexPath)
        switch viewModel.state {
        case .loaded:
            tableView.isUserInteractionEnabled = true
            let currentViewModel = viewModel.getCommentViewModel(at: indexPath)
            cell.configure(with: currentViewModel)
            cell.animate(false)
        case .loading:
            tableView.isUserInteractionEnabled = false
            cell.animate(true)
        default:
            let cell = UITableViewCell()
            return cell
        }
        return cell
    }
    
}

extension FeedViewController: UITableViewUpdateDelegate {
    func didViewModelStateChanged(state: FeedPostListViewModel.State) {
        
        if case .loading = state {
            enableRefetchWithStatusButton(false)
        } else {
            enableRefetchWithStatusButton(true)
        }
        
        switch state {
        case .error(let error):
            switch error {
            case .NetworkError:
                tableView.setState(
                    .error(title: "🛰", subtitle: "The Internet connection appears to be offline", buttonAction: {
                    print("retry")
                }))
            case .ServerError:
                tableView.setState(.error(title: "🐞", subtitle: "Seems there is a bug here. We are currently catching it. Please wait a little.", buttonAction: {
                    print("retry")
                }))
            case .NoContent:
                tableView.setState(.error(title: "🤨", subtitle: "It seems that there is nothing here for the moment", buttonAction: {
                    print("retry")
                }))
            }
        case .loading:
            tableView.setState(.loading)
        case .empty:
            tableView.setState(.error(title: "🤨", subtitle: "It seems that there is nothing here for the moment", buttonAction: {
                print("retry")
            }))
        case .loaded:
            tableView.setState(.success)
        }

        self.tableView.reloadData()
        
    }
    

}
