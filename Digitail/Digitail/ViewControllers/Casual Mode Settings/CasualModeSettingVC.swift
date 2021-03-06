//
//  CasualModeSettingVC.swift
//  Digitail
//
//  Created by Iottive on 28/06/19.
//  Copyright © 2019 Iottive. All rights reserved.
//

import UIKit
import SideMenu
import RangeSeekSlider

let kCalmAndRelaxed  = "Calm and Relaxed"
let kFastAndExcited  = "Fast and Excited"
let kFrustratedAndTense  = "Frustrated and Tense"
let kLEDPatterns  = "LED Patterns"
let kEarGearMoves  = "EarGear Poses"

let kSendToEargear = "Send To EarGear"
let kSendToTail = "Send To Tail"


class CasualModeSettingVC: UIViewController,UITableViewDelegate,UITableViewDataSource,RangeSeekSliderDelegate{
    
    //MARK: - Outlets
    @IBOutlet var viewCasualModeCatDesc: UIView!
    @IBOutlet var tblViewCasualModeCategories: UITableView!
    @IBOutlet var viewRangeSlider: RangeSeekSlider!
    @IBOutlet var lblRangeSliderLowVal: UILabel!
    @IBOutlet var lblRangeSliderUpperValue: UILabel!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var btnSendToTail: UIButton!
    
