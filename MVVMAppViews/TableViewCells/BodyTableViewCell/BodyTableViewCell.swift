//
//  BodyTableViewCell.swift
//  MVVMApp
//
//  Created by George Kaimakas on 11/05/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppViewModels
import ReactiveSwift
import ReactiveCocoa
import Result
import UIKit

public class BodyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel!

	public var viewModel: BodyViewModelProvider! {
		didSet {
			bodyLabel.reactive.text <~ viewModel
				.body
				.producer
				.take(until: reactive.prepareForReuse)
				.take(during: reactive.lifetime)
		}
	}
}
