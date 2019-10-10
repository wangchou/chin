//
//  ContentBlockerRequestHandler.swift
//  macBlocker
//
//  Created by Wangchou Lu on R 1/10/10.
//  Copyright © Reiwa 1 com.wcl. All rights reserved.
//

import Foundation

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "ETE87474CU.")

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
