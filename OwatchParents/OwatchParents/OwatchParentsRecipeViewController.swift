//
//  OwatchParentsRecipeViewController.swift
//  OwatchParents
//
//  Created by 木村旭 on 2015/11/21.
//  Copyright © 2015年 akirambow. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class OwatchParentsRecipeViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toNextButton: UIButton!
    
    var multipeerInfo : OwatchMultipeerInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if multipeerInfo != nil {
            multipeerInfo!.session.delegate = self
        }
        
        titleLabel.text = "おいしいウォッチ"
        recipeLabel.text = "お肉"
        messageLabel.text = "を使ったレシピの検索結果です"
        toNextButton.setTitle("次へ", forState:UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if multipeerInfo != nil {
            multipeerInfo!.session.delegate = nil
        }
        multipeerInfo = nil
        self.view = nil
    }

    @IBAction func toNextButtonTapped(sender: AnyObject) {
        moveToNextPage()
    }
    
    func registerMultipeerInfo( mcinfo:OwatchMultipeerInfo! )
    {
        multipeerInfo = mcinfo
    }

    private func moveToNextPage(){
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackPage") as! OwatchParentsFeedbackViewController
        nextView.modalTransitionStyle = .CoverVertical
        multipeerInfo?.session.delegate = nil
        nextView.registerMultipeerInfo(multipeerInfo)
        presentViewController(nextView, animated: true, completion: nil )
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
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
        
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        
    }


}
