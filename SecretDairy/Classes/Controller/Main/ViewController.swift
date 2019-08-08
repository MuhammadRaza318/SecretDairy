//
//  ViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/27/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.


import UIKit
import MediaPlayer
import AVFoundation
import CoreData
import GoogleMobileAds
import UnityAds

class ViewController: UIViewController, UITextViewDelegate, UIPageViewControllerDataSource, MPMediaPickerControllerDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADBannerViewDelegate , GADInterstitialDelegate, UnityAdsDelegate{
    
    var interstitial: GADInterstitial!
    @IBOutlet var viewForLockAnimation: UIView!
    
    @IBOutlet var viewForBottom: UIView!
    
    let defaults = UserDefaults.standard
    let formatter = DateFormatter()
    
    let dateFormatter = DateFormatter()
    var flagForSwipe = true
    var stringDate:String = ""
    var pageViewController : UIPageViewController?
    
    var flagForKeybord  = false
    var player: AVAudioPlayer?
    
    var chosenImage = UIImage()
    let picker = UIImagePickerController()
    
    var flagForUseInter = false
    var addStringDate:String = ""
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func unityAdsReady(_ placementId: String) {
        print(placementId)
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        print(message)
    }
    func unityAdsDidStart(_ placementId: String) {
        print(placementId)
    }
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        
        self.viewForRewardVideo.isHidden = true
        self.pageViewController?.view.isUserInteractionEnabled = true
        self.dateFormatter.dateFormat = "dd, EEEE, MMMM, yyyy"
        StructCurrentDate.currentDate = self.dateFormatter.date(from:addStringDate)
        if state != .skipped{
            //Add code to reward the player here
            let valu1 = CoreDataClass.updateAddCounterInDataBase(entityName: "AddCounter", pageDate:addStringDate , addCounter: 0)
            print(valu1)
        }else{
            print("")
        }
    }
    
    override func viewDidLoad() {
        
        let SaveRemoveAdd = UserDefaults.standard.string(forKey: "SaveRemoveAdd")
        
        if(SaveRemoveAdd == "RemoveAdd"){
            Intertestial_ID = ""
            UnityVideoAdd_ID = ""
        }
        
        UnityAds.initialize(UnityVideoAdd_ID, delegate: self)
        
        self.viewForRewardVideo.isHidden = true
        viewForRewardVideo.layer.zPosition = 2
        
        registerNotification(name: "KeyboardHideenUnHiddenIdentifier")
        registerNotification(name: "SearchViewController")
        registerNotification(name: "NextPagePreviouePage")
        registerNotification(name: "MusicViewControllerOpen")
        registerNotification(name: "ImageViewIdentifier")
        
        //registerNotification(name: "isUserInteractionEnabled")
        registerNotification(name: "ShowVideoAdd")
        registerNotification(name: "UnHiddenLockScreen")
        
        registerNotificationForInAppPurchase(name: "RemoveAddIdentifier")
        
        let fontName = defaults.string(forKey: "SavedFontName")
        if(fontName == nil){
            defaults.set("AmericanTypewriter-CondensedLight", forKey: "SavedFontName")
        }else{
            
             createInterstitial()
        }
        
        super.viewDidLoad()
        
        //        flagForUseInter = true
        
        self.viewForLockAnimation.frame = self.view.bounds
        
        self.formatter.dateFormat = "yyyy MM dd"
        let tempDate = formatter.string(from: Date())
        StructCurrentDate.currentDate = formatter.date(from:tempDate)
        
        // Page view controller setting
        
        self.dateFormatter.dateFormat = "dd, EEEE, MMMM, yyyy"
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func  registerNotification(name:String) {
        
        let notificationName = Notification.Name(name)
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenUnHiddeketbord(notification:)), name: notificationName, object: nil)
    }
    
    @objc func hiddenUnHiddeketbord(notification: Notification) {
        
        if(notification.name.rawValue == "KeyboardHideenUnHiddenIdentifier" ){
            
            let obj = notification.object as! String
            print(obj)
            if(obj == "hidden"){
                flagForSwipe = false
            }else{
                flagForSwipe = true
            }
            //        }else if(notification.name.rawValue == "isUserInteractionEnabled"){
            //
            //            let obj = notification.object as! String
            //            print(obj)
            //            if(obj == "hidden"){
            //                self.view.isUserInteractionEnabled = false
            //            }else{
            //                self.view.isUserInteractionEnabled = true
            //            }
        }
        else if(notification.name.rawValue == "SearchViewController"){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            self.present(vc, animated: true, completion: nil)
            
        }else if(notification.name.rawValue == "NextPagePreviouePage"){
            
            if  (flagForSwipe == true){
                
                let obj = notification.object as! String
                if(obj == "NextPage"){
                    
                    nextDate()
                    let startingViewController: InstructionView = viewControllerAtIndex()!
                    let viewControllers = [startingViewController]
                    pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: true, completion: nil)
                    
                }else if(obj == "PreviouePage"){
                    
                    preDate()
                    let startingViewController: InstructionView = viewControllerAtIndex()!
                    let viewControllers = [startingViewController]
                    pageViewController!.setViewControllers(viewControllers , direction: .reverse, animated: true, completion: nil)
                }
            }
        }else if(notification.name.rawValue == "MusicViewControllerOpen"){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MusicViewController") as! MusicViewController
            self.present(vc, animated: true, completion: nil)
            
        }else if(notification.name.rawValue == "ImageViewIdentifier"){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            let obj = notification.object as! URL
            vc.imageURL = obj
            self.present(vc, animated: true, completion: nil)
            
        }else if(notification.name.rawValue == "UnHiddenLockScreen"){
            
            let  tempStringOnOff = defaults.string(forKey: "SavedLockCodeOnOff")
            
            if(tempStringOnOff == nil || tempStringOnOff == "Off"){
                self.viewForLockAnimation.isHidden = true
                
            }else{
                self.pageViewController?.view.isUserInteractionEnabled = false
                
                flagForUseInter = true
                self.viewForLockAnimation.frame = self.view.bounds
                self.viewForLockAnimation.isHidden = false
                viewForLockAnimation.layer.zPosition = 1
            }
        }else if(notification.name.rawValue == "ShowVideoAdd"){
            
            //self.pageViewController?.view.isUserInteractionEnabled = false
            addStringDate = notification.object as! String
            //self.viewForRewardVideo.isHidden = false
            
            if (UnityAds.isReady("video")) {
                UnityAds.show(self)
            }else{
                showAlertView(title: "", message: "Please check your internet connection")
            }
        }
    }
    
    struct BottomBarHight {
        
        static var bottomBarHight : CGFloat = 0
        static var keybordHight : CGFloat = 0
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if (flagForKeybord) {
            
        }else{
            
            flagForKeybord = true
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                BottomBarHight.keybordHight = keyboardHeight
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let SaveRemoveAdd = UserDefaults.standard.string(forKey: "SaveRemoveAdd")
        if(SaveRemoveAdd == "RemoveAdd"){
            Banner_ID = ""
        }

        BottomBarHight.bottomBarHight = self.viewForBottom.frame.size.height
        settingOfPageViewController()
        
        
    }
    func settingOfPageViewController() {
        
        pageViewController?.willMove(toParent: nil)
        pageViewController?.view.removeFromSuperview()
        pageViewController?.removeFromParent()
     
       // print(StructCurrentDate.currentDate!)
        let myDate = Date()
         print(myDate)
        stringDate = self.dateFormatter.string(from:myDate)
        print(stringDate)
        
        pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: InstructionView = viewControllerAtIndex()!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-self.viewForBottom.frame.size.height);
        
        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParent: self)
        
        if(flagForUseInter){
            self.pageViewController?.view.isUserInteractionEnabled = false
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if(flagForSwipe == true){
            preDate()
            return viewControllerAtIndex()
        }else{
            return nil
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if  (flagForSwipe == true){
            nextDate()
            return viewControllerAtIndex()
        }else{
            return nil
        }
    }
    
    func nextDate(){
        
        let  tempDate = dateFormatter.date(from: stringDate)!
        let fireCurrentDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)
        StructCurrentDate.currentDate = fireCurrentDate
        stringDate = self.dateFormatter.string(from: fireCurrentDate!)
        print(stringDate)
    }
    
    func preDate(){
        let  tempDate = dateFormatter.date(from: stringDate)!
        let fireCurrentDate = Calendar.current.date(byAdding: .day, value: -1, to: tempDate)
        
        StructCurrentDate.currentDate = fireCurrentDate
        stringDate = self.dateFormatter.string(from: fireCurrentDate!)
        print(stringDate)
    }
    
    func viewControllerAtIndex() -> InstructionView?
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = InstructionView()
        pageContentViewController.titleDate = stringDate
        pageContentViewController.textDetail = ""
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    //    @objc func tap() {
    //        // view.endEditing(true)
    //    }
    
    struct StructCurrentDate {
        
        static var currentDate : Date? = nil
        
    }
    
    @IBAction func btnUnlock(_ sender: Any) {
        
        self.pageViewController?.view.isUserInteractionEnabled = false
        showAlertWithTwoTextFields()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func btnCalendar(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController")
        self.navigationController?.pushViewController(controller!, animated: true)
        
    }
    
    @IBAction func btnAudio(_ sender: Any) {
        
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.allowsPickingMultipleItems = false
        mediaPicker.delegate = self
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    // Delegated MPMediaPicker
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("selected")
        
        let item = mediaItemCollection.items.first
        do {
            if let url = item?.assetURL {
                print(url)
                let uuid = NSUUID().uuidString
                var arrayForResult: [NSManagedObject] = []
                let  tempStringDate = self.dateFormatter.string(from:StructCurrentDate.currentDate!)
                arrayForResult = CoreDataClass.GetRecordOfSoundRecord(entityName:"SoundList", soundDate:tempStringDate)
                if(arrayForResult.count>0){
                    let flag =  CoreDataClass.DeleteSoundFileRecordFormDataBase(entityName: "SoundList", soundDate: tempStringDate)
                    if(flag){
                        let flag2 = CoreDataClass.insertSoundInDataBase(entityName: "SoundList", soundID: uuid, soundPath:url , soundDate:tempStringDate)
                        if(flag2){
                            print("insert")
                        }
                    }
                }else{
                    let flag2 = CoreDataClass.insertSoundInDataBase(entityName: "SoundList", soundID: uuid, soundPath:url , soundDate:tempStringDate)
                    if(flag2){
                        print("insert")
                    }
                }
                
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.picker.delegate = self
        self.present(self.picker, animated: true, completion: nil)
    }
    @IBAction func btnSetting(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let uuid = NSUUID().uuidString
        
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        if let data = chosenImage.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(uuid+".png")
            let  tempStringDate = self.dateFormatter.string(from:StructCurrentDate.currentDate!)
            let flag = CoreDataClass.insertImageInDataBase(entityName:"ImageList", imageID:uuid, imagePath:filename, imageDate:tempStringDate)
            if(flag){print("insert")}
            try? data.write(to: filename)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
    
    
    
    
    
    
    
    func showAlertWithTwoTextFields() {
        
        let alertController = UIAlertController(title:nil , message: "Enter Lock Code", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            
            let eventNameTextField = alertController.textFields![0] as UITextField
            eventNameTextField.keyboardType = .numberPad
            
            if eventNameTextField.text != ""{
                
                let savedLockCode = self.defaults.string(forKey: "SavedLockCode")!
                
                if(eventNameTextField.text == savedLockCode){
                    
                    self.pageViewController?.view.isUserInteractionEnabled = true
                    self.flagForUseInter = false
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        self.viewForLockAnimation.frame.size.width = 0
                    }) { _ in
                        self.viewForLockAnimation.isHidden = true
                    }
                }else{
                    self.showAlertView(title: "Fail", message: "Lock code is wrong")
                }
            }else{
                print("is empty")
            }
        })
        
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.text = ""
        }
        
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertView(title:String ,message:String)  {
        
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            
        }
        self.present(alertController, animated: true, completion:nil)
        alertController.addAction(OKAction)
    }
    
    
    //In app Purchase setting....
    @IBOutlet var viewForRewardVideo: UIView!
    @IBAction func btnHiddenRewardView(_ sender: Any) {
        self.viewForRewardVideo.isHidden = true
        self.pageViewController?.view.isUserInteractionEnabled = true
    }
    @IBAction func btnInAppPurchase(_ sender: Any) {
        self.viewForRewardVideo.isHidden = true
        self.pageViewController?.view.isUserInteractionEnabled = true
       // InAppPurchase.sharedInstance.buyRemoveAddInAppPurchase()
        
    }
    @IBAction func btnRestore(_ sender: Any) {
        
        self.viewForRewardVideo.isHidden = true
        self.pageViewController?.view.isUserInteractionEnabled = true
      //  InAppPurchase.sharedInstance.restoreTransactions()
    }
    @IBAction func btnPlayReward(_ sender: Any) {
        
        let placement = "rewardedVideo"
        if (UnityAds.isReady(placement)) {
            UnityAds.show(self, placementId: placement)
        }else{
            showAlertView(title: "", message: "Please check your internet connection")
        }
    }
    
    func  registerNotificationForInAppPurchase(name:String) {
        
        let notificationName = Notification.Name(name)
        NotificationCenter.default.addObserver(self, selector: #selector(removeAddNotification(notification:)), name: notificationName, object: nil)
    }
    
    @objc func removeAddNotification(notification: Notification) {
        
        if(notification.name.rawValue == "RemoveAddIdentifier" ){
            
            UserDefaults.standard.set("RemoveAdd", forKey: "SaveRemoveAdd")
            UserDefaults.standard.synchronize()
            
            let obj = notification.object as! String
            print(obj)
            if(obj == "Purchased"){
                print("Purchased")
            }else{
                print("Restored")
            }
        }
    }
}




//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//        self.present(vc, animated: true, completion: nil)


//        if !FileManager.default.fileExists(atPath: localPath!.path) {
//            do {
//                print("file saved")
//            }catch {
//                print("error saving file")
//}
// }



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
