//
//  AppDelegate.swift
//  macApp
//
//  Created by Wangchou Lu on R 1/10/10.
//  Copyright © Reiwa 1 com.wcl. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do {
            var blacklist: [[String: [String: String]]] = []
            let fileNames = ["content-farms",
                             "fake-news",
                             "nearly-content-farms",
                             "scam-sites",
                             "sns-content-farms"]

//                        blacklist.append([
//                            "action": ["type": "block"],
//                            "trigger": ["url-filter": "www.google.com"],
//                        ])

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
                let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "ETE87474CU.") else {
                    print("Error: something wrong on generate blacklist.json")
                    return
            }
            try jsonData.write(to: documentFolder.appendingPathComponent("blacklist.json"))
        } catch {
            print(error.localizedDescription)
        }

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

