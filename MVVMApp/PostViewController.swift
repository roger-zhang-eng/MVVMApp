//
//  PostViewModel.swift
//  MVVMApp
//
//  Created by George Kaimakas on 11/05/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppModels
import MVVMAppViewModels
import MVVMAppViews
import ReactiveSwift
import ReactiveCocoa
import Result
import UIKit

class PostViewController: UIViewController {
    public static let RowUser = 1
    public static let RowTitle = 0
    public static let RowBody = 2
    
    var viewModel: PostViewModel!
    @IBOutlet weak var tableView: UITableView!
	var loadingIndicator: UIActivityIndicatorView!
	var loadingBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(cell: EmailTableViewCell.self)
		tableView.register(cell: UserTableViewCell.self)
        tableView.register(cell: TitleTableViewCell.self)
        tableView.register(cell: BodyTableViewCell.self)
        tableView.register(cell: PagingTableViewCell.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 24
        tableView.dataSource = self
        tableView.delegate = self

		loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		loadingIndicator.color = UIColor(hexString: "FFC107")
		loadingIndicator.hidesWhenStopped = true
		loadingBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
		self.navigationItem.setRightBarButton(loadingBarButtonItem, animated: true)

		loadingIndicator.reactive.isAnimating <~ viewModel
			.fetchComments
			.isExecuting
		
        tableView.reactive.reloadData <~ viewModel
            .comments
            .map { _ in () }

		viewModel
			.fetchComments
			.isEnabled
			.producer
			.promoteError(ActionError<ProviderError>.self)
			.filter({ $0 })
			.flatMap(.latest) { _ in return self.viewModel.fetchComments.apply() }
			.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension PostViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + viewModel.comments.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.item == PostViewController.RowTitle {
                let cell = tableView.deque(cell: TitleTableViewCell.self)
                
                cell.viewModel = viewModel
                
                return cell
            }
            
            if indexPath.item == PostViewController.RowUser {
                let cell = tableView.deque(cell: UserTableViewCell.self, for: indexPath)
                
                cell.viewModel = viewModel
                
                return cell
                
            }
            
            if indexPath.item == PostViewController.RowBody {
                let cell = tableView.deque(cell: BodyTableViewCell.self)
                
                cell.viewModel = viewModel
                
                return cell
                
            }
        }
        
        let commentViewModel = viewModel.comments.value[indexPath.section-1]
        
        if indexPath.row == 0 {
            
            let cell = tableView.deque(cell: EmailTableViewCell.self, for: indexPath)
            
            cell.viewModel = commentViewModel
            
            return cell
        }
        
        if indexPath.row == 1 {
            
            let cell = tableView.deque(cell: BodyTableViewCell.self)
            
            cell.viewModel = commentViewModel
            
            return cell
            
        }
        
        return UITableViewCell()
    }
}

extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comments"
        }
        
        return nil
    }
}
