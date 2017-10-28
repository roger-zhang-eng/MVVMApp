//
//  NSAttributedString+Reactive.swift
//  MVVMAppViews
//
//  Created by George Kaimakas on 28/10/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

public extension Signal where Value == String {
	func boldAttributedString(color: UIColor, size: CGFloat) -> Signal<NSAttributedString, Error> {
		return self.map { value -> NSAttributedString in
			return NSAttributedString(string: value, attributes: [
				NSAttributedStringKey.foregroundColor : color,
				NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: size)
				])
		}
	}

	func attributedString(color: UIColor, size: CGFloat) -> Signal<NSAttributedString, Error> {
		return self.map { value -> NSAttributedString in
			return NSAttributedString(string: value, attributes: [
				NSAttributedStringKey.foregroundColor : color,
				NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
				])
		}
	}
}

public extension SignalProducer where Value == String {
	func boldAttributedString(color: UIColor, size: CGFloat) -> SignalProducer<NSAttributedString, Error> {
		return self.lift { $0.boldAttributedString(color: color, size: size) }
	}

	func attributedString(color: UIColor, size: CGFloat) -> SignalProducer<NSAttributedString, Error> {
		return self.lift { $0.attributedString(color: color, size: size) }
	}
}
