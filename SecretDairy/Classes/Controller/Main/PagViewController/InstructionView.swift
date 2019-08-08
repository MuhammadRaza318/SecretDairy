
import UIKit
import CoreData

class InstructionView: UIViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var titleDate : String = ""
    var textDetail : String = ""
    
    var note = NoteView()
    let topSpace:CGFloat = 80
    let nextPerBtnViewHight:CGFloat = 30
    let collectionViewHight:CGFloat = 55
    
    var imageCollectionViewHight:CGFloat = 45
    
    let LRSpace:CGFloat = 1
    let buttonHigAndWid:CGFloat = 45
    var buttonForSearch = UIButton()
    
    var arrayForPageDiaryTitle = [String]()
    var arrayForPageDiaryID = [String]()
    var arrayForPageDiaryText = [String]()
    
    var arrayForImageDiaryID = [String]()
    var arrayForImageDiaryImagePath = [URL]()
    
    var currentSelectIndex = 0
    
    var collectionView:UICollectionView!
    var imageCollectionView:UICollectionView!
    
    enum MyError: Error {
        case FoundNil(String)
    }
    /*

     if ( UIDevice.current.model.range(of: "iPad") != nil){
     print("I AM IPAD")
     
     } else {
     print("I AM IPHONE")
     }
 */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // get diary page from database........................................
        
        let count = CoreDataClass.GetLengthOfRecord(entityName:"DiaryPage", pageDate: self.titleDate)
        if(count>0){
            
            var arrayForResult: [NSManagedObject] = []
            arrayForResult = CoreDataClass.retriveDairyAllPage(entityName: "DiaryPage", pageDate: self.titleDate)
            
            for object in arrayForResult {
                
                self.arrayForPageDiaryID.append((object.value(forKeyPath: "pageID") as? String)!)
                self.arrayForPageDiaryTitle.append((object.value(forKeyPath: "pageTitle") as? String)!)
                self.arrayForPageDiaryText.append((object.value(forKeyPath: "pageText") as? String)!)
            }
        }else{
            
            let uuid = NSUUID().uuidString
            arrayForPageDiaryID = [uuid]
            arrayForPageDiaryTitle = ["Diary"]
            arrayForPageDiaryText = [""]
        }
        
        // get image from database........................................
        
        var arrayForResultImage: [NSManagedObject] = []
        arrayForResultImage = CoreDataClass.GetAllImageFromRecord(entityName:"ImageList", imageDate:self.titleDate)
        if  (arrayForResultImage.count > 0){
            imageCollectionViewHight = 45
            for object in arrayForResultImage {
                
                let imagePath = (object.value(forKeyPath: "imagePath") as? URL)
                let imageID = (object.value(forKeyPath: "imageID") as? String)
                //                let imagePathString = imagePath?.absoluteString
                //                let tempArray = imagePathString?.components(separatedBy: "file://")
                //                print(tempArray![1])
                //                imagePath = URL(string: tempArray![1])
                if FileManager.default.fileExists(atPath: imagePath!.path) {
                    do {
                        
                        if let imgId = imageID{
                            self.arrayForImageDiaryID.append(imgId)
                        }else{
                            throw MyError.FoundNil("nil")
                        }
                        
                        if let imgPath = imagePath{
                            self.arrayForImageDiaryImagePath.append(imgPath)
                        }else{
                            throw MyError.FoundNil("nil")
                        }
                        
                        
                    }catch {
                        print("error saving file")
                    }
                }
            }
        }else{
            imageCollectionViewHight = 0
        }
        
        
        
        currentSelectIndex = 0;
        let topView = UIView (frame: CGRect(x: 0, y: 0, width: view.frame.width, height: topSpace))
        let backgroundImage = UIImageView()
        backgroundImage.frame = topView.bounds
        backgroundImage.image = UIImage.init(named: "top-bar.png")
        topView.addSubview(backgroundImage)
        
        let nextPrevBtnView = UIView (frame: CGRect(x: 0, y: topSpace, width: view.frame.width, height: nextPerBtnViewHight))
        let backgroundImageNextPre = UIImageView()
        backgroundImageNextPre.frame = nextPrevBtnView.bounds
        backgroundImageNextPre.image = UIImage.init(named: "top-bar-2.png")
        nextPrevBtnView.addSubview(backgroundImageNextPre)
        
        //Collection view for Bootm Page end
        
        let viewForCollectionView = UIView (frame: CGRect(x: 1, y: topSpace+nextPerBtnViewHight, width: view.frame.width-2, height: collectionViewHight))
        viewForCollectionView.backgroundColor = .clear
        //collectionview setting
        self.collectionView = UICollectionView(frame: CGRect(x: 30, y: 0, width: (view.frame.width-80), height: collectionViewHight) , collectionViewLayout: UICollectionViewFlowLayout.init())
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let screenWidth: CGFloat = (self.collectionView.frame.size.width/2.2)
        let screenHeigh: CGFloat = (self.collectionView.frame.size.height/1.2)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth , height: screenHeigh)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        self.collectionView!.collectionViewLayout = layout
        
        self.collectionView.register(UINib.init(nibName: "AddDiaryCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "AddDiaryCollectionViewCell")
        
        viewForCollectionView.addSubview(self.collectionView)
        viewForCollectionView.backgroundColor = UIColor(red: CGFloat(Float(237.0/255.0)), green: CGFloat(Float(204.0/255)), blue: CGFloat(Float(231.0/255.0)), alpha: 1.0)

        let frameAddPageButton = CGRect(x: (view.frame.width-(collectionViewHight-10)), y: 0.5, width: (collectionViewHight-10) , height: collectionViewHight-15)        
        viewForCollectionView .addSubview(addButtonAddPage(frame: frameAddPageButton , imageName: "plus.png"))
        view.addSubview(viewForCollectionView)
        
        //Collection view for Bootm Page end
        
        //Collection view for Bootm image start
        let viewForImageCollectionView = UIView (frame: CGRect(x: 1, y: self.view.frame.size.height-(ViewController.BottomBarHight.bottomBarHight+imageCollectionViewHight), width: view.frame.width-2, height: imageCollectionViewHight))
        viewForImageCollectionView.backgroundColor = UIColor(red: CGFloat(Float(237.0/255.0)), green: CGFloat(Float(204.0/255)), blue: CGFloat(Float(231.0/255.0)), alpha: 1.0)
        
        //collection view for image
        self.imageCollectionView = UICollectionView(frame: CGRect(x: 45, y: 0, width: (view.frame.width-45), height: imageCollectionViewHight) , collectionViewLayout: UICollectionViewFlowLayout.init())
        
        let layout2:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout2.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self.imageCollectionView.setCollectionViewLayout(layout2, animated: true)
        self.imageCollectionView.backgroundColor = UIColor.clear
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        
        let imageScreenHeigh: CGFloat = (self.imageCollectionView.frame.size.height)
        let imageScreenwidth: CGFloat = (self.imageCollectionView.frame.size.height*1.3)
        
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        layout2.itemSize = CGSize(width: imageScreenwidth , height: imageScreenHeigh)
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 2
        self.imageCollectionView!.collectionViewLayout = layout2
        self.imageCollectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "ImageCollectionViewCell")
        viewForImageCollectionView.addSubview(self.imageCollectionView)
        view.addSubview(viewForImageCollectionView)
        
        //Collection view for Bootm image End
        
        
        let words = titleDate.components(separatedBy: ",")
        print(words.count)
        
        let frameDay = CGRect(x: 5, y: 20, width: 55, height: topSpace-20)
        let color = UIColor(red: 0.99, green: 0.92, blue: 0.83, alpha: 1.0)
        topView.addSubview(addLabel(size: 55, frame: frameDay, text: words[0], color:color))
        
        let frameEE = CGRect(x: 62, y: 20, width: 140, height: (topSpace-20)/1.6)
        topView.addSubview(addLabel(size: 20, frame: frameEE, text: words[1].uppercased(), color:color))
        
        let frameMonthYear = CGRect(x: 62, y: (topSpace-20)/1.4, width: 150, height: (topSpace-20)/1.6)
        topView.addSubview(addLabel(size: 16, frame: frameMonthYear, text: words[2]+", "+words[3], color:color))
        
        
        
// Search Button Setting
        buttonForSearch = UIButton(type: .system)
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
            buttonForSearch.frame = CGRect(x: self.view.frame.size.width-((buttonHigAndWid+5)*2), y: (((topSpace-buttonHigAndWid)/2)+8), width: (buttonHigAndWid*1.2), height: (buttonHigAndWid*1.2))
        } else {
            print("I AM IPHONE")
            buttonForSearch.frame = CGRect(x: self.view.frame.size.width-((buttonHigAndWid+5)*2), y: (((topSpace-buttonHigAndWid)/2)+8), width: buttonHigAndWid, height: buttonHigAndWid)
        }

        buttonForSearch.setBackgroundImage(UIImage.init(named: "search.png"), for: .normal)
        buttonForSearch.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        buttonForSearch.backgroundColor = UIColor.clear
        buttonForSearch.tag = 0
        topView.addSubview(buttonForSearch)
