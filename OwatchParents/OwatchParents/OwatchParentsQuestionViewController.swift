//
//  OwatchParentsQuestionViewController.swift
//  OwatchParents
//
//  Created by 木村旭 on 2015/11/21.
//  Copyright © 2015年 akirambow. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class OwatchParentsQuestionViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var selectionLabel1: UILabel!
    @IBOutlet weak var selectionLabel3: UILabel!
    @IBOutlet weak var selectionLabel2: UILabel!
    
    @IBOutlet weak var selectSecondButton: UIButton!

    @IBOutlet weak var toNextButton: UIButton!
    @IBOutlet weak var configButton: UIButton!
    
    var multipeerInfo : OwatchMultipeerInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if multipeerInfo == nil {
            createMultipeerInfo()
        }
        titleLabel.text = "おいしいウォッチ"
        messageLabel.text = "食後のの質問を送ります。"
//        configButton.setTitle("通信設定", forState: UIControlState.Normal)
        
        selectionLabel1.text = "1. おいしかった！"
        selectionLabel2.text = "2. ごちそうさま！"
        selectionLabel3.text = "3. なし"
        
        selectSecondButton.setTitle("質問をおいしいウォッチに送る", forState: UIControlState.Normal)
        
        if( multipeerInfo == nil ){
            selectSecondButton.enabled = false
        }
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
    
    @IBAction func onSelectFirstButtonTapped(sender: AnyObject) {
        let sendDataArray:NSArray = ["ごちそうさま！", "おいしかった！", "なし", "__kansou__"]
        let sendData = NSKeyedArchiver.archivedDataWithRootObject(sendDataArray)
        sendDataToPeer(sendData)
        // moveToNextPage()
    }
    
    @IBAction func onNextButtonTapped(sender: AnyObject) {
        moveToNextPage()
    }
    
    private func sendDataToPeer(aData: NSData){
        let peerIDs = multipeerInfo?.session.connectedPeers
        print( peerIDs?.count )
        do{
            try multipeerInfo?.session.sendData(aData, toPeers: peerIDs!, withMode: MCSessionSendDataMode.Reliable)
            
        }catch let error {
            print(error)
        }
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
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackPage") as! OwatchParentsRequestedViewController
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
        let receivedString = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSString
        multipeerInfo?.recentReceivedString = receivedString?.description
        moveToNextPage()
        
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
        selectSecondButton.enabled = true
        let peerIDs = multipeerInfo?.session.connectedPeers
        print( peerIDs?.count )
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        multipeerInfo?.browseViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
