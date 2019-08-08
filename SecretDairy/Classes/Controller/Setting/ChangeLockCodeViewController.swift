//
//  ChangeLockCodeViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/28/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ChangeLockCodeViewController: UIViewController, GADBannerViewDelegate , GADInterstitialDelegate  {
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    
    
    @IBOutlet var textfiledCurrentCode: UITextField!
    @IBOutlet var textfiledNewCode: UITextField!
    @IBOutlet var textfiledConfirmCode: UITextField!
    @IBOutlet var textfiledQuestion: UITextField!
    @IBOutlet var labelForTitle: UILabel!
    
    @IBOutlet var viewForCurrentCode: UIView!
    @IBOutlet var viewForNewCode: UIView!
    @IBOutlet var viewForConfirmCode: UIView!
    @IBOutlet var viewForQuestion: UIView!
    
    @IBOutlet var outletBtnUpdate: UIButton!
    
    let defaults = UserDefaults.standard
    var savedLockCode = ""
    var savedQuestion = ""
    
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
        
        savedLockCode = defaults.string(forKey: "SavedLockCode")!
        savedQuestion = defaults.string(forKey: "SavedQuestion")!
        
        if(LockCodeViewController.StaticSelectView.selectViewName == "Forgot"){
            
            self.viewForQuestion.isHidden = false
            self.viewForCurrentCode.isHidden = true
            self.textfiledQuestion.becomeFirstResponder()
//            self.outletBtnUpdate.setTitle("Save", for: .normal)
            self.outletBtnUpdate.setBackgroundImage(UIImage.init(named: "save_Lock.png"), for: .normal)
            self.labelForTitle.text = "Forgot Lock Code"
            
        }else{
            
            self.textfiledCurrentCode.becomeFirstResponder()
            self.viewForQuestion.isHidden = true
            self.viewForCurrentCode.isHidden = false
//            self.outletBtnUpdate.setTitle("Update", for: .normal)
            self.outletBtnUpdate.setBackgroundImage(UIImage.init(named: "update_Lock.png"), for: .normal)
            self.labelForTitle.text = "Change Lock Code"
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        
        let newCode = self.textfiledNewCode.text
        let confirmCode = self.textfiledConfirmCode.text
        
        view.endEditing(true)
        if(LockCodeViewController.StaticSelectView.selectViewName == "Forgot"){
            
            let question = self.textfiledQuestion.text
            if(question?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
            }else if(newCode?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
            }else if(confirmCode?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
            }else if(question != savedQuestion){
                self.showAlertView(title: "Error", message: "Answer dose not match")
            }else if(newCode != confirmCode){
                self.showAlertView(title: "Error", message: "new code and confirm code not same")
            }else{
                defaults.set(confirmCode, forKey: "SavedLockCode")
                defaults.set("Off", forKey: "SavedLockCodeOnOff")
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            
            let currentCode = self.textfiledCurrentCode.text
            
            if(currentCode?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
                
            }else if(newCode?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
                
            }else if(confirmCode?.isEmpty)!{
                self.showAlertView(title: "Error", message: "filed is empty")
            }else if(currentCode != savedLockCode){
                self.showAlertView(title: "Error", message: "Existing lock code dose not match")
            }else if(newCode != confirmCode){
                self.showAlertView(title: "Error", message: "new code and confirm code not same")
            }else{
                
                defaults.set(confirmCode, forKey: "SavedLockCode")
                defaults.set("Off", forKey: "SavedLockCodeOnOff")
                self.dismiss(animated: true, completion: nil)
            }
        }
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
