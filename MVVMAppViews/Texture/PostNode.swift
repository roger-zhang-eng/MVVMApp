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

	private let viewModel: PostViewModel

	private let titleNode = ASTextNode()
	private let usernameNode = ASTextNode()
	private let bodyNode = ASTextNode()
	private let avatarNode: ASImageNode = {
		let node = ASImageNode()
		node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		node.contentMode = UIViewContentMode.scaleAspectFit
		return node
	}()

	var seperatorNode: ASImageNode = {
		let node = ASImageNode()
		node.contentMode = UIViewContentMode.scaleAspectFit
		return node
	}()

	var commenters: [ASImageNode] = []

	public init(viewModel: PostViewModel) {
		self.viewModel = viewModel

		super.init()

		addSubnode(titleNode)
		addSubnode(usernameNode)
		addSubnode(bodyNode)
		addSubnode(avatarNode)
		addSubnode(seperatorNode)

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

		seperatorNode.image = UIImage.image(with: UIColor.flatWhite, size: CGSize(width: 1000, height: 1))

		usernameNode.reactive.attributedText <~ viewModel
			.user
			.producer
			.flatMap(.latest) { user -> SignalProducer<String?, NoError> in
				return user.username.producer
			}
			.map { $0 ?? "[Username Not Available]" }
			.boldAttributedString(color: UIColor.darkGray, size: 16)
			.take(during: reactive.lifetime)

		bodyNode.reactive.attributedText <~ viewModel
			.body
			.producer
			.map { $0 ?? "[Body Not Availabe]" }
			.attributedString(color: UIColor.flatGrayDark, size: 12)

		viewModel
			.fetchComments
			.values
			.observeValues { (comments) in
				comments
					.map { $0.name.value ?? "[Username Not Available]" }
					.forEach({ name in
						self.commenters.append(self.generateCommenterAvatar(for: name))
					})

				self.invalidateCalculatedLayout()
				self.setNeedsLayout()
				self.calculatedLayoutDidChange()
				self.layoutIfNeeded()

		}

		self.backgroundColor = .white
		self.automaticallyManagesSubnodes = true
	}

	override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		commenters
			.forEach { $0.withPreferredSize(CGSize(width: 12, height: 12)) }

		let commentersListLayout = ASStackLayoutSpec
			.horizontal()
			.withSpacing(4)
			.withAlignItems(.center)
			.withJustifyContent(.start)
			.withChildren(commenters)

		commentersListLayout.flexWrap = .wrap
		commentersListLayout.lineSpacing = 4

		let commentsLayout = ASStackLayoutSpec
			.vertical()
			.withSpacing(8)
			.withChildren([
				seperatorNode,
				commentersListLayout
					.withInset(UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
				])

		var innerLayouts: [ASLayoutElement] = [
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
		]

		if viewModel.comments.value.count != 0 {
			innerLayouts.append(commentsLayout)
		}

		return ASStackLayoutSpec
			.vertical()
			.withSpacing(8)
			.withChildren(innerLayouts)
			.withInset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
	}

	private func generateCommenterAvatar(for string: String) -> ASImageNode {
		let node = ASImageNode()
		node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)

		let index = abs(string.hashValue) % PostNode.avatarColors.count
		let image = UIImage.image(with: PostNode.avatarColors[index], size: CGSize(width: 96, height: 96))
		node.image = image

		node.contentMode = UIViewContentMode.scaleAspectFit
		return node

	}
}
