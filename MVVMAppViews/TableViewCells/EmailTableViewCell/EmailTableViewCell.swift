//
//  EmailTableViewCell.swift
//  MVVMAppViews
//
//  Created by George Kaimakas on 02/10/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import MVVMAppViewModels
import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class EmailTableViewCell: UITableViewCell {
	@IBOutlet weak var thumbnailImageView: UIImageView!

	@IBOutlet weak var emailLabel: UILabel!

	public var viewModel: EmailViewModelProvider! {
		didSet {
			emailLabel.reactive.text <~ viewModel
				.email
				.producer
				.take(during: reactive.lifetime)
				.take(until: reactive.prepareForReuse)
		}
	}
}
