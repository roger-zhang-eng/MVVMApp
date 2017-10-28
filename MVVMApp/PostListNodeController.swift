//
//  PostListNodeViewController.swift
//  MVVMApp
//
//  Created by George Kaimakas on 28/10/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//
import AsyncDisplayKit
import ASDKFluentExtensions
import ChameleonFramework
import Foundation
import MVVMAppModels
import MVVMAppViewModels
import MVVMAppViews
import ReactiveCocoa
import ReactiveSwift
import Result
import Swinject

class PostListNodeController: ASViewController<ASTableNode> {

	let viewModel: PostListViewModel!

	var loadingIndicator: UIActivityIndicatorView!
	var loadingBarButtonItem: UIBarButtonItem!
	var context: ASBatchContext!

	init() {
		viewModel = UIApplication.inject(PostListViewModel.self)
		super.init(node: ASTableNode())
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Posts"
		loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		loadingIndicator.color = UIColor.white
		loadingIndicator.hidesWhenStopped = true
		loadingBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
		self.navigationItem.setRightBarButton(loadingBarButtonItem, animated: true)

		loadingIndicator.reactive.isAnimating <~ viewModel.fetchPosts
			.isExecuting

		node.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		node.dataSource = self
		node.delegate = self
		node.isUserInteractionEnabled = true
		node.allowsSelection = false
		node.clipsToBounds = true
		node.view.separatorStyle = .none
		node.leadingScreensForBatching = 1

		self.reactive.updateList <~ viewModel
			.fetchPosts
			.values

		self.view.backgroundColor = UIColor.flatWhite
	}

	func insertRows(newCount: Int) {
		let indexRange = (viewModel.posts.value.count - newCount..<viewModel.posts.value.count)
		let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
		node.insertRows(at: indexPaths, with: .none)
	}
}

extension PostListNodeController: ASTableDataSource {
	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		return viewModel.posts.value.count
	}

	func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
		let post = viewModel.posts.value[indexPath.row]
		return {
			return PostCellNode(viewModel: post)
		}
	}
}

extension PostListNodeController: ASTableDelegate {
	func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
		return viewModel.fetchPosts.isExecuting.negate().value || viewModel.posts.value.count < 100
	}

	func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
		context.reactive.completBatchFetching <~ viewModel.fetchPosts
			.isExecuting
			.producer
			.filter { $0 == false }
			.negate()

			viewModel
				.fetchPosts
				.apply()
				.start()
	}
}

extension Reactive where Base == PostListNodeController {
	var updateList: BindingTarget<[PostViewModel]> {
		return makeBindingTarget { $0.insertRows(newCount: $1.count) }
	}
}

extension Reactive where Base == ASBatchContext {
	var completBatchFetching: BindingTarget<Bool> {
		return makeBindingTarget { $0.completeBatchFetching($1) }
	}
}
