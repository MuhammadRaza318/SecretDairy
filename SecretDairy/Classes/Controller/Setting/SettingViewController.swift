//
//  SettingViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/27/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.


import UIKit
import GoogleMobileAds

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , GADBannerViewDelegate , GADInterstitialDelegate {

    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    @IBOutlet var settingTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let defaults = UserDefaults.standard

    var arrayForSection = [String]()
    var arrayForRow = [String]()
    var arrayForRowDetail = [String]()

    override func viewDidLoad() {
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        
        arrayForSection = [ "FONT", "LOCK CODE","IN APP PURCHASE"]
        arrayForRow = [ "Page Font", "Lock Code","Purchase","Restore"]
        arrayForRowDetail = ["GillSans-UltraBold", "not filled","to remove add and get unlimited access purchase this app",""]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let  tempStringOnOff = defaults.string(forKey: "SavedLockCodeOnOff")
        
        if(tempStringOnOff == nil){
        }else{
            arrayForRowDetail.remove(at: 1)
            arrayForRowDetail.insert(tempStringOnOff!, at: 1)
        }
        
       let fontName = defaults.string(forKey: "SavedFontName")!
        arrayForRowDetail.remove(at: 0)
        arrayForRowDetail.insert(fontName, at: 0)
        
        DispatchQueue.main.async {
            self.settingTableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            print("On")
        }else{
            print("Off")
        }
    print()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }

    
    // tableview Delegated........
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2){
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "SettingTableViewCell"
        var cell: SettingTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingTableViewCell)!
        }
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                cell.labelForTitle.text = self.arrayForRow[2]
                cell.labelForDetail.text = self.arrayForRowDetail[2]
            }else{
                cell.labelForTitle.text = self.arrayForRow[3]
                cell.labelForDetail.text = self.arrayForRowDetail[3]
            }
        }else{
            cell.labelForTitle.text = self.arrayForRow[indexPath.section]
            cell.labelForDetail.text = self.arrayForRowDetail[indexPath.section]
        }
        
        if(indexPath.section == 1){
            if("not filled" == self.arrayForRowDetail[indexPath.section]){
            cell.labelForDetail.textColor = UIColor.red
        }else{
            cell.labelForDetail.textColor = UIColor(red: CGFloat(173.0/255.0), green: CGFloat(63.0/255.0), blue: CGFloat(152.0/255.0), alpha: 1)
                cell.labelForDetail.alpha = 0.6
        }
        }else{
            cell.labelForDetail.textColor = UIColor(red: CGFloat(173.0/255.0), green: CGFloat(63.0/255.0), blue: CGFloat(152.0/255.0), alpha: 1)
            cell.labelForDetail.alpha = 0.6
        }
        
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                cell.labelForDetail.text = self.arrayForRowDetail[2]
                cell.labelForDetail.adjustsFontSizeToFitWidth = true
                cell.labelForDetail.minimumScaleFactor = 0
            }else{
                cell.labelForDetail.isHidden = true
            }
        }else{
                cell.labelForDetail.isHidden = false
        }
        
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
            cell.labelForDetail.font = UIFont(name: "Helvetica", size: 20.0)
            cell.labelForTitle.font = UIFont(name: "Helvetica", size: 20.0)

        } else {
            print("I AM IPHONE")
            cell.labelForDetail.font = UIFont(name: "Helvetica", size: 12.0)
            cell.labelForTitle.font = UIFont(name: "Helvetica", size: 12.0)
        }
        
        cell.outletSwitch.isHidden = true
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0){
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "FontViewController")
            self.navigationController?.pushViewController(controller!, animated: true)
        }else if(indexPath.section == 1){
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LockCodeViewController")
            self.navigationController?.pushViewController(controller!, animated: true)
            
        }else if(indexPath.section == 2){
            
//            if(indexPath.row == 0){
//                
//                InAppPurchase.sharedInstance.buyRemoveAddInAppPurchase()
//                print("inApp purchase....")
//            }else{
//                
//                print("Restore....")
//                InAppPurchase.sharedInstance.restoreTransactions()
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let d:Float = 255
        let r:Float = 234
        let g:Float = 189
        let b:Float = 224
        
        let r2:Float = 93
        let g2:Float = 0
        let b2:Float = 85
        
        headerView.backgroundColor = UIColor (red: CGFloat(r/d), green: CGFloat(g/d), blue: CGFloat(b/d), alpha: 1)
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 18, width: tableView.bounds.size.width, height: tableView.bounds.size.height-10))
        
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
            headerLabel.font = UIFont(name: "Helvetica-Bold", size: 20.0)
        } else {
            print("I AM IPHONE")
            headerLabel.font = UIFont(name: "Helvetica-Bold", size: 12.0)
        }


        headerLabel.textColor = UIColor (red: CGFloat(r2/d), green: CGFloat(g2/d), blue: CGFloat(b2/d), alpha: 1)
        
        headerLabel.text = arrayForSection[section]
        headerLabel.sizeToFit()
        
        headerView.addSubview(headerLabel)
        return headerView
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
    
    // Watch video to add more two pages
    //to remove add and get unlimited access purchase this app

}


