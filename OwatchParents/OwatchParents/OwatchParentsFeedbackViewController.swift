//
//  OwatchParentsFeedbackViewController.swift
//  OwatchParents
//
//  Created by 木村旭 on 2015/11/21.
//  Copyright © 2015年 akirambow. All rights reserved.
//

import Foundation
import UIKit

class OwatchParentsFeedbackViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabelUpper: UILabel!
    @IBOutlet weak var messageLabelLower: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var toNextButton: UIButton!
    var multipeerInfo : OwatchMultipeerInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel.text = "おいしいウォッチ"
        messageLabelUpper.text = "おこさまから"
        messageLabelLower.text = "を受信しました。"
        if multipeerInfo != nil {
            feedbackLabel.text = multipeerInfo?.recentReceivedString
        } else {
            feedbackLabel.text = "おいしかった"
        }
        toNextButton.setTitle("OK", forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("ModeSelectPage") as! OwatchParentsModeSelectViewController
        nextView.modalTransitionStyle = .CoverVertical
        nextView.registerMultipeerInfo(multipeerInfo)
        presentViewController(nextView, animated: true, completion: nil )
    }
}
