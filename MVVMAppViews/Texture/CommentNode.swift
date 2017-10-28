//
//  CommentNode.swift
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

public class CommentNode: ASDisplayNode {
	class BubbleNode: ASDisplayNode {
		private let viewModel: CommentViewModel

		let usernameNode = ASTextNode()
		let bodyNode = ASTextNode()

		let seperatorNode: ASImageNode = {
			let node = ASImageNode()
			node.contentMode = UIViewContentMode.scaleAspectFit
			return node
		}()

		init(viewModel: CommentViewModel) {
			self.viewModel = viewModel

			super.init()

			self.addSubnode(usernameNode)
			self.addSubnode(seperatorNode)
			self.addSubnode(bodyNode)

			seperatorNode.image = UIImage.image(with: UIColor.flatWhite, size: CGSize(width: 1000, height: 1))
			
			self.backgroundColor = .white
			self.automaticallyManagesSubnodes = true

			usernameNode.reactive.attributedText <~ viewModel
				.name
				.producer
				.map { $0 ?? "[Username Not Available]" }
				.boldAttributedString(color: UIColor.darkGray, size: 12)
				.take(during: reactive.lifetime)

			bodyNode.reactive.attributedText <~ viewModel
				.body
				.producer
				.map { $0 ?? "[Body Not Availabe]" }
				.attributedString(color: UIColor.flatGrayDark, size: 12)
		}

		override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
			return ASStackLayoutSpec
				.vertical()
				.withSpacing(4)
				.withChildren([
					bodyNode,
					seperatorNode,
					usernameNode
					])
				.withInset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))

		}
	}

	private let avatarNode: ASImageNode = {
		let node = ASImageNode()
		node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		node.contentMode = UIViewContentMode.scaleAspectFit
		return node
	}()

	private let bubble: BubbleNode

	public init(viewModel: CommentViewModel) {
		self.bubble = BubbleNode(viewModel: viewModel)
		super.init()

		self.addSubnode(avatarNode)
		self.addSubnode(bubble)

		self.bubble.cornerRadius = 12
		self.cornerRoundingType = .precomposited

		self.backgroundColor = .clear

		avatarNode.reactive.image <~ viewModel
			.name
			.producer
			.map { $0 ?? "[Username Not Available]" }
			.map { abs($0.hashValue) % PostNode.avatarColors.count }
			.map { PostNode.avatarColors[$0] }
			.map { UIImage.image(with: $0, size: CGSize(width: 96, height: 96)) }
	}

	override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let layout = ASStackLayoutSpec
			.horizontal()
			.withSpacing(8)
			.withChildren([
				ASStackLayoutSpec
					.vertical()
					.withChildren([
						avatarNode
							.withPreferredSize(CGSize(width: 24, height: 24))])
					.withInset(UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)),
				bubble
					.withFlexShrink(1)
				])

		return layout
	}
}
