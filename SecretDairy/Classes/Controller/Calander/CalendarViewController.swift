//
//  CalendarViewController.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/28/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit
import JTAppleCalendar
import GoogleMobileAds
import CoreData


class CalendarViewController: UIViewController ,GADBannerViewDelegate , GADInterstitialDelegate{
    
    let formatter = DateFormatter()
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    
    
    
    
    @IBOutlet var labelForMonth: UILabel!
    //    @IBOutlet var labelForYear: UILabel!
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    
    let outSideMonthColor = UIColor(colorWithHexvalue: 0xF0EFF5)
    let monthColor = UIColor(colorWithHexvalue: 0xADADAD)
    let selectedMonthColor = UIColor.white
    let currentSelectedMonthColor = UIColor(colorWithHexvalue: 0x4e3f5d)
    
    var currentDate:String = ""
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        self.bannerViewSetting()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loadBanner), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        setupCalendarView()
    }
    
    func setupCalendarView() {
        //setup calendar view
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollToDate(ViewController.StructCurrentDate.currentDate!, animateScroll: false)
        
        // setup label
        calendarView.visibleDates { (visibleDates) in
            self.setUpViewOfCalendar(from: visibleDates)
        }
    }
    
    func setUpViewOfCalendar(from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        let year = self.formatter.string(from: date)
        self.formatter.dateFormat = "MMMM"
        let month = self.formatter.string(from: date)
        self.labelForMonth.text = month + " " + year
        // calendarView.reloadData()
    }
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCalendarCollectionViewCell else {return}
        
        if cellState.isSelected {
            validCell.selectedCell.isHidden = false
            
        }else{
            validCell.selectedCell.isHidden = true
        }
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCalendarCollectionViewCell else {return}
        
        if(cellState.dateBelongsTo == .thisMonth){
            validCell.datelabel.textColor = monthColor
            validCell.viewForBackground.backgroundColor = UIColor.white
            validCell.isHidden = false
            //                validCell.datelabel.isHidden = false
            //                validCell.selectedCell.isHidden = false
            //                validCell.viewForBackground.isHidden = false
            //                validCell.viewForNotification.isHidden = false
            
        }else{
            validCell.datelabel.textColor = monthColor
            validCell.viewForBackground.backgroundColor = UIColor.white
            validCell.isHidden = true
            //                validCell.datelabel.isHidden = true
            //                validCell.selectedCell.isHidden = true
            //                validCell.viewForBackground.isHidden = true
            //                validCell.viewForNotification.isHidden = true
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previous(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func today(_ sender: Any) {
        
        ViewController.StructCurrentDate.currentDate = Date()
        calendarView.scrollToDate(ViewController.StructCurrentDate.currentDate!, animateScroll: false)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        currentDate = formatter.string(from: Date())
        
        let stDate = formatter.date(from: "1980 01 01")!
        let enDate = formatter.date(from: "2070 12 31")!
        
        let parameter = ConfigurationParameters(startDate: stDate, endDate: enDate)
        return parameter
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    //Display cell...
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCollectionViewCell", for: indexPath) as! CustomCalendarCollectionViewCell
        cell.datelabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        cell.selectedCell.isHidden = true
        self.formatter.dateFormat = "yyyy MM dd"
        
        let dateForma = DateFormatter()
        dateForma.dateFormat = "dd, EEEE, MMMM, yyyy"
        let pageDate = dateForma.string(from: date)
        //        let count = CoreDataClass.GetLengthOfRecord(entityName:"DiaryPage", pageDate:pageDate )
        var arrayForResult2: [NSManagedObject] = []
        arrayForResult2 = CoreDataClass.retriveDairyAllPage(entityName: "DiaryPage", pageDate: pageDate)
        var flag = false
        if(arrayForResult2.count>0){
            for object in arrayForResult2 {
                let text  = object.value(forKeyPath: "pageText") as? String
                if(text != ""){
                    flag = true
                }
            }
            if(flag){
                cell.viewForNotification.isHidden = false
            }else{
                cell.viewForNotification.isHidden = true
            }
        }else{
            cell.viewForNotification.isHidden = true
        }
        
        let selectDate = formatter.string(from: date)
        
        if(currentDate == selectDate){
            
            //            print( selectDate)
            //            print("currentDate................")
            //            print(currentDate)
            cell.selectedCell.isHidden = false
            cell.selectedCell.backgroundColor = UIColor(red: CGFloat(237.0/255.0), green: CGFloat(204.0/255.0), blue: CGFloat(231.0/255.0), alpha: 1.0)
            cell.datelabel.textColor = UIColor.black
        }else{
            cell.selectedCell.isHidden = true
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        if(cellState.dateBelongsTo == .thisMonth){
            print("YES")
            handleCellSelected(cell: cell, cellState: cellState)
            handleCellTextColor(cell: cell, cellState: cellState)
            ViewController.StructCurrentDate.currentDate = date
            print(date)
            self.navigationController?.popViewController(animated: true)
        }else{
            print("NO")
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        if(cellState.dateBelongsTo == .thisMonth){
            handleCellSelected(cell: cell, cellState: cellState)
            handleCellTextColor(cell: cell, cellState: cellState)
            print(date)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        self.setUpViewOfCalendar(from: visibleDates)
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

extension UIColor {
    
    convenience init(colorWithHexvalue value:Int, alpha:Float = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