//Sound Button Setting
        let frameSoundButton: CGRect
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
            frameSoundButton = CGRect(x: self.view.frame.size.width-(buttonHigAndWid+5), y: (((topSpace-buttonHigAndWid)/2)+8), width: (buttonHigAndWid*1.2), height: (buttonHigAndWid*1.2))

        } else {
            
            print("I AM IPHONE")
            frameSoundButton = CGRect(x: self.view.frame.size.width-(buttonHigAndWid+5), y: (((topSpace-buttonHigAndWid)/2)+8), width: buttonHigAndWid, height: buttonHigAndWid)
        }
        topView.addSubview(addButton(frame: frameSoundButton , imageName: "sound_1.png"))
        
        let framePreviousButton:CGRect
        let frameNextButton:CGRect

        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
             framePreviousButton = CGRect(x: 5, y: 0, width: (nextPerBtnViewHight*2), height: nextPerBtnViewHight)
             frameNextButton = CGRect(x: self.view.frame.width-(nextPerBtnViewHight*2+5), y: 0, width: nextPerBtnViewHight*2, height: nextPerBtnViewHight)
        } else {
            print("I AM IPHONE")
             framePreviousButton = CGRect(x: 5, y: 0, width: (nextPerBtnViewHight*1.5), height: nextPerBtnViewHight)
             frameNextButton = CGRect(x: self.view.frame.width-(nextPerBtnViewHight+5), y: 0, width: nextPerBtnViewHight, height: nextPerBtnViewHight)
        }
        
        nextPrevBtnView.addSubview(addButton(frame: frameNextButton , imageName: "next.png"))
        nextPrevBtnView.addSubview(addButton(frame: framePreviousButton , imageName: "previous.png"))
        
        self.view.addSubview(nextPrevBtnView)
        self.view .addSubview(topView)
        
        //Collection view for  Notes Start
        
        let temTopSpace = topSpace+nextPerBtnViewHight+collectionViewHight
        
        note = NoteView(frame: CGRect(x: LRSpace, y: temTopSpace, width: CGFloat(self.view.frame.size.width)-(LRSpace*2.0), height: CGFloat(self.view.frame.size.height-(temTopSpace+ViewController.BottomBarHight.bottomBarHight+imageCollectionViewHight))))
        
        self.view .addSubview(note)
        note.backgroundColor = UIColor(red: CGFloat(Float(237.0/255.0)), green: CGFloat(Float(204.0/255)), blue: CGFloat(Float(231.0/255.0)), alpha: 1.0)
        
        let defaults = UserDefaults.standard
        let fontName = defaults.string(forKey: "SavedFontName")!
        
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
            note.font = UIFont(name: fontName , size: 24)
        } else {
            print("I AM IPHONE")
            note.font = UIFont(name: fontName , size: 18)
        }

        note.delegate = self
        note.text = arrayForPageDiaryText[currentSelectIndex]
        
        self.collectionView.reloadData()
        self.imageCollectionView.reloadData()
    }
    
    func addButtonAddPage(frame:CGRect, imageName: String) -> UIButton {
        
        let  button = UIButton(type: .system)
        button.frame = frame
        button.setBackgroundImage(UIImage.init(named: imageName), for: .normal)
        button.addTarget(self, action: #selector(addPageBtnAction), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        return button
    }
    func addButton(frame:CGRect, imageName: String) -> UIButton {
        
        let  button = UIButton(type: .system)
        button.frame = frame
        let color = UIColor(red: 0.99, green: 0.92, blue: 0.83, alpha: 1.0)
        
        if (imageName == "sound_1.png") {
            button.setBackgroundImage(UIImage.init(named: imageName), for: .normal)
            button.addTarget(self, action: #selector(soundBtnAction), for: .touchUpInside)
        }else if(imageName == "next.png"){
            button.setTitle("Next", for: .normal)
            button.setTitleColor(color, for: .normal)
            button.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        }else if(imageName == "previous.png"){
            button.setTitle("Previous", for: .normal)
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont(name: "GillSans", size: 12)!
            button.addTarget(self, action: #selector(previousBtnAction), for: .touchUpInside)
        }
        
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            print("I AM IPAD")
            button.titleLabel?.font = UIFont(name: "GillSans", size: 16)!

        } else {
            print("I AM IPHONE")
            button.titleLabel?.font = UIFont(name: "GillSans", size: 12)!
        }

        
        
        
        button.backgroundColor = UIColor.clear
        button.tag = 0
        return button
    }
    
    func addLabel(size:Int, frame:CGRect, text:String , color :UIColor) -> UILabel {
        
        let label = UILabel(frame: frame)
        label.textColor = color
        label.text = text
        label.font = UIFont(name: "GillSans", size: CGFloat(size))
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }
    
    @objc func addPageBtnAction(button: UIButton) {
        
        if(buttonForSearch.tag == 0){
            
            let SaveRemoveAdd = UserDefaults.standard.string(forKey: "SaveRemoveAdd")
            
            if(SaveRemoveAdd == "RemoveAdd"){
                
                showAlertWithTwoTextFields(count: 0)
            }else{

            let count = CoreDataClass.GetLengthOfRecord(entityName:"DiaryPage", pageDate: self.titleDate)
            if(count == 0){
                
              let valu =  CoreDataClass.insertAddCountDataBase(entityName: "AddCounter", pageDate:titleDate , addCounter: 100)
                print(valu)
                let uuid1 = NSUUID().uuidString
                let flag = CoreDataClass.insertPageInDataBase(entityName:"DiaryPage", pageID:uuid1, pageDate:self.titleDate, pageTitle: "Diary" , pageText:"" )
                print(flag)
                let notificationName = Notification.Name("ShowVideoAdd")
                NotificationCenter.default.post(name: notificationName, object: titleDate)
                
            }else{
                var count = CoreDataClass.returnAddCounter(entityName: "AddCounter", pageDate:titleDate)
                if((count == 100) || (count == 2)){
                    let notificationName = Notification.Name("ShowVideoAdd")
                    NotificationCenter.default.post(name: notificationName, object: titleDate)
                }else{
                    count = count+1
                    showAlertWithTwoTextFields(count: count)
                }
                
                }
            }
        }
    }
    
    @objc func soundBtnAction(button: UIButton) {
        
        let notificationName = Notification.Name("MusicViewControllerOpen")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    @objc func nextBtnAction(button: UIButton) {
        print("nextBtnAction")
        
        let notificationName = Notification.Name("NextPagePreviouePage")
        NotificationCenter.default.post(name: notificationName, object: "NextPage")
    }
    @objc func previousBtnAction(button: UIButton) {
        print("previousBtnAction")
        
        let notificationName = Notification.Name("NextPagePreviouePage")
        NotificationCenter.default.post(name: notificationName, object: "PreviouePage")
    }
    
    @objc func saveBtnAction(button: UIButton) {
        
        let tag = button.tag
        if(tag == 0){
            
            let notificationName = Notification.Name("SearchViewController")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
        }else{
            
            let count = CoreDataClass.GetLengthOfRecord(entityName:"DiaryPage", pageDate: self.titleDate)
            if(count>0){
                arrayForPageDiaryText.remove(at: currentSelectIndex)
                arrayForPageDiaryText.insert(note.text, at: currentSelectIndex)
                let flag = CoreDataClass.updateRecordFormDataBase(entityName: "DiaryPage", pageID: arrayForPageDiaryID[currentSelectIndex], pageText: note.text)
                if(flag){print("Update")}
            }else{
                
                arrayForPageDiaryText.remove(at: currentSelectIndex)
                arrayForPageDiaryText.insert(note.text, at: currentSelectIndex)
              let valu = CoreDataClass.insertAddCountDataBase(entityName: "AddCounter", pageDate:titleDate , addCounter: 100)
                print(valu)
                let flag = CoreDataClass.insertPageInDataBase(entityName:"DiaryPage", pageID:arrayForPageDiaryID[currentSelectIndex], pageDate:titleDate, pageTitle:arrayForPageDiaryTitle[currentSelectIndex] , pageText:note.text)
                if(flag){print("save")}
            }
            
            buttonForSearch.tag = 0
            button.setBackgroundImage(UIImage (named: "search.png"), for: .normal)
            view.endEditing(true)
            let notificationName = Notification.Name("KeyboardHideenUnHiddenIdentifier")
            NotificationCenter.default.post(name: notificationName, object: "unHidden")
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        note.setNeedsDisplay()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        buttonForSearch.setBackgroundImage(UIImage (named: "tick_Save.png"), for: .normal)
        buttonForSearch.tag = 1
        let notificationName = Notification.Name("KeyboardHideenUnHiddenIdentifier")
        NotificationCenter.default.post(name: notificationName, object: "hidden")
        
        let temTopSpace = (topSpace+nextPerBtnViewHight+collectionViewHight)
        let temp = (ViewController.BottomBarHight.keybordHight - ViewController.BottomBarHight.bottomBarHight)
        note.frame.size.height = (self.view.frame.size.height-(temTopSpace+temp))
        note.setNeedsDisplay()
    }//271  //253.0
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let temTopSpace = topSpace+nextPerBtnViewHight+collectionViewHight+imageCollectionViewHight
        note.frame.size.height = (self.view.frame.size.height-(temTopSpace))
        note.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnDelete(_ sender: Any) {
        
        if(buttonForSearch.tag == 0){
            let tag = (sender as AnyObject).tag
            print(tag!)
            showActionSheet(message: "" , tag:tag!)
        }
    }
    
    // MARK: - CollectionView Delegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if( collectionView == self.imageCollectionView){
            return arrayForImageDiaryID.count
            
        }else{
            return arrayForPageDiaryTitle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if( collectionView == self.imageCollectionView){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            let imageURL = self.arrayForImageDiaryImagePath[indexPath.row]
            let image    = UIImage(contentsOfFile: imageURL.path)
            cell.imageForCell.image = image
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddDiaryCollectionViewCell", for: indexPath) as! AddDiaryCollectionViewCell
            cell.outletBtnDelete.tag = indexPath.item
            cell.labelForText.text = self.arrayForPageDiaryTitle[indexPath.item]
            
            if(currentSelectIndex == indexPath.item){
                cell.imageForBackground.image = UIImage.init(named: "Cell_img.png")
            }else{
                cell.imageForBackground.image = UIImage.init(named: "Cell_img_sele.png")
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if( collectionView == self.imageCollectionView){
            
            print("selected")
            let imageRUL = self.arrayForImageDiaryImagePath[indexPath.item]
            let notificationName = Notification.Name("ImageViewIdentifier")
            NotificationCenter.default.post(name: notificationName, object: imageRUL)
        }else{
            
            currentSelectIndex = indexPath.item
            note.text = arrayForPageDiaryText[currentSelectIndex]
            self.collectionView.reloadData()
            print(indexPath.item)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if( collectionView == self.imageCollectionView){
            
            let screenHeigh: CGFloat = (self.imageCollectionView.frame.size.height)
            let imageScreenwidth: CGFloat = (self.imageCollectionView.frame.size.height*1.3)
            
            let size = CGSize(width: imageScreenwidth, height: screenHeigh)
            return size
            
        }else{
            
            let screenWidth: CGFloat
            if ( UIDevice.current.model.range(of: "iPad") != nil){
                print("I AM IPAD")
                 screenWidth = (self.collectionView.frame.size.width/5)
            } else {
                screenWidth = (self.collectionView.frame.size.width/2.2)
                print("I AM IPHONE")
            }

            let screenHeigh: CGFloat = (self.collectionView.frame.size.height/1.2)
            
            let size = CGSize(width: screenWidth, height: CGFloat(screenHeigh))
            return size
            
        }
    }
    
    
    
    
    func showActionSheet( message:String, tag:Int) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message:nil , preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        let deleteActionButton = UIAlertAction(title: "Delete", style: .destructive)
        { _ in
            print("Delate")
            if(self.arrayForPageDiaryTitle.count == 1){
                
                let flag = CoreDataClass.DeleteRecordFormDataBase(entityName: "DiaryPage", pageID: self.arrayForPageDiaryID[tag])
                print("deleted")
                if(flag){
                    self.arrayForPageDiaryID.remove(at: tag)
                    self.arrayForPageDiaryTitle.remove(at: tag)
                    self.arrayForPageDiaryText.remove(at: tag)
                    let uuid = NSUUID().uuidString
                    self.arrayForPageDiaryID.append(uuid)
                    self.arrayForPageDiaryTitle.append("Diary")
                    self.arrayForPageDiaryText.append("")
                    self.note.text = ""
                    self.currentSelectIndex = 0
                    self.collectionView.reloadData()
                }
            }else{
                
                let flag  = CoreDataClass.DeleteRecordFormDataBase(entityName: "DiaryPage", pageID: self.arrayForPageDiaryID[tag])
                
                if(flag){
                    if(self.currentSelectIndex == 0){}else{self.currentSelectIndex = self.currentSelectIndex-1}
                    self.arrayForPageDiaryID.remove(at: tag)
                    self.arrayForPageDiaryTitle.remove(at: tag)
                    self.arrayForPageDiaryText.remove(at: tag)
                    self.note.text = self.arrayForPageDiaryText[self.currentSelectIndex]
                    self.collectionView.reloadData()
                }
            }
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func showAlertWithTwoTextFields(count:Int) {
        
        let alertController = UIAlertController(title:nil , message: "Enter Page Name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let eventNameTextField = alertController.textFields![0] as UITextField
            
            if eventNameTextField.text != ""{
                let valu1 = CoreDataClass.updateAddCounterInDataBase(entityName: "AddCounter", pageDate:self.titleDate , addCounter: count)
                print(valu1)
                self.insertData(titleText:eventNameTextField.text!)
            }else{
                print("is empty")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.text = "New page"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func insertData(titleText:String ) {
        
        //eventNameTextField.text!
        let uuid = NSUUID().uuidString
        let flag = CoreDataClass.insertPageInDataBase(entityName:"DiaryPage", pageID:uuid, pageDate:self.titleDate, pageTitle: titleText , pageText:"" )
        if(flag){
            print(titleText)
            
            self.arrayForPageDiaryID .append(uuid)
            self.arrayForPageDiaryTitle .append(titleText)
            self.arrayForPageDiaryText .append("")
            self.collectionView.reloadData()
        }
    }
}


/*
 func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
 print("scrollViewWillEndDragging")
 //        let notificationName = Notification.Name("isUserInteractionEnabled")
 //        NotificationCenter.default.post(name: notificationName, object: "hidden")
 }
 func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
 print("scrollViewWillBeginDecelerating")
 
 }
 func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
 print("scrollViewDidEndDecelerating")
 //        let notificationName = Notification.Name("isUserInteractionEnabled")
 //        NotificationCenter.default.post(name: notificationName, object: "unHidden")
 }
 
 */
