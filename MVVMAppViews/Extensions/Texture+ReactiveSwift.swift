//
//  Texture+ReactiveSwift.swift
//  MVVMAppViews
//
//  Created by George Kaimakas on 28/10/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import AsyncDisplayKit
import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public extension Reactive where Base: ASTextNode {
	var attributedText: BindingTarget<NSAttributedString> {
		return makeBindingTarget { $0.attributedText = $1 }
	}
}

public extension Reactive where Base: ASImageNode {
	var image: BindingTarget<UIImage> {
		return makeBindingTarget { $0.image = $1 }
	}
}
