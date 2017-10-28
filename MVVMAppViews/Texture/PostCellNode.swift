//
//  PostNodeCell.swift
//  MVVMAppViews
//
//  Created by George Kaimakas on 28/10/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import AsyncDisplayKit
import ASDKFluentExtensions
import ChameleonFramework
import Foundation
import MVVMAppViewModels
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class PostCellNode: ASCellNode {

	let postNode: PostNode

	public init(viewModel: PostViewModel) {

		postNode = PostNode(viewModel: viewModel)

		super.init()

		self.postNode.cornerRadius = 12
		self.postNode.clipsToBounds = true
		self.backgroundColor = UIColor.flatWhite

		self.automaticallyManagesSubnodes = true
	}

	override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let container = ASStackLayoutSpec
			.vertical()
			.withInset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
			.withChildren([postNode])

		return container
	}
}
