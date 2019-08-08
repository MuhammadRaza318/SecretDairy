//
//  MusicViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 1/5/18.
//  Copyright © 2018 Muhammad Luqman. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import CoreData
import GoogleMobileAds


class MusicViewController: UIViewController, GADBannerViewDelegate , GADInterstitialDelegate  {
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    
    
    @IBOutlet var outletBtnPlayPause: UIButton!
    @IBOutlet var outletSliderbar: UISlider!
    var player: AVAudioPlayer?
    let dateFormatter = DateFormatter()
    @IBOutlet var labelNotFond: UILabel!
    
    
    @IBOutlet var volumeParentView: UIView!
    var mpVolumeSlider = UISlider() // MPVolumeSlider
    
    override func viewDidLoad() {
        
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)

        
        self.dateFormatter.dateFormat = "dd, EEEE, MMMM, yyyy"
        
        var arrayForResult: [NSManagedObject] = []
        let  tempStringDate = self.dateFormatter.string(from:ViewController.StructCurrentDate.currentDate!)
        arrayForResult = CoreDataClass.GetRecordOfSoundRecord(entityName:"SoundList", soundDate:tempStringDate)
        
        if(arrayForResult.count>0){
            for object in arrayForResult {
                let url = object.value(forKeyPath: "soundPath")
                print(url!)
                setUpFile(url: url as! URL)
            }
            self.labelNotFond.isHidden = true
        }else{
            self.labelNotFond.isHidden = false
            self.outletBtnPlayPause.isHidden = true
        }
        super.viewDidLoad()
        
        
        volumeParentView.backgroundColor = UIColor.clear
        let volumeView = MPVolumeView(frame: volumeParentView.bounds)
        for view in volumeView.subviews {
            let uiview: UIView = view as UIView
            if (uiview.description as NSString).range(of: "MPVolumeSlider").location != NSNotFound {
                self.mpVolumeSlider = (uiview as! UISlider)
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionSliderbar(_ sender: UISlider) {
       
        mpVolumeSlider.value = sender.value
       
    }
    @IBAction func btnPlayPause(_ sender: Any) {
        
        let tag = (sender as AnyObject).tag
        
        if(tag == 1){
            self.outletBtnPlayPause.tag = 2
            self.outletBtnPlayPause.setBackgroundImage(UIImage.init(named: "pause.png"), for: .normal)
            print("play")
            player?.play()

        }else{
            print("pause")
            player?.pause()
            self.outletBtnPlayPause.tag = 1
            self.outletBtnPlayPause.setBackgroundImage(UIImage.init(named: "play.png"), for: .normal)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpFile(url:URL) {
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func stringFromTimeInterval(interval: Double) -> NSString {
        
        //            let audioDuration = player.duration
        //            let minHSe =  stringFromTimeInterval(interval: audioDuration)
        //            print(minHSe)

        let hours = (Int(interval) / 3600)
        let minutes = Int(interval / 60) - Int(hours * 60)
        let seconds = Int(interval) - (Int(interval / 60) * 60)
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
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
