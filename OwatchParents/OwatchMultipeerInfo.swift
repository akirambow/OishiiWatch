//
//  OwatchMultipeerInfo.swift
//  OwatchParents
//
//  Created by 木村旭 on 2015/11/21.
//  Copyright © 2015年 akirambow. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct OwatchMultipeerInfo {
    var state: MCSessionState!
    var myPeerId: MCPeerID!
    var session: MCSession!
    var assistant: MCAdvertiserAssistant!
    var browseViewController: MCBrowserViewController!
    var recentReviecedData:NSData!
    var recentReceivedString:String!
}