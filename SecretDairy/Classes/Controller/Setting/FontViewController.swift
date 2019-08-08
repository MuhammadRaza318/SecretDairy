//
//  FontViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/27/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FontViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate , GADInterstitialDelegate  {
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    @IBOutlet var viewForHeader: UIView!
    
    
    var arrayForFountName = [String]()
    var fontName = String()
    var selectIndex = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let defaults = UserDefaults.standard
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var tabelForFontSetting: UITableView!
    override func viewDidLoad() {
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)

        
        super.viewDidLoad()
        
        fontName = defaults.string(forKey: "SavedFontName")!
        
        UIFont.familyNames.sorted().forEach{ familyName in
            //  print("*** \(familyName) ***")
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print("\(fontName)")
                arrayForFountName.append(fontName)
            }
        }
        
        if let row = arrayForFountName.firstIndex(of: fontName) {
            selectIndex = row
            self.tabelForFontSetting.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // tableview Delegated........
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayForFountName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "FontTableViewCell"
        var cell: FontTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? FontTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? FontTableViewCell)!
        }
        
        cell.labelForText.text = arrayForFountName[indexPath.row]
        
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
            cell.labelForText?.font = UIFont(name:arrayForFountName[indexPath.row]  , size: 18)
        } else {
            print("I AM IPHONE")
            cell.labelForText?.font = UIFont(name:arrayForFountName[indexPath.row]  , size: 12)
        }

        if indexPath.row == selectIndex {
            cell.imageForIcon.isHidden = false
        }else{
            cell.imageForIcon.isHidden = true
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.fontName = self.arrayForFountName[indexPath.row]
        selectIndex = indexPath.row
        self.tabelForFontSetting.reloadData()
        defaults.set(self.fontName, forKey: "SavedFontName")
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45
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
        
        self.tabelForFontSetting.frame.size.height = (self.view.frame.size.height-(self.bannerView.frame.size.height+self.viewForHeader.frame.size.height))
        
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
