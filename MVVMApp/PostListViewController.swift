//
//  PostListViewController.swift
//  MVVMApp
//
//  Created by George Kaimakas on 11/05/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import ChameleonFramework
import Foundation
import MVVMAppModels
import MVVMAppViewModels
import MVVMAppViews
import ReactiveCocoa
import ReactiveSwift
import Result
import Swinject
import UIKit

class PostListViewController: UIViewController {
    public static let RowUser = 1
    public static let RowTitle = 0
    public static let RowBody = 2
    
    var viewModel: PostListViewModel!
    @IBOutlet weak var tableView: UITableView!

	var loadingIndicator: UIActivityIndicatorView!
	var loadingBarButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = "Posts"
		loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		loadingIndicator.color = UIColor(hexString: "FFC107")
		loadingIndicator.hidesWhenStopped = true
		loadingBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
		self.navigationItem.setRightBarButton(loadingBarButtonItem, animated: true)
        
        viewModel = inject(PostListViewModel.self)
        
        tableView.register(cell: UserTableViewCell.self)
        tableView.register(cell: TitleTableViewCell.self)
        tableView.register(cell: BodyTableViewCell.self)
        tableView.register(cell: PagingTableViewCell.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 24
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reactive.reloadData <~ viewModel
            .posts
            .producer
            .map({ _ in () })

		loadingIndicator.reactive.isAnimating <~ viewModel.fetchPosts
			.isExecuting
        
        if viewModel.fetchPosts.isEnabled.value {
            viewModel.fetchPosts
                .apply()
                .start()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController",
            let viewController = segue.destination as? PostViewController,
            let viewModel = sender as? PostViewModel {
            
            viewController.viewModel = viewModel
        }
    }
}

extension PostListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.viewModel.posts.value[indexPath.section]
        
        
        if indexPath.row == PostListViewController.RowUser {
            let cell = tableView.deque(cell: UserTableViewCell.self, for: indexPath)
            
            cell.viewModel = viewModel
            
            return cell
        }
        
        if indexPath.row == PostListViewController.RowTitle {
            let cell = tableView.deque(cell: TitleTableViewCell.self)
            
            cell.viewModel = viewModel
            
            return cell
        }
        
        if indexPath.row == PostListViewController.RowBody {
            let cell = tableView.deque(cell: BodyTableViewCell.self)
            
            cell.viewModel = viewModel
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = viewModel.posts.value[indexPath.section]
        
        performSegue(withIdentifier: "PostViewController", sender: vm)
    }
}

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == viewModel.posts.value.count-1 &&
            indexPath.row == PostListViewController.RowBody &&
            viewModel.fetchPosts.isExecuting.value == false {
            
            viewModel.fetchPosts
                .apply()
                .start()
        }
    }
    
}
