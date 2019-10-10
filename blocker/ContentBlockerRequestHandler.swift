//
//  ContentBlockerRequestHandler.swift
//  blocker
//
//  Created by Wangchou Lu on R 1/10/09.
//  Copyright © Reiwa 1 com.wcl. All rights reserved.
//

import MobileCoreServices
import UIKit

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.idv.wcl.chin")

        guard let jsonURL = documentFolder?.appendingPathComponent("blacklist.json") else {
            print("Content Block Extension: cannnot load blacklist.json")
            return
        }

        let attachment = NSItemProvider(contentsOf: jsonURL)!

        let item = NSExtensionItem()

        item.attachments = [attachment]

        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
