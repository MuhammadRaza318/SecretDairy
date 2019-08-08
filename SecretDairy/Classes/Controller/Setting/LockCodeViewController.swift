//
//  LockCodeViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/28/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LockCodeViewController: UIViewController, GADBannerViewDelegate , GADInterstitialDelegate  {
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    
    
    @IBOutlet var labelForLockCode: UILabel!
    @IBOutlet var outletSwitch: UISwitch!
    @IBOutlet var viewForChangeCode: UIView!
    @IBOutlet var viewForForgotCode: UIView!
    
    let defaults = UserDefaults.standard
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    struct StaticSelectView {
        
        static var selectViewName : String? = nil
    }
    
    
   
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)

        
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let myString = defaults.string(forKey: "SavedLockCode")
        let myStringOnOff = defaults.string(forKey: "SavedLockCodeOnOff")
        
        if(myString == nil){
            
            self.labelForLockCode.text = "Set Lock code"
            self.viewForChangeCode.isHidden = true
            self.outletSwitch.setOn(false, animated: false)
            self.viewForForgotCode.isHidden = true
            
        }else{
            
            self.viewForChangeCode.isHidden = false
            self.viewForForgotCode.isHidden = false
            
            if(myStringOnOff == "On"){
                self.labelForLockCode.text = "Lock Code On"
                self.outletSwitch.setOn(true, animated: false)
                
            }else if(myStringOnOff == "Off") {
                self.labelForLockCode.text = "Lock Code Off"
                self.outletSwitch.setOn(false, animated: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionSwitchObOff(_ sender: UISwitch) {
        
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LockCodeSettingViewController") as! LockCodeSettingViewController
                self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnChangeCode(_ sender: Any) {
        
        StaticSelectView.selectViewName = "ChangeCode"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLockCodeViewController") as! ChangeLockCodeViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnForgotCode(_ sender: Any) {
      
        StaticSelectView.selectViewName = "Forgot"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLockCodeViewController") as! ChangeLockCodeViewController
        self.present(vc, animated: true, completion: nil)

    }
    
    
    func bannerViewSetting() {
        
        bannerView.adUnitID = Banner_ID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    @objc func loadBanner(){
        
        bannerView.load(GADRequest())
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
