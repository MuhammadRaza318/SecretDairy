//
//  LockCodeSettingViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/28/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LockCodeSettingViewController: UIViewController, GADBannerViewDelegate , GADInterstitialDelegate  {
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    
    @IBOutlet var textFiledForsetCode: UITextField!
    @IBOutlet var labelForsetCode: UILabel!
    @IBOutlet var textFiledForResetCode: UITextField!
    @IBOutlet var labelForResetCode: UILabel!
    @IBOutlet var outletBtnSave: UIButton!
    
    @IBOutlet var textfiledForQuestion: UITextField!
    
    @IBOutlet var viewForQuestion: UIView!
    @IBOutlet var viewForSetLockCode: UIView!
    @IBOutlet var viewForConfirmSetLockCode: UIView!
    
    @IBOutlet var imageForBackground: UIImageView!
    
    var myStringOnOff = ""
    var savedLockCode = ""
    
    let defaults = UserDefaults.standard
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func tap() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)

        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.textFiledForsetCode.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let  tempStringOnOff = defaults.string(forKey: "SavedLockCodeOnOff")
        
        if(tempStringOnOff == nil){
            
            self.viewForConfirmSetLockCode.isHidden = false
            self.viewForQuestion.isHidden = false
            myStringOnOff = ""
            self.outletBtnSave.frame.origin.y = (self.viewForQuestion.frame.size.height + self.viewForQuestion.frame.origin.y+30)
        }else{
            
            savedLockCode = defaults.string(forKey: "SavedLockCode")!
            myStringOnOff = tempStringOnOff!
            if(myStringOnOff == "On"){
                
                self.viewForConfirmSetLockCode.isHidden = true
                self.viewForQuestion.isHidden = true
                self.labelForsetCode.text = "Current lock code"
//                self.outletBtnSave.setTitle("GO", for: .normal)
                self.outletBtnSave.setBackgroundImage(UIImage.init(named: "go_Lock.png"), for: .normal)
                self.outletBtnSave.frame.origin.y = (self.viewForSetLockCode.frame.size.height + self.viewForSetLockCode.frame.origin.y+30)
                self.imageForBackground.frame.size.height = (self.viewForSetLockCode.frame.size.height)
                
            }else if(myStringOnOff == "Off"){
                
                self.viewForConfirmSetLockCode.isHidden = true
                self.viewForQuestion.isHidden = true
                self.labelForsetCode.text = "Current lock code"
             //   self.outletBtnSave.setTitle("GO", for: .normal)
                self.outletBtnSave.setBackgroundImage(UIImage.init(named: "go_Lock.png"), for: .normal)

                self.outletBtnSave.frame.origin.y = (self.viewForSetLockCode.frame.size.height + self.viewForSetLockCode.frame.origin.y+30)
                self.imageForBackground.frame.size.height = (self.viewForSetLockCode.frame.size.height)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        view.endEditing(true)
        
        let setCode = self.textFiledForsetCode.text
        
        if(myStringOnOff == ""){
            let resetCode = self.textFiledForResetCode.text
            let question = self.textfiledForQuestion.text
            
            if(setCode?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
            }else if(resetCode?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
            }else if(question?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
            }
            else if(setCode != resetCode){
                self.showAlertView(title: "Error", message: "Set code and confirm code not same")
            }else{
                
                defaults.set(question, forKey: "SavedQuestion")
                defaults.set(setCode, forKey: "SavedLockCode")
                defaults.set("On", forKey: "SavedLockCodeOnOff")
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            
            if(savedLockCode == setCode){
                
                if(myStringOnOff == "On"){
                    defaults.set("Off", forKey: "SavedLockCodeOnOff")
                }else if(myStringOnOff == "Off"){
                    defaults.set("On", forKey: "SavedLockCodeOnOff")
                }
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showAlertView(title: "Error", message: "Existing lock code dose not match")
            }
            print("update")
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        view.endEditing(true)

        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showAlertView(title:String ,message:String)  {
        
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            
            
        }
        self.present(alertController, animated: true, completion:nil)
        alertController.addAction(OKAction)
        
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
