//
//  ShareLiveLocationVC.swift
//  LiveLocationSharingStarter
//
//  Created by Ravi Jain on 8/23/17.
//  Copyright © 2017 Ravi Jain. All rights reserved.
//

import UIKit
import HyperTrack
class ShareLiveLocationVC: UIViewController {
    
    var hyperTrackMap : HTMap? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Share Live Location"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var hypertrackView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {

        //  Start a Live Location Trip : Step 1. embed hypertrack's map in your view
       
        // get an instance of hypertrack's map view (it's a location picker + map view)
        hyperTrackMap = HyperTrack.map()
        // enable live location sharing
        hyperTrackMap?.enableLiveLocationSharingView = true
        hyperTrackMap?.showConfirmLocationButton = true
        // gives callbacks when a user interacts with the map, like when he selects a location or press a refocus button
        hyperTrackMap?.setHTViewInteractionDelegate(interactionDelegate: self)
        if (self.hypertrackView != nil) {
            hyperTrackMap?.embedIn(self.hypertrackView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if (self.hyperTrackMap == nil){
                self.showAlert(title: "Step 5 not completed", message: "Please embed the view to Start Live Location View") {(action) in
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
        
        
    }
    
    
    fileprivate func showAlert(title: String?, message: String?, buttonTitle : String = "OK",handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok : UIAlertAction = UIAlertAction.init(title: buttonTitle, style: .cancel) { (action) in
            if (handler != nil){
                handler!(action)
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}



extension ShareLiveLocationVC:HTViewInteractionDelegate {
    
    
    func didSelectLocation(place : HyperTrackPlace?){
    
        //  Start a Live Location Trip : Step 2. This is the callback which gets called when the user select a location. Create an action and assign it.
        
       
    }
    

    func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapStopLiveLocationSharing(actionId : String){
        //This is the callback when user want to stop the trip. Complete the action

        HyperTrack.completeAction(actionId)
    }
    
    func didTapShareLiveLocationLink(action : HyperTrackAction){
        if let lookupId = action.lookupId {
            
          //  Start a Live Location Trip : Step 3 : This is the callback when the user wants to share his location to his friends. Create a activity view controller to share it through messenger apps
            
            let textToShare : Array = [lookupId]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { activityType, complete, returnedItems, error in
            }
            self.present(activityViewController, animated: false, completion: nil)
  
        }
    }
    
}

