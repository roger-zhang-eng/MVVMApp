//
//  PostNode.swift
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

public class PostNode: ASDisplayNode {
	static let avatarColors = [
		UIColor.flatRed,
		UIColor.flatPlum,
		UIColor.flatOrange,
		UIColor.flatPurple,
		UIColor.flatYellow,
		UIColor.flatMint,
		UIColor.flatTeal,
		UIColor.flatSkyBlue
	]

	private let titleNode = ASTextNode()
	private let usernameNode = ASTextNode()
	private let bodyNode = ASTextNode()
	private let avatarNode: ASImageNode = {
		let node = ASImageNode()
		node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		node.contentMode = UIViewContentMode.scaleAspectFit
		return node
	}()

	public init(viewModel: PostViewModel) {
		super.init()

		addSubnode(titleNode)
		addSubnode(usernameNode)
		addSubnode(bodyNode)
		addSubnode(avatarNode)

		titleNode.reactive.attributedText <~ viewModel
			.title
			.producer
			.map { $0 ?? "[Title Not Availabe]" }
			.boldAttributedString(color: UIColor.darkGray, size: 20)
			.take(during: reactive.lifetime)

		avatarNode.reactive.image <~ viewModel
			.user
			.producer
			.flatMap(.latest) { user -> SignalProducer<String?, NoError> in
				return user.username.producer
			}
			.map { $0 ?? "[Username Not Available]" }
			.map { abs($0.hashValue) % PostNode.avatarColors.count }
			.map { PostNode.avatarColors[$0] }
			.map { UIImage.image(with: $0, size: CGSize(width: 96, height: 96)) }

		usernameNode.reactive.attributedText <~ viewModel
			.user
			.producer
			.flatMap(.latest) { user -> SignalProducer<String?, NoError> in
				return user.username.producer
			}
			.map { $0 ?? "[Username Not Available]" }
			.attributedString(color: UIColor.darkGray, size: 16)
			.take(during: reactive.lifetime)

		bodyNode.reactive.attributedText <~ viewModel
			.body
			.producer
			.map { $0 ?? "[Body Not Availabe]" }
			.attributedString(color: UIColor.flatGrayDark, size: 12)

		self.backgroundColor = .white
		self.automaticallyManagesSubnodes = true
	}

	override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		return ASStackLayoutSpec
			.vertical()
			.withSpacing(8)
			.withChildren([
				titleNode,
				ASStackLayoutSpec
					.horizontal()
					.withAlignItems(ASStackLayoutAlignItems.center)
					.withSpacing(8)
					.withChildren([
						avatarNode
							.withPreferredSize(CGSize(width: 24, height: 24)),
						usernameNode
						]),
				bodyNode
				])
			.withInset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
	}
}
