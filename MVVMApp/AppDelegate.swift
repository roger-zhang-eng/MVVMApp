//
//  AppDelegate.swift
//  MVVMApp
//
//  Created by George Kaimakas on 28/03/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

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
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

