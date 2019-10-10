//
//  ContentBlockerRequestHandler.swift
//  blocker
//
//  Created by Wangchou Lu on R 1/10/09.
//  Copyright © Reiwa 1 com.wcl. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias BlockerList = [[String: [String: String]]]

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }

    private static func generateBlacklistJSON() -> BlockerList {
      var blacklist: BlockerList = []
      for tracker in trackerList {
        blacklist.append([
          "action": ["type": "block"],
          "trigger": ["url-filter": String(format: "https?://(www.)?%@.*", tracker)]
        ])
      }

      return blacklist
    }
}
