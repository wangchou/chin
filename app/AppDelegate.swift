//
//  AppDelegate.swift
//  chin
//
//  Created by Wangchou Lu on R 1/10/09.
//  Copyright © Reiwa 1 com.wcl. All rights reserved.
//

import UIKit

// reference from
// https://medium.com/@nderkach/how-to-build-a-simple-tracker-blocker-for-ios-cc6c52a2d2d1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            var blacklist: [[String: [String: String]]] = []
            let fileNames = ["content-farms",
                             "fake-news",
                             "nearly-content-farms",
                             "scam-sites",
                             "sns-content-farms"]

            for fileName in fileNames {
                guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
                    print("\(fileName) is not Found")
                    continue
                }

                try String(contentsOfFile: path, encoding: .utf8)
                    .split(separator: "\n")
                    // the regex start with "/" will cause content blocker not working...
                    .filter { $0 != "" && !$0.hasPrefix("/") }
                    .map {
                        let urlWithoutComment = String($0.split(separator: " ")[0])
                        return String(format: "https?://(www.)?%@.*", urlWithoutComment)
                    }
                    .forEach {
                        blacklist.append([
                            "action": ["type": "block"],
                            "trigger": ["url-filter": $0],
                        ])
                    }
            }

            guard let jsonData = try? JSONSerialization.data(withJSONObject: blacklist, options: .prettyPrinted),
                let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.idv.wcl.chin") else {
                print("Error: something wrong on generate blacklist.json")
                return true
            }

            try jsonData.write(to: documentFolder.appendingPathComponent("blacklist.json"))
        } catch {
            print(error.localizedDescription)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
