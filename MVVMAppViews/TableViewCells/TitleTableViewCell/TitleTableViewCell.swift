//
//  TitleTableViewCell.swift
//  MVVMApp
//
//  Created by George Kaimakas on 11/05/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppViewModels
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

	public var viewModel: TitleViewModelProvider! {
		didSet {
			titleLabel.reactive.text <~ viewModel
				.title
				.producer
				.take(during: reactive.lifetime)
				.take(until: reactive.prepareForReuse)
		}
	}


}
