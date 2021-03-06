//
//  OwatchParentsTopViewController.swift
//  OwatchParents
//
//  Created by 木村旭 on 2015/11/21.
//  Copyright © 2015年 akirambow. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class OwatchParentsTopViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toNextButton: UIButton!
    @IBOutlet weak var configButton: UIButton!
    
    var requestItem:String?
    var multipeerInfo : OwatchMultipeerInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if multipeerInfo == nil {
            createMultipeerInfo()
        }
        titleLabel.text = "おいしいウォッチ"
        messageLabel.text = "おこさまからのリクエストを待っています"
        toNextButton.setTitle("次へ", forState: UIControlState.Normal)
        toNextButton.enabled = false
        configButton.setTitle("通信設定", forState: UIControlState.Normal)
        configButton.enabled = false
        requestItem = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        clearMultipeerInfo()
        multipeerInfo = nil
        self.view = nil
    }
    
    @IBAction func onConfigButtonTapped(sender: AnyObject) {
        multipeerInfo!.browseViewController = MCBrowserViewController(serviceType: "owatch", session: multipeerInfo!.session)
        multipeerInfo!.browseViewController.delegate = self
        multipeerInfo!.browseViewController.minimumNumberOfPeers = 1
        multipeerInfo!.browseViewController.maximumNumberOfPeers = 1
        self.presentViewController(multipeerInfo!.browseViewController, animated: true, completion: nil)
    }
    
    @IBAction func onNextButtonTapped(sender: AnyObject) {
        moveToNextPage()
    }
    
    private func createMultipeerInfo(){
        multipeerInfo = OwatchMultipeerInfo()
        multipeerInfo!.myPeerId = MCPeerID(displayName: UIDevice.currentDevice().name)
        multipeerInfo!.session  = MCSession(peer: multipeerInfo!.myPeerId)
        multipeerInfo!.session.delegate = self
//        multipeerInfo!.assistant = MCAdvertiserAssistant(serviceType: "TEST_SERVICE", discoveryInfo: nil, session:multipeerInfo!.session)
        multipeerInfo!.state = MCSessionState.NotConnected
    }
    
    private func clearMultipeerInfo(){
        multipeerInfo?.myPeerId = nil
        multipeerInfo?.session.delegate  = nil
        multipeerInfo?.session = nil
        multipeerInfo?.state = MCSessionState.NotConnected
    }
    
    private func moveToNextPage(){
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("RequestedPage") as! OwatchParentsRequestedViewController
        nextView.modalTransitionStyle = .CoverVertical
        multipeerInfo!.session.delegate = nil
        nextView.registerMultipeerInfo(multipeerInfo)
        presentViewController(nextView, animated: true, completion: nil )
    }
    
    func registerMultipeerInfo( mcinfo:OwatchMultipeerInfo! )
    {
        multipeerInfo = mcinfo
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        multipeerInfo?.recentReviecedData = data
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    }
    
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        multipeerInfo?.browseViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        multipeerInfo?.browseViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
