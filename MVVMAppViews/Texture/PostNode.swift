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
	static let avatarUrls = [
		"https://pbs.twimg.com/profile_images/2571612286/qzdvjpfbdnwzeo4rqziw_400x400.jpeg",
		"https://cdn3.whatculture.com/images/2013/10/mom-futurama.png",
		"https://upload.wikimedia.org/wikipedia/it/1/12/Amy_wong_-_futurama.png",
		"http://images2.fanpop.com/image/photos/9000000/Zoidberg-dr-zoidberg-9032706-1024-768.jpg",
		"https://1835441770.rsc.cdn77.org/splitsider.com/wp-content/uploads/sites/2/2016/08/zappbrannigan-640x359.jpg",
		"https://www.walldevil.com/wallpapers/a89/fry-philip-j.-fry-futurama.jpg",
		"https://upload.wikimedia.org/wikipedia/it/d/d4/Turanga_Leela.png",
		"https://i.stack.imgur.com/Itky1.jpg",
		"http://www.hookandneedles.com/wp-content/uploads/2008/11/nibbler1.jpg"
		].map { URL(string: $0)! }

	private let viewModel: PostViewModel

	private let titleNode = ASTextNode()
	private let usernameNode = ASTextNode()
	private let bodyNode = ASTextNode()
	private let avatarNode: ASNetworkImageNode = {
		let node = ASNetworkImageNode()
		node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		node.contentMode = UIViewContentMode.scaleAspectFill
		return node
	}()

	var seperatorNode: ASImageNode = {
		let node = ASImageNode()
		node.contentMode = UIViewContentMode.scaleAspectFit
		return node
	}()

	var commenters: [ASNetworkImageNode] = []

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

		avatarNode.reactive.url <~ viewModel
			.user
			.producer
			.flatMap(.latest) { user in
				return user.id.producer
			}
			.map { abs($0) % PostNode.avatarUrls.count }
			.map { PostNode.avatarUrls[$0] }

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
					.map { $0.id.value % PostNode.avatarUrls.count }
					.map { id -> ASNetworkImageNode in
						let node = ASNetworkImageNode()
						node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
						node.contentMode = UIViewContentMode.scaleAspectFill
						node.url = PostNode.avatarUrls[id]
						return node
					}
					.forEach({ image in
						self.commenters.append(image)
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
			.forEach { $0.withPreferredSize(CGSize(width: 24, height: 24)) }

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
						.withPreferredSize(CGSize(width: 48, height: 48)),
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
}
