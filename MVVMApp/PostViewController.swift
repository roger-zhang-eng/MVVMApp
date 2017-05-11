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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(cell: UserTableViewCell.self)
        tableView.register(cell: TitleTableViewCell.self)
        tableView.register(cell: BodyTableViewCell.self)
        tableView.register(cell: PagingTableViewCell.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 24
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reactive.reloadData <~ viewModel
            .comments
            .map { _ in () }
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
                
                cell.titleLabel.reactive.text <~ viewModel.title
                    .producer
                    .take(until: cell.reactive.prepareForReuse)
                
                return cell
            }
            
            if indexPath.item == PostViewController.RowUser {
                let cell = tableView.deque(cell: UserTableViewCell.self, for: indexPath)
                
                cell.usernameLabel.reactive.text <~ viewModel.user
                    .producer
                    .flatMap(.latest) { $0.username }
                    .take(until: cell.reactive.prepareForReuse)
                
                return cell
                
            }
            
            if indexPath.item == PostViewController.RowBody {
                let cell = tableView.deque(cell: BodyTableViewCell.self)
                
                cell.bodyLabel.reactive.text <~ viewModel.body
                    .producer
                    .take(until: cell.reactive.prepareForReuse)
                
                return cell
                
            }
        }
        
        let commentViewModel = viewModel.comments.value[indexPath.section-1]
        
        if indexPath.row == 0 {
            
            let cell = tableView.deque(cell: UserTableViewCell.self, for: indexPath)
            
            cell.usernameLabel.reactive.text <~ commentViewModel.email
                .producer
                .take(until: cell.reactive.prepareForReuse)
            
            return cell
        }
        
        if indexPath.row == 1 {
            
            let cell = tableView.deque(cell: BodyTableViewCell.self)
            
            cell.bodyLabel.reactive.text <~ commentViewModel.body
                .producer
                .take(until: cell.reactive.prepareForReuse)
            
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
