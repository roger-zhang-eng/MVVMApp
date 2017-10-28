//
//  AppDelegate.swift
//  MVVMApp
//
//  Created by George Kaimakas on 28/03/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import AsyncDisplayKit
import ChameleonFramework
import MVVMAppModels
import MVVMAppViewModels
import ReactiveCocoa
import ReactiveSwift
import Result
import Swinject
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        container.register(DataContainer.self) { r in
                return DataContainer(name: "MVVMApp")
            }
            .inObjectScope(.container)
        
        container.register(PostLocalProvider.self) { r in
                return PostLocalRepository(container: r.resolve(DataContainer.self)!)
            }
            .inObjectScope(.container)
        
        container.register(PostRemoteProvider.self) { r in
                return PostRemoteRepository()
            }
            .inObjectScope(.container)
        
        container.register(PostProvider.self) { r in
                return PostRepository(localProvider: r.resolve(PostLocalProvider.self)!,
                                      remoteProvider: r.resolve(PostRemoteProvider.self)!)
            }
            .inObjectScope(.container)
        
        container.register(UserLocalProvider.self) { r in
                return UserLocalRepository(container: r.resolve(DataContainer.self)!)
            }
            .inObjectScope(.container)
        
        container.register(UserRemoteProvider.self) { r in
                return UserRemoteRepository()
            }
            .inObjectScope(.container)
        
        container.register(UserProvider.self) { r in
                return UserRepository(localProvider: r.resolve(UserLocalProvider.self)!,
                                      remoteProvider: r.resolve(UserRemoteProvider.self)!)
            }
            .inObjectScope(.container)
        
        container.register(CommentLocalProvider.self) { r in
                return CommentLocalRepository(container: r.resolve(DataContainer.self)!)
            }
            .inObjectScope(.container)
        
        container.register(CommentRemoteProvider.self) { r in
                return CommentRemoteRepository()
            }
            .inObjectScope(.container)
        
        container.register(CommentProvider.self) { r in
                return CommentRepository(localProvider: r.resolve(CommentLocalProvider.self)!,
                                         remoteProvider: r.resolve(CommentRemoteProvider.self)!)
            }
            .inObjectScope(.container)
        
        container.register(PostListViewModel.self) { r in
                return PostListViewModel(postProvider: r.resolve(PostProvider.self)!,
                                         userProvider: r.resolve(UserProvider.self)!,
                                         commentProvider: r.resolve(CommentProvider.self)!)
            }
            .inObjectScope(.container)


		UINavigationBar.appearance().tintColor = UIColor(hexString: "#FAFAFA")
		UINavigationBar.appearance().titleTextAttributes = [
			NSAttributedStringKey.foregroundColor : UIColor(hexString: "FAFAFA")!
		]
		UINavigationBar.appearance().barTintColor = UIColor.flatMintDark
		UINavigationBar.appearance().isTranslucent = false

		let asyncNavigationController = UINavigationController(rootViewController: PostListNodeController())

		window = UIWindow()
		window?.backgroundColor = .white
		window?.rootViewController = asyncNavigationController
		window?.makeKeyAndVisible()

		ASDisableLogging()
        
        return true
    }
}

