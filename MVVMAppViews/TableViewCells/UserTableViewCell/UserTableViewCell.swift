//
//  UserTableViewCell.swift
//  MVVMApp
//
//  Created by George Kaimakas on 11/05/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import MVVMAppViewModels
import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!

	public var viewModel: UserViewModelProvider! {
		didSet {
			usernameLabel.reactive.text <~ viewModel
				.user
				.producer
				.take(during: reactive.lifetime)
				.take(until: reactive.prepareForReuse)
				.flatMap(.latest) { $0.username }
		}
	}
}
