//
//  ImageViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 1/5/18.
//  Copyright © 2018 Muhammad Luqman. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ImageViewController: UIViewController, GADBannerViewDelegate , GADInterstitialDelegate  {

    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    
    
    var imageURL:URL? = nil
    
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)

        
        
        super.viewDidLoad()
        
        let tempImage    = UIImage(contentsOfFile: (imageURL?.path)!)
        self.image.image = tempImage
    }
    
    @IBAction func btnDeleted(_ sender: Any) {
        
        let flag = CoreDataClass.DeleteImageFileRecordFormDataBase(entityName: "ImageList", imagePath: imageURL!)
        if(flag){
            
            print("Deleted")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    func bannerViewSetting() {
        
        bannerView.adUnitID = Banner_ID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    @objc func loadBanner(){
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        self.bannerView.isHidden = false
        self.bannerView.frame.origin.y = (self.view.frame.size.height-self.bannerView.frame.size.height)
        print("adViewDidReceiveAd")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        self.bannerView.isHidden = true
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func createInterstitial() {
        
        interstitial = GADInterstitial(adUnitID: Intertestial_ID)
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        interstitial.delegate = self
        interstitial.load(request)
    }
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        print("interstitialDidReceiveAd")
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
}