    var arrSelectedIndex =  [Int]()
    let arrCasualMode = [kCalmAndRelaxed,kFastAndExcited,kFrustratedAndTense,kEarGearMoves]
   
   
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainUI()
    }
    
    //MARK: - Custome Function
    func setUpMainUI(){
        btnSendToTail.layer.shadowColor = UIColor.darkGray.cgColor
        btnSendToTail.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnSendToTail.layer.shadowRadius = 2.5
        btnSendToTail.layer.shadowOpacity = 0.5
        
        btnMenu.layer.cornerRadius = 5.0

        tblViewCasualModeCategories.separatorInset = .zero
        tblViewCasualModeCategories.layoutMargins = .zero
        
        viewCasualModeCatDesc.layer.shadowColor = UIColor.darkGray.cgColor
        viewCasualModeCatDesc.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        viewCasualModeCatDesc.layer.shadowRadius = 2.5
        viewCasualModeCatDesc.layer.shadowOpacity = 0.5
        
      
        lblRangeSliderUpperValue.text = String(describing: viewRangeSlider.selectedMaxValue)
        lblRangeSliderLowVal.text = String(describing: viewRangeSlider.selectedMinValue)
        
        viewRangeSlider.delegate = self
        //viewRangeSlider.max
    
        /*
        viewRangeSlider.delegate = self
        viewRangeSlider.trackHighlightTintColor = UIColor(red: 96/255, green: 125/255, blue: 138/255, alpha: 1.0)
        viewRangeSlider.lowerValue = 20.0
        viewRangeSlider.upperValue = 80.0
        viewRangeSlider.lowerLabel?.isHidden = true
        viewRangeSlider.upperLabel?.isHidden = true
         */
    }
    
    func openErrorMsg() {
        let deviceActor = AppDelegate_.digitailDeviceActor
        if deviceActor?.isConnected() == nil {
              UIAlertController.alert(title:"Error", msg:"Please connect to device", target: self)
        }
        if arrSelectedIndex.count == 0 {
           UIAlertController.alert(title:"Error", msg:"Please select group", target: self)
        }
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCasualMode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TblCellCasualModeSetting", for: indexPath) as! TblCellCasualModeSetting
        cell.selectionStyle = .none
        cell.lblCasualCategoryName.text = arrCasualMode[indexPath.row]
        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self, action: #selector(CheckBox_Clicked(sender:)), for: .touchUpInside)
        if arrSelectedIndex.contains(indexPath.row) {
             cell.btnCheckBox.setImage(UIImage(named: "check-mark (2)"), for: .normal)
            cell.btnCheckBox.backgroundColor = UIColor(red: 25/255, green: 157/255, blue: 8/255, alpha: 1.0)
        } else {
            cell.btnCheckBox.backgroundColor = UIColor(red: 25/255, green: 157/255, blue: 8/255, alpha: 1.0)
               cell.btnCheckBox.setImage(nil, for: .normal)
        }
        return cell
    }
    
     //MARK: - Actions
    @IBAction func Menu_Clicked(_ sender: UIButton) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc func CheckBox_Clicked(sender: UIButton){
        if arrSelectedIndex.contains(sender.tag) {
            arrSelectedIndex.remove(at: arrSelectedIndex.index(of: sender.tag)!)
        } else {
            if sender.tag == 3 {
                arrSelectedIndex.removeAll()
            }
            arrSelectedIndex.append(sender.tag)
            if sender.tag != 3 && arrSelectedIndex.contains(3) {
                arrSelectedIndex.remove(at: arrSelectedIndex.index(of: 3)!)
            }
        }
        
        
        if arrCasualMode[sender.tag] == kEarGearMoves {
            btnSendToTail.setTitle(kSendToEargear, for: .normal)
            btnSendToTail.tag = 1
        } else {
            btnSendToTail.setTitle(kSendToTail, for: .normal)
            btnSendToTail.tag = 2
        }
        
        tblViewCasualModeCategories.reloadData()
    }
    
    @IBAction func SendToTail_Clicked(_ sender: UIButton) {
        if sender.tag == 1 {
            let deviceActor = AppDelegate_.eargearDeviceActor
            if (deviceActor != nil && (deviceActor?.isDeviceIsReady)! && (deviceActor?.isConnected())! && arrSelectedIndex.count != 0) {
                btnSendToTail.setTitle(kSendToTail, for: .normal)
                AppDelegate_.casualONEarGear = true
                sender.tag = 2
                let minTime = "\(Int(viewRangeSlider.selectedMinValue)) "
                let MaxTime = "\(Int(viewRangeSlider.selectedMaxValue))"
                var eargearString = String()
                var timeString : String?
                eargearString = "CASUAL"
                timeString = "\(eargearString) \(minTime)\(MaxTime)"
                print(timeString!)
                let data = Data(timeString!.utf8)
                
                deviceActor?.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]))
            }
        } else {
            let deviceActor = AppDelegate_.digitailDeviceActor
            if (deviceActor != nil && (deviceActor?.isDeviceIsReady)! && (deviceActor?.isConnected())! && arrSelectedIndex.count != 0) {
                btnSendToTail.setTitle(kSendToEargear, for: .normal)
                sender.tag = 1
                AppDelegate_.casualONDigitail = true
                let minTime = "T\(Int(viewRangeSlider.selectedMinValue)) "//T18
                let MaxTime = "T\(Int(viewRangeSlider.selectedMaxValue)) "//T200
                //  let totalduration = "T\(Int((viewRangeSlider.selectedMaxValue)/60))"
                let totalduration = "T240"
                var tailMoveString : String!
                var timeString : String!
                tailMoveString = "AUTOMODE"
                // tailMoveString = "AUTOMOVE \(minTime)\(MaxTime)\(totalduration)"
                timeString = " \(minTime)\(MaxTime)\(totalduration)"
                for selectedGroup in arrSelectedIndex{
                    tailMoveString.append(contentsOf:  "G\(selectedGroup+1) ")
                }
                tailMoveString.append(contentsOf: timeString)
                print(tailMoveString!)
                let data = Data(tailMoveString!.utf8)
                deviceActor?.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                //                } while dataSendCount < (data.count)
                UIAlertController.alert(title:"", msg:"Casual mode on", target: self)
            }
            else{
                openErrorMsg()
            }
        }
    }
    
     func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        let sliderLowerValue = Int((slider.selectedMinValue))
        let sliderUpperValue = Int((slider.selectedMaxValue))
        lblRangeSliderLowVal.text = "\(sliderLowerValue)"
        lblRangeSliderUpperValue.text = "\(sliderUpperValue)"
    }
    
    /*
    func sliderValueChanged(slider: NHRangeSlider?) {
        let sliderLowerValue = Int((slider?.lowerValue)!)
        let sliderUpperValue = Int((slider?.upperValue)!)
        lblRangeSliderLowVal.text = "\(sliderLowerValue)"
        lblRangeSliderUpperValue.text = "\(sliderUpperValue)"
       // let dblval = Double(i)
    }*/
    
    //Navigation hide Show according to  TableView scrolling
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
//            // it's going up
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        } else {
//            // it's going down
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//    }
}
