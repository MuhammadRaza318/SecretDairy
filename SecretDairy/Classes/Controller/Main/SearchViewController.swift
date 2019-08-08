//
//  SearchViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 1/3/18.
//  Copyright © 2018 Muhammad Luqman. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchControllerDelegate, UISearchBarDelegate, GADBannerViewDelegate , GADInterstitialDelegate {
    
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    
    
    @IBOutlet var searchBarTabel: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var arrayForPageDiaryDate = [String]()
    var arrayForPageDiaryID = [String]()
    var arrayForPageDiaryText = [String]()
    
    override func viewDidLoad() {
        
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)

        
        
        super.viewDidLoad()
        searchBar.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let h = self.searchBar.frame.size.height+self.searchBar.frame.origin.y
        self.searchBarTabel.frame.origin.y = h
        self.searchBarTabel.frame.size.height = self.view.frame.size.height - h
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // tableview Delegated........
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayForPageDiaryID.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "SearchTableViewCell"
        var cell: SearchTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableViewCell)!
        }
        cell.labelForDate.text = self.arrayForPageDiaryDate[indexPath.row]
        cell.labelForText.text = self.arrayForPageDiaryText[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let words = arrayForPageDiaryDate[indexPath.row].components(separatedBy: ",")
        let StringDat = words[3] + " " + words[2] + " " + words[0]
        let tempDate = formatter.date(from: StringDat)
        ViewController.StructCurrentDate.currentDate = tempDate
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchDataFromDataBase(text: searchBar.text!)
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        searchDataFromDataBase(text: searchText)
    }
    
    func searchDataFromDataBase(text:String) {
        
        self.arrayForPageDiaryDate.removeAll()
        self.arrayForPageDiaryID.removeAll()
        self.arrayForPageDiaryText.removeAll()
        self.searchBarTabel.reloadData()
        print(searchBar.text!)
        
        var arrayForResult: [NSManagedObject] = []
        arrayForResult = CoreDataClass.searchDataFromDatabase(entityName: "DiaryPage", text: text)
        
        for object in arrayForResult {
            
            self.arrayForPageDiaryID.append((object.value(forKeyPath: "pageID") as? String)!)
            self.arrayForPageDiaryDate.append((object.value(forKeyPath: "pageDate") as? String)!)
            self.arrayForPageDiaryText.append((object.value(forKeyPath: "pageText") as? String)!)
        }
        self.searchBarTabel.reloadData()
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
