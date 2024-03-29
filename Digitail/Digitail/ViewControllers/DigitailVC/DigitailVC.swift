//
//  DigitailVC.swift
//  Digitail
//
//  Created by Iottive on 07/06/19.
//  Copyright © 2019 Iottive. All rights reserved.
//

import UIKit
import JTMaterialSpinner
import CoreBluetooth
import SideMenu
import AVFoundation
import AVKit
import RangeSeekSlider
import SOMotionDetector
import UserNotifications

let kWalkModeDate = "WalkModeDate"
let kWalkModeStart = "TAILS1"
let kWalkModeStop = "TAILHM"
let kListenENDCommand = "ENDLISTEN"
let kListenIOSCommand = "LISTEN IOS"
let kTiltENDCommand = "ENDTILTMODE"
let kTiltStartCommand = "TILTMODE START"
let kEndCasualCommand = "ENDCASUAL"
let kAutoModeStopAutoCommand = "STOPAUTO"
let kWalkModeOff = NSLocalizedString("kWalkModeOff", comment: "")
let kWalkModeOn = NSLocalizedString("kWalkModeOn", comment: "")
let kWalkMode = NSLocalizedString("kWalkMode", comment: "")
let kCasualModeOff = NSLocalizedString("kCasualModeOff", comment: "")
let kListenModeON = NSLocalizedString("kListenModeON", comment: "")
let kListenModeOFF = NSLocalizedString("kListenModeOFF", comment: "")
let kTiltModeON = NSLocalizedString("kTiltModeON", comment: "")
let kTiltModeOFF = NSLocalizedString("kTiltModeOFF", comment: "")
let kVersionCommand = "VERA"
let kBatteryCommand = "BATT"

let kBlueoothOnTitle =  NSLocalizedString("kBlueoothOnTitle", comment: "")
let kBlueoothOnMsg = NSLocalizedString("kBlueoothOnMsg", comment: "")
let kAlertActionOK = NSLocalizedString("kOk", comment: "")
let kAlertActionSettings = NSLocalizedString("kSettings", comment: "")
let kTitleConnect = NSLocalizedString("kTitleConnect", comment: "")
let kMsgConnect = NSLocalizedString("kMsgConnect", comment: "")
let kShutDownCommand = NSLocalizedString("kShutDownCommand", comment: "")
let kMoves = NSLocalizedString("kMoves", comment: "")
let kMovesFlutter = NSLocalizedString("kMovesFlutter", comment: "")
let kMovesMinitail = NSLocalizedString("kMovesMinitail", comment: "")
let kGlowTips = NSLocalizedString("kGlowTipsTitle", comment: "")
let kCasualMode = NSLocalizedString("kCasualMode", comment: "")
//let kWalkModeTitle = NSLocalizedString("kWalkMode", comment: "")
let kListenMode = NSLocalizedString("kListen Mode", comment: "")
let kEarGearPoses = NSLocalizedString("kEarGearPoses", comment: "")
let kTiltMode = NSLocalizedString("kTiltMode", comment: "")
let kGlowTipsTitle = NSLocalizedString("kGlowTipsTitle", comment: "")

let kDeviceInfoCellHeight : CGFloat = 42.0
class DigitailVC: UIViewController,RangeSeekSliderDelegate, UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Properties
    @IBOutlet weak var btnAlarm: UIButton!
    @IBOutlet weak var btnGlowTips: UIButton!
    @IBOutlet weak var btnTailMoves: UIButton!
    
    @IBOutlet weak var btnListenMode: UIButton!
    @IBOutlet weak var btnEarMoves: UIButton!
    
    @IBOutlet var btnCausualMode: UIButton!
    @IBOutlet var btnWalkMode: UIButton!
    
    @IBOutlet var viewTailBattery: UIView!
    
    @IBOutlet var imgViewBatteryStatus: UIImageView!
    @IBOutlet weak var btnConnectDigitail: UIButton!
    
    @IBOutlet weak var LayConsts_VwConnectedDeviceHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_ConnectedDevices: UIView!
    @IBOutlet weak var vw_ConnectDevice: UIView!
    @IBOutlet weak var LayConsts_VwConnectedDeviceTop: NSLayoutConstraint!
    @IBOutlet weak var tblVwConnectedDeviceList: ContentSizedTableView!
    @IBOutlet weak var tblVwActions: UITableView!
    @IBOutlet weak var tblVw_Devicelist: UITableView!
    
    @IBOutlet weak var lblSearchingForGear: UILabel!
    @IBOutlet weak var viewActivityIndicator: JTMaterialSpinner!
    
    @IBOutlet weak var btnLookForTails: UIButton!
    @IBOutlet weak var lblGearFoundMessage: UILabel!
    @IBOutlet var btnConnectDisconnect: UIButton!
    
    var isMoving = false
    var isWalkModeON = false
    var isListenModeON = false
    var isTiltModeON = false
    var batteryTimerMitail = Timer()
    var batteryTimerEarGear = Timer()
    var batteryTimerFlutter = Timer()
    var batteryTimerMinitail = Timer()
    var arrSections  = ["TAIL BATTERY","EARGEAR BATTERY", "FLUTTER BATTERY", "MINITAIL BATTERY"]
    var statusOfLocation = 0
    var glowTipRemoved = false
    
    var generalMenuList = [kCasualMode, kWalkMode]
    
    var mitailMenuList = [kMoves, kGlowTips]
    var earGearMenuList = [kEarGearPoses, kListenMode]
    var earGear2MenuList = [kEarGearPoses, kListenMode, kTiltMode]
    var flutterMenuList = [kMovesFlutter]
    var minitailMenuList = [kMovesMinitail]
    
//    var arrDigitailList = [kMoves,kGlowTips,kCasualMode,kWalkModeTitle]
//    var arrFlutterList = [kMoves,kCasualMode,kWalkModeTitle]
//    var arrEarGearList = [kEarGearPoses,kListenMode,kCasualMode, kWalkModeTitle]
//    var arrEarGear2List = [kEarGearPoses,kListenMode,kTiltMode,kCasualMode, kWalkModeTitle]
//    var arrBothList = [kMoves,kGlowTipsTitle,kEarGearPoses,kListenMode,kCasualMode, kWalkModeTitle]
//    var arrAllList = [kMoves,kGlowTipsTitle,kEarGearPoses,kListenMode,kTiltMode,kCasualMode, kWalkModeTitle]
    
    var arrMenuList = [String]()
    var arrMenuImages = [kMoves:"TailMoves",kGlowTipsTitle:"GlowTips",kCasualMode:"Casulal ModeSetting","Casual Mode Settings":"Settings",kWalkMode:"movelist",kEarGearPoses:"TailMoves",kListenMode:"filter",kTiltMode:"filter", kMovesFlutter: "TailMoves", kMovesMinitail: "MinitailMoves"]
    
    //MARK: - View Life Cycle -
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = NSLocalizedString("kCrumpetTitle", comment: "")
        setUpTableUI()
        //setUpMainUI()
        //Register for Bluetooth State Updates
        RegisterForNote(#selector(DigitailVC.DeviceIsReady(_:)),kDeviceIsReady, self)
        RegisterForNote(#selector(DigitailVC.DeviceDisconnected(_:)),kDeviceDisconnected, self)
        RegisterForNote(#selector(self.DeviceDidUpdateProperty(_:)), kDeviceDidUpdateProperty, self)
        RegisterForNote(#selector(self.refreshHome(_:)), kDeviceModeRefreshNotification, self)
        RegisterForNote(#selector(DigitailVC.locationSettingsUpdated(note:)), LOCATION_AUTHORIZATION_STATUS_CHANGED_NOTIFICATION, self)
        
        setMotionCallBacks()
        
        
        self.navigationController?.navigationBar.tintColor = .black
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startScan()
        }
        
    }
    
    
    func startScan() {
        AppDelegate_.startScan()
        if (AppDelegate_.digitailPeripheral == nil) || (AppDelegate_.eargearPeripheral == nil) || (AppDelegate_.flutterPeripheral == nil || AppDelegate_.minitailPeripheral == nil) {
           AppDelegate_.isScanning = true
       }
        self.lblSearchingForGear.text = NSLocalizedString("kSearchingForGear", comment: "")
        self.lblGearFoundMessage.text = NSLocalizedString("kNoneFoundYet", comment: "")
        self.btnLookForTails.isHidden = true
        self.viewActivityIndicator.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.viewActivityIndicator.endRefreshing()
            self.btnLookForTails.isHidden = false
            
            var isDigitailAvailable = false
            var isEarGearAvailable = false
            var isFlutterAvailable = false
            var isMinitailAvailable = false
            
            if AppDelegate_.tempDigitailPeripheral.count > 0 {
                isDigitailAvailable = true
            }
            
            if AppDelegate_.tempeargearPeripheral.count > 0 {
                isEarGearAvailable = true
            }
            
            if AppDelegate_.tempFlutterPeripheral.count > 0 {
                isFlutterAvailable = true
            }
            
            if AppDelegate_.tempMinitailPeripheral.count > 0 {
                isMinitailAvailable = true
            }
            
            if (isDigitailAvailable && isEarGearAvailable && isFlutterAvailable && isMinitailAvailable) 
                || (isDigitailAvailable && isEarGearAvailable && isFlutterAvailable)
                || (isDigitailAvailable && isFlutterAvailable && isMinitailAvailable)
                || (isDigitailAvailable && isEarGearAvailable && isMinitailAvailable)
                || (isEarGearAvailable && isFlutterAvailable && isMinitailAvailable)
                || (isDigitailAvailable && isEarGearAvailable)
                || (isDigitailAvailable && isFlutterAvailable)
                || (isDigitailAvailable && isMinitailAvailable)
                || (isEarGearAvailable && isFlutterAvailable)
                || (isEarGearAvailable && isMinitailAvailable)
                || (isFlutterAvailable && isMinitailAvailable)
                
            {
                self.lblGearFoundMessage.text = NSLocalizedString("kFoundGear", comment: "")
                self.btnLookForTails.setTitle( NSLocalizedString("kShowGear", comment: ""), for: .normal)
            } else if AppDelegate_.tempDigitailPeripheral.count > 1 || AppDelegate_.tempeargearPeripheral.count > 1 || AppDelegate_.tempFlutterPeripheral.count > 1 || AppDelegate_.tempMinitailPeripheral.count > 1{
                self.lblGearFoundMessage.text =  NSLocalizedString("kFoundGear", comment: "")
                self.btnLookForTails.setTitle(NSLocalizedString("kShowGear", comment: ""), for: .normal)
            } else if AppDelegate_.tempDigitailPeripheral.count == 1 || AppDelegate_.tempeargearPeripheral.count == 1 || AppDelegate_.tempFlutterPeripheral.count == 1 || AppDelegate_.tempMinitailPeripheral.count == 1{
                self.lblGearFoundMessage.text =  NSLocalizedString("kGearFoundMessage", comment: "")
                self.btnLookForTails.setTitle(NSLocalizedString("kConnecttoGear", comment: ""), for: .normal)
            } else {
                self.lblSearchingForGear.text = NSLocalizedString("kNoGearFound", comment: "")
                self.lblGearFoundMessage.text =  NSLocalizedString("kUnableToFindGear", comment: "")
                self.btnLookForTails.setTitle( NSLocalizedString("kLookforGear", comment: ""), for: .normal)
            }
            
//           if AppDelegate_.tempDigitailPeripheral.count > 1 ||  AppDelegate_.tempeargearPeripheral.count > 1 ||  AppDelegate_.tempFlutterPeripheral.count > 1 || (AppDelegate_.tempDigitailPeripheral.count == 1 && AppDelegate_.tempeargearPeripheral.count == 1 && AppDelegate_.tempFlutterPeripheral.count == 1) {
//                self.lblGearFoundMessage.text = NSLocalizedString("kFoundGear", comment: "")
//               self.btnLookForTails.setTitle( NSLocalizedString("kShowGear", comment: ""), for: .normal)
//            } else if AppDelegate_.tempDigitailPeripheral.count == 1 || AppDelegate_.tempeargearPeripheral.count == 1 || AppDelegate_.tempFlutterPeripheral.count == 1{
//                self.lblGearFoundMessage.text =  NSLocalizedString("kGearFoundMessage", comment: "")
//                self.btnLookForTails.setTitle(NSLocalizedString("kConnecttoGear", comment: ""), for: .normal)
//            } else {
//                self.lblSearchingForGear.text = NSLocalizedString("kNoGearFound", comment: "")
//                self.lblGearFoundMessage.text =  NSLocalizedString("kUnableToFindGear", comment: "")
//                self.btnLookForTails.setTitle( NSLocalizedString("kLookforGear", comment: ""), for: .normal)
//            }
        }
    }
    
    
    @IBAction func disconnectDevice(_ sender: UIButton) {
        
        if isDIGITAiLConnected() || isEARGEARConnected() || isFlutterConnected() || isMinitailConnected(){
            let alert = UIAlertController(title: NSLocalizedString("kDisconnect?", comment: ""), message: NSLocalizedString("kDisconnectMessage", comment: ""), preferredStyle: UIAlertController.Style.alert)
            //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("kDisconnectTitle", comment: ""), style: .default, handler:{ (UIAlertAction) in
                self.disconnectAllDevices()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("kShutDownGear", comment: ""), style: .default, handler:{ (UIAlertAction) in
                self.shutDownAllDevices()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("kCancel", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
                
    }
    
    func disconnectAllDevices() {
        for connectedDevice in AppDelegate_.tempEargearDeviceActor {
            let deviceActor = connectedDevice
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(deviceActor.peripheralActor.peripheral!)
            }
        }
        
        for connectedDevices in AppDelegate_.tempDigitailDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(deviceActor.peripheralActor.peripheral!)
            }
            
        }
        
        for connectedDevices in AppDelegate_.tempFlutterDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(deviceActor.peripheralActor.peripheral!)
            }
        }
        
        for connectedDevices in AppDelegate_.tempMinitailDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(deviceActor.peripheralActor.peripheral!)
            }
        }
        
        AppDelegate_.tempDigitailPeripheral.removeAll()
        AppDelegate_.tempDigitailDeviceActor.removeAll()
        
        AppDelegate_.tempeargearPeripheral.removeAll()
        AppDelegate_.tempEargearDeviceActor.removeAll()
        
        AppDelegate_.tempFlutterPeripheral.removeAll()
        AppDelegate_.tempFlutterDeviceActor.removeAll()
        
        AppDelegate_.tempMinitailPeripheral.removeAll()
        AppDelegate_.tempMinitailDeviceActor.removeAll()
        
        AppDelegate_.deviceActors.removeAll()
        
    }
    
    func shutDownAllDevices() {
        for connectedDevice in AppDelegate_.tempEargearDeviceActor {
            let deviceActor = connectedDevice
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                let tailMoveString = NSLocalizedString("kShutDownCommand", comment: "")
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
        
        for connectedDevices in AppDelegate_.tempDigitailDeviceActor {
            let deviceActor = connectedDevices
            
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                let tailMoveString = NSLocalizedString("kShutDownCommand", comment: "")
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
        
        for connectedDevices in AppDelegate_.tempFlutterDeviceActor {
            let deviceActor = connectedDevices
            
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                let tailMoveString = NSLocalizedString("kShutDownCommand", comment: "")
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
        
        for connectedDevices in AppDelegate_.tempMinitailDeviceActor {
            let deviceActor = connectedDevices
            
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                let tailMoveString = NSLocalizedString("kShutDownCommand", comment: "")
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
        
        AppDelegate_.tempDigitailPeripheral.removeAll()
        AppDelegate_.tempDigitailDeviceActor.removeAll()
        
        AppDelegate_.tempeargearPeripheral.removeAll()
        AppDelegate_.tempEargearDeviceActor.removeAll()
        
        AppDelegate_.tempFlutterPeripheral.removeAll()
        AppDelegate_.tempFlutterDeviceActor.removeAll()
        
        AppDelegate_.tempMinitailPeripheral.removeAll()
        AppDelegate_.tempMinitailDeviceActor.removeAll()
        
        AppDelegate_.deviceActors.removeAll()
    }
    

    @IBAction func searchAction(_ sender: UIButton) {
        if self.btnLookForTails.titleLabel?.text == NSLocalizedString("kShowAvailableGear", comment: ""){
            let DeviceListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeviceListVC") as? DeviceListVC
            self.present(DeviceListVC!, animated: true) {
                
            }
        } else if self.btnLookForTails.titleLabel?.text ==  NSLocalizedString("kConnecttoGear", comment: "") {
            self.lblSearchingForGear.text = NSLocalizedString("kConnectingwithGear", comment: "")
            self.lblGearFoundMessage.text = NSLocalizedString("kPleaseWait", comment: "")
            autoConnectToDevice()
        } else if self.btnLookForTails.titleLabel?.text ==  NSLocalizedString("kLookforGear", comment: "") {
            self.startScan()
        }
    }
    
    func autoConnectToDevice() {
        if AppDelegate_.tempDigitailPeripheral.count == 1 {
            let selectedPeripharal = AppDelegate_.tempDigitailPeripheral[0]
            AppDelegate_.centralManagerActor.add(selectedPeripharal.peripheral)
        } else if (AppDelegate_.tempeargearPeripheral.count == 1) {
            let selectedPeripharalEargear = AppDelegate_.tempeargearPeripheral[0]
            AppDelegate_.centralManagerActor.add(selectedPeripharalEargear.peripheral)
        } else if (AppDelegate_.tempFlutterPeripheral.count == 1) {
            let selectedPeripharalEargear = AppDelegate_.tempFlutterPeripheral[0]
            AppDelegate_.centralManagerActor.add(selectedPeripharalEargear.peripheral)
        } else if (AppDelegate_.tempMinitailPeripheral.count == 1) {
            let selectedPeripharalEargear = AppDelegate_.tempMinitailPeripheral[0]
            AppDelegate_.centralManagerActor.add(selectedPeripharalEargear.peripheral)
        }
    }
    
    func sendNotification(string: String) {
        let content = UNMutableNotificationContent()
        content.title = string
        content.subtitle = NSLocalizedString("kActivity", comment: "")
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.viewTailDesciption.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        updateConnectionUI()
        tblVwConnectedDeviceList.reloadData()

    }
    
    func setMotionCallBacks () {
        SOMotionDetector.sharedInstance()?.useM7IfAvailable = true
        SOLocationManager.sharedInstance()?.allowsBackgroundLocationUpdates = true
        SOLocationManager.sharedInstance()?.locationType = LocationManagerTypeNone
        SOMotionDetector.sharedInstance()?.motionTypeChangedBlock = { motionType in
            if motionType == MotionTypeWalking || motionType == MotionTypeRunning {
                print("Walking or Running")
                self.isMoving = true
            } else if motionType == MotionTypeNotMoving {
                print("Not moving")
                self.isMoving = false
            }
        }
        SOMotionDetector.sharedInstance()?.locationChangedBlock = { location in
            print("Locationn \(location)")
            if self.isWalkModeON {
                let commandSentDate = UserDefaults.standard.object(forKey: kWalkModeDate)
                if self.isMoving && commandSentDate == nil {
                    UserDefaults.standard.setValue(Date(), forKey: kWalkModeDate)
                    self.walkModeCommand(command: kWalkModeStart)
                } else if self.isMoving && (commandSentDate != nil) {
                    let dateOfLastCommand = commandSentDate as! Date
                    let elapsed = Date().timeIntervalSince(dateOfLastCommand)
                    if elapsed > 12 {
                        UserDefaults.standard.setValue(Date(), forKey: kWalkModeDate)
                        self.walkModeCommand(command: kWalkModeStart)
                    }
                } else if self.isMoving == false {
                    if (commandSentDate != nil) {
                        let dateOfLastCommand = commandSentDate as! Date
                        let elapsed = Date().timeIntervalSince(dateOfLastCommand)
                        if elapsed > 12 {
                            UserDefaults.standard.removeObject(forKey: kWalkModeDate)
                            self.walkModeCommand(command: kWalkModeStop)
                        }
                    }
                }
            }
        }
    }
    
    func updateConnectionUI() {
        if isDIGITAiLConnected() || isEARGEARConnected() || isFlutterConnected() || isMinitailConnected() {
            self.vw_ConnectDevice.isHidden = true
            self.tblVwActions.isHidden = false
        } else {
            self.vw_ConnectDevice.isHidden = false
            self.tblVwActions.isHidden = true
        }
        
        self.arrMenuList.removeAll()
        if isDIGITAiLConnected() {
            self.arrMenuList.append(contentsOf: mitailMenuList)
        }
        
//        if isEARGEARConnected() {
//            self.arrMenuList.append(contentsOf: earGearMenuList)
//        }
        
        if isEARGEAR2Connected() {
            self.arrMenuList.append(contentsOf: earGear2MenuList)
        }
        
        if isFlutterConnected() {
            self.arrMenuList.append(contentsOf: flutterMenuList)
        }
        
        if isMinitailConnected() {
            self.arrMenuList.append(contentsOf: minitailMenuList)
        }
        
        self.arrMenuList.append(contentsOf: generalMenuList)
//
//        if isDIGITAiLConnected() && isEARGEARConnected() && isEARGEAR2Connected() && isFlutterConnected() {
//            self.arrMenuList = self.arrAllList
//        } else if isDIGITAiLConnected() && isEARGEARConnected() && !isEARGEAR2Connected() && !isFlutterConnected() {
//            self.arrMenuList = self.arrBothList
//        } else if isDIGITAiLConnected() {
//            self.arrMenuList = self.arrDigitailList
//        } else if isEARGEAR2Connected() {
//            self.arrMenuList = self.arrEarGear2List
//        } else if isEARGEARConnected() {
//            self.arrMenuList = self.arrEarGearList
//        } else if isFlutterConnected() {
//            self.arrMenuList = self.arrFlutterList
//        }
        
        if isEARGEARConnected() || isEARGEAR2Connected() {
            var isCFirmware = false
            for connectedDevice in AppDelegate_.tempEargearDeviceActor {
                if let firmware = connectedDevice.state["FirmwareVersion"] as? String, firmware.lowercased().hasSuffix("c") {
                    isCFirmware = true
                    break
                }
            }
            
            if isCFirmware {
                if let listenModeIndex = self.arrMenuList.firstIndex(of: kListenMode) {
                    self.arrMenuList.remove(at: listenModeIndex)
                }
            }
        }
        
        if glowTipRemoved {
            self.arrMenuList.removeAll { $0 == kGlowTipsTitle }
        }
        self.tblVwActions.reloadData()
        setUpConnectedDevicesList()
        
        
    }
    
    func startAutoScroll() {
        let numberOfSections = tblVwConnectedDeviceList.numberOfSections
        let numberOfRows = tblVwConnectedDeviceList.numberOfRows(inSection: numberOfSections - 1)

        let indexPath = NSIndexPath(row: numberOfRows, section: numberOfSections)
        self.tblVwConnectedDeviceList.scrollToRow(at: indexPath as IndexPath,
                                          at: UITableView.ScrollPosition.middle, animated: true)
    }
    
    func isDIGITAiLConnected() -> Bool {
        var isConnected = Bool()
        for connectedDevices in AppDelegate_.tempDigitailDeviceActor {
            if (connectedDevices.peripheralActor != nil && (connectedDevices.isConnected())) {
                isConnected = true
                break
            } else {
                isConnected = false
            }
        }
    
        return isConnected
        
//        if AppDelegate_.digitailDeviceActor != nil && (AppDelegate_.digitailDeviceActor?.peripheralActor != nil && (AppDelegate_.digitailDeviceActor?.isConnected())!) {
//            return true
//        } else {
//            return false
//        }
    }
    
    func isFlutterConnected() -> Bool {
        var isConnected = Bool()
        for connectedDevices in AppDelegate_.tempFlutterDeviceActor {
            if (connectedDevices.peripheralActor != nil && (connectedDevices.isConnected())) {
                isConnected = true
                break
            } else {
                isConnected = false
            }
        }
    
        return isConnected
        
//        if AppDelegate_.digitailDeviceActor != nil && (AppDelegate_.digitailDeviceActor?.peripheralActor != nil && (AppDelegate_.digitailDeviceActor?.isConnected())!) {
//            return true
//        } else {
//            return false
//        }
    }
    
    func isMinitailConnected() -> Bool {
        var isConnected = Bool()
        for connectedDevices in AppDelegate_.tempMinitailDeviceActor {
            if (connectedDevices.peripheralActor != nil && (connectedDevices.isConnected())) {
                isConnected = true
                break
            } else {
                isConnected = false
            }
        }
    
        return isConnected
        
//        if AppDelegate_.digitailDeviceActor != nil && (AppDelegate_.digitailDeviceActor?.peripheralActor != nil && (AppDelegate_.digitailDeviceActor?.isConnected())!) {
//            return true
//        } else {
//            return false
//        }
    }
    
    func isEARGEARConnected() -> Bool {
//        if AppDelegate_.eargearDeviceActor != nil && (AppDelegate_.eargearDeviceActor?.peripheralActor != nil && (AppDelegate_.eargearDeviceActor?.isConnected())!) {
//            return true
//        } else {
//            return false
//        }
        
        var isConnected = Bool()
        for connectedDevices in AppDelegate_.tempEargearDeviceActor {
            if (connectedDevices.peripheralActor != nil && (connectedDevices.isConnected())) {
                isConnected = true
                break
            } else {
                isConnected = false
            }
        }
    
        return isConnected
    }
    
    func isEARGEAR2Connected() -> Bool {
//        if AppDelegate_.eargearDeviceActor != nil && (AppDelegate_.eargearDeviceActor?.peripheralActor != nil && (AppDelegate_.eargearDeviceActor?.isConnected())!) {
//            return true
//        } else {
//            return false
//        }
        
        var isConnected = Bool()
        for connectedDevices in AppDelegate_.tempEargearDeviceActor {
            if (connectedDevices.peripheralActor != nil && (connectedDevices.isConnected())) {
                if connectedDevices.bleDeviceType == .eg2 {
                    isConnected = true
                    break
                }
            } else {
                isConnected = false
            }
        }
    
        return isConnected
    }
    
    
    func setUpConnectedDevicesList() {
        LayConsts_VwConnectedDeviceHeight.constant = 0
        LayConsts_VwConnectedDeviceTop.constant = 13
        
        if AppDelegate_.tempDigitailDeviceActor.count > 0 || AppDelegate_.tempEargearDeviceActor.count > 0 || AppDelegate_.tempFlutterDeviceActor.count > 0 || AppDelegate_.tempMinitailDeviceActor.count > 0 {
            
            let totalDeviceCount = CGFloat(AppDelegate_.tempDigitailDeviceActor.count + AppDelegate_.tempEargearDeviceActor.count + AppDelegate_.tempFlutterDeviceActor.count + AppDelegate_.tempMinitailDeviceActor.count)
            
            LayConsts_VwConnectedDeviceHeight.constant = CGFloat(kDeviceInfoCellHeight * totalDeviceCount)
        }
        
//
//        if AppDelegate_.tempDigitailDeviceActor.count > 0 {
//            LayConsts_VwConnectedDeviceHeight.constant = 40
//        }
//        if AppDelegate_.tempEargearDeviceActor.count > 0 {
//            LayConsts_VwConnectedDeviceHeight.constant = 40
//        }
//        if AppDelegate_.tempFlutterDeviceActor.count > 0 {
//            LayConsts_VwConnectedDeviceHeight.constant = 40
//        }
//        if AppDelegate_.tempDigitailDeviceActor.count > 0 && AppDelegate_.tempEargearDeviceActor.count > 0 && AppDelegate_.tempFlutterDeviceActor.count > 0 {
//            LayConsts_VwConnectedDeviceHeight.constant = 90
//        } else {
//
//            if AppDelegate_.tempDigitailDeviceActor.count > 0 && AppDelegate_.tempEargearDeviceActor.count > 0 {
//                LayConsts_VwConnectedDeviceHeight.constant = 60
//            }
//
//            if AppDelegate_.tempDigitailDeviceActor.count > 0 && AppDelegate_.tempFlutterDeviceActor.count > 0 {
//                LayConsts_VwConnectedDeviceHeight.constant = 60
//            }
//
//            if AppDelegate_.tempEargearDeviceActor.count > 0 && AppDelegate_.tempFlutterDeviceActor.count > 0 {
//                LayConsts_VwConnectedDeviceHeight.constant = 60
//            }
//        }
        
        
        self.view.layoutIfNeeded()
        
        checkConnectionStatusOfDevices()
    }
    
    func checkConnectionStatusOfDevices() {
        if AppDelegate_.tempDigitailDeviceActor.count > 0 {
            var status = Bool()
            for peripharals in AppDelegate_.tempDigitailDeviceActor {
                let objPeripharal:CBPeripheral = peripharals.peripheralActor.peripheral!
                if objPeripharal.state == .connected {
                    status = true
                    break
                } else {
                    status = false
                }
            }
            
            if status == false {
                if AppDelegate_.tempEargearDeviceActor.count > 0 || AppDelegate_.tempFlutterDeviceActor.count > 0 || AppDelegate_.tempMinitailDeviceActor.count > 0 {
                    LayConsts_VwConnectedDeviceHeight.constant = 60
                    LayConsts_VwConnectedDeviceTop.constant = 13
                } else {
                    LayConsts_VwConnectedDeviceHeight.constant = 0
                    LayConsts_VwConnectedDeviceTop.constant = 13
                }
            }
        }
        
        if AppDelegate_.tempEargearDeviceActor.count > 0 {
            var status = Bool()
            for peripharals in AppDelegate_.tempEargearDeviceActor {
                let objPeripharal:CBPeripheral = peripharals.peripheralActor.peripheral!
                if objPeripharal.state == .connected {
                    status = true
                    break
                } else {
                    status = false
                }
            }
            
            if status == false {
                if AppDelegate_.tempDigitailDeviceActor.count > 0  || AppDelegate_.tempFlutterDeviceActor.count > 0 || AppDelegate_.tempMinitailDeviceActor.count > 0{
                    LayConsts_VwConnectedDeviceHeight.constant = 60
                    LayConsts_VwConnectedDeviceTop.constant = 13
                } else {
                    LayConsts_VwConnectedDeviceHeight.constant = 0
                    LayConsts_VwConnectedDeviceTop.constant = 13
                }
            }
        }
        
        if AppDelegate_.tempFlutterDeviceActor.count > 0 {
            var status = Bool()
            for peripharals in AppDelegate_.tempFlutterDeviceActor {
                let objPeripharal:CBPeripheral = peripharals.peripheralActor.peripheral!
                if objPeripharal.state == .connected {
                    status = true
                    break
                } else {
                    status = false
                }
            }
            
            if status == false {
                if AppDelegate_.tempDigitailDeviceActor.count > 0 || AppDelegate_.tempEargearDeviceActor.count > 0 || AppDelegate_.tempMinitailDeviceActor.count > 0 {
                    LayConsts_VwConnectedDeviceHeight.constant = 60
                    LayConsts_VwConnectedDeviceTop.constant = 13
                } else {
                    LayConsts_VwConnectedDeviceHeight.constant = 0
                    LayConsts_VwConnectedDeviceTop.constant = 13
                }
            }
        }
        
        if AppDelegate_.tempMinitailDeviceActor.count > 0 {
            var status = Bool()
            for peripharals in AppDelegate_.tempMinitailDeviceActor {
                let objPeripharal:CBPeripheral = peripharals.peripheralActor.peripheral!
                if objPeripharal.state == .connected {
                    status = true
                    break
                } else {
                    status = false
                }
            }
            
            if status == false {
                if AppDelegate_.tempDigitailDeviceActor.count > 0 || AppDelegate_.tempEargearDeviceActor.count > 0 || AppDelegate_.tempFlutterDeviceActor.count > 0{
                    LayConsts_VwConnectedDeviceHeight.constant = 60
                    LayConsts_VwConnectedDeviceTop.constant = 13
                } else {
                    LayConsts_VwConnectedDeviceHeight.constant = 0
                    LayConsts_VwConnectedDeviceTop.constant = 13
                }
            }
        }
        
        if !isDIGITAiLConnected() && !isEARGEARConnected() && !isFlutterConnected() && !isMinitailConnected(){
            LayConsts_VwConnectedDeviceHeight.constant = 0
            LayConsts_VwConnectedDeviceTop.constant = 13
        }
        tblVwConnectedDeviceList.reloadData()
    }
    
    @IBAction func EarGearMoves_Clicked(_ sender: UIButton) {
        if self.isEARGEARConnected() {
            let deviceName = AppDelegate_.tempEargearDeviceActor[0].state[Constants.kDeviceName] as? String
            if deviceName == "EarGear" {
                let eargearMovesVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EarGear2MovesVC") as? EarGear2MovesVC
                self.navigationController?.pushViewController(eargearMovesVC!, animated: true)
            } else {
                let eargearMovesVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EarGearMovesVC") as? EarGearMovesVC
                self.navigationController?.pushViewController(eargearMovesVC!, animated: true)
            }
            
        } else {
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
    }
    
    @IBAction func ListenMode_Clicked(_ sender: UIButton) {
        if self.isEARGEARConnected() {
            if isListenModeON {
                sendListenModeCommand(command: kListenENDCommand)
                isListenModeON = false
            } else {
               sendListenModeCommand(command: kListenIOSCommand)
                isListenModeON = true
            }
            self.tblVwActions.reloadData()
        } else {
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
    }
    
    @IBAction func TiltMode_Clicked(_ sender: UIButton) {
        if self.isEARGEAR2Connected() {
            if isTiltModeON {
                sendListenModeCommand(command: kTiltENDCommand)
                isTiltModeON = false
            } else {
               sendListenModeCommand(command: kTiltStartCommand)
                isTiltModeON = true
            }
            self.tblVwActions.reloadData()
        } else {
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
    }
    
    func setUpTableUI() {
//        tblVwActions.layer.masksToBounds = false
//        tblVwActions.clipsToBounds = false
//        tblVwActions.layer.shadowColor = UIColor.darkGray.cgColor
//        tblVwActions.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        tblVwActions.layer.shadowRadius = 2.5
//        tblVwActions.layer.shadowOpacity = 0.5
//        tblVwActions.layer.cornerRadius = 3
        
        vw_ConnectDevice.layer.masksToBounds = false
        vw_ConnectDevice.clipsToBounds = false
        vw_ConnectDevice.layer.shadowColor = UIColor.darkGray.cgColor
        vw_ConnectDevice.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        vw_ConnectDevice.layer.shadowRadius = 2.5
        vw_ConnectDevice.layer.shadowOpacity = 0.5
        vw_ConnectDevice.layer.cornerRadius = 3
        
    }

    //MARK: - Custome Function
    func setUpMainUI(){
        btnAlarm.layer.shadowColor = UIColor.darkGray.cgColor
        btnAlarm.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnAlarm.layer.shadowRadius = 2.5
        btnAlarm.layer.shadowOpacity = 0.5
        
        /*
        btnMoveList.layer.shadowColor = UIColor.darkGray.cgColor
        btnMoveList.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnMoveList.layer.shadowRadius = 2.5
        btnMoveList.layer.shadowOpacity = 0.5
        
        btnTailPoses.layer.shadowColor = UIColor.darkGray.cgColor
        btnTailPoses.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnTailPoses.layer.shadowRadius = 2.5
        btnTailPoses.layer.shadowOpacity = 0.5
 */
        
        btnGlowTips.layer.shadowColor = UIColor.darkGray.cgColor
        btnGlowTips.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnGlowTips.layer.shadowRadius = 2.5
        btnGlowTips.layer.shadowOpacity = 0.5
        
        btnTailMoves.layer.shadowColor = UIColor.darkGray.cgColor
        btnTailMoves.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnTailMoves.layer.shadowRadius = 2.5
        btnTailMoves.layer.shadowOpacity = 0.5
        
        btnCausualMode.layer.shadowColor = UIColor.darkGray.cgColor
        btnCausualMode.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnCausualMode.layer.shadowRadius = 2.5
        btnCausualMode.layer.shadowOpacity = 0.5
        
        viewTailBattery.layer.shadowColor = UIColor.darkGray.cgColor
        viewTailBattery.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        viewTailBattery.layer.shadowRadius = 2.5
        viewTailBattery.layer.shadowOpacity = 0.5
        
        btnEarMoves.layer.shadowColor = UIColor.darkGray.cgColor
        btnEarMoves.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnEarMoves.layer.shadowRadius = 2.5
        btnEarMoves.layer.shadowOpacity = 0.5
        
        btnListenMode.layer.shadowColor = UIColor.darkGray.cgColor
        btnListenMode.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnListenMode.layer.shadowRadius = 2.5
        btnListenMode.layer.shadowOpacity = 0.5
        
        btnWalkMode.layer.shadowColor = UIColor.darkGray.cgColor
        btnWalkMode.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnWalkMode.layer.shadowRadius = 2.5
        btnWalkMode.layer.shadowOpacity = 0.5
        
        
    }
    
    @IBAction func actionConnectDigitail(_ sender: UIButton) {
//        let connectVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConnectVC") as? ConnectVC
//        connectVC?.isForDigitail = true
//        self.navigationController?.pushViewController(connectVC!, animated: true)
        
        let DeviceListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeviceListVC") as? DeviceListVC
        self.navigationController?.pushViewController(DeviceListVC!, animated: true)
    }
    
    @IBAction func actionConnectEarGear(_ sender: UIButton) {
//        let connectVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConnectVC") as? ConnectVC
//        connectVC?.isForDigitail = false
//        self.navigationController?.pushViewController(connectVC!, animated: true)
        
        let DeviceListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeviceListVC") as? DeviceListVC
        self.navigationController?.pushViewController(DeviceListVC!, animated: true)
    }
    
    func RemoveBatteryStatus(){
        
    }
    
    func AddBatteryStatus(){
        
    }
    
    //MARK: - Actions
    @IBAction func Alarm_Clicked(_ sender: UIButton) {
        let alarmsVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AlarmsVC") as? AlarmsVC
        self.navigationController?.pushViewController(alarmsVC!, animated: true)
    }
    @IBAction func MoveList_Clicked(_ sender: UIButton) {
        if self.isDIGITAiLConnected() || self.isFlutterConnected() || self.isMinitailConnected(){
            let moveListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MoveListsVC") as? MoveListsVC
            self.navigationController?.pushViewController(moveListVC!, animated: true)
        } else {
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
         
    }
    
   
    @IBAction func TailPoses_Clicked(_ sender: UIButton) {
        let alert = UIAlertController(title:  NSLocalizedString("kTailPoses", comment: ""), message: NSLocalizedString("kComingSoon", comment: ""), preferredStyle: UIAlertController.Style.alert)
        //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: kAlertActionOK, style: .default, handler:{ (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
            ///print("User click Ok button")
        }))
        self.present(alert, animated: true, completion: nil)
//        let tailPosesVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TailPosesVC") as? TailPosesVC
//        self.navigationController?.pushViewController(tailPosesVC!, animated: true)
    }
    
    @IBAction func GlowTips_Clicked(_ sender: UIButton) {
        let glowTipsVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GlowTipsVC") as? GlowTipsVC
        if self.isDIGITAiLConnected() || self.isFlutterConnected() || self.isMinitailConnected() {
            self.navigationController?.pushViewController(glowTipsVC!, animated: true)
        } else {
            //showAlert(title: kTitleConnect, msg: kMsgConnect)
        }
        
    }
    
    @IBAction func Menu_Clicked(_ sender: UIButton) {
       // navigationController?.popToRootViewController(animated: true)

        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    
    @IBAction func CasualMode_Clicked(_ sender: UIButton) {
        if AppDelegate_.casualONDigitail || AppDelegate_.casualONEarGear || AppDelegate_.casualONFlutter || AppDelegate_.casualONMinitail {
            if self.isEARGEARConnected() && AppDelegate_.casualONEarGear {
                AppDelegate_.casualONEarGear = false
//                let deviceActor = AppDelegate_.eargearDeviceActor
                for connectedDevice in AppDelegate_.tempEargearDeviceActor {
                    let deviceActor = connectedDevice
                    if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                        let tailMoveString = kEndCasualCommand
                        let data = Data(tailMoveString.utf8)
                        deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                    }
                }
            }
            if self.isDIGITAiLConnected() && AppDelegate_.casualONDigitail {
                AppDelegate_.casualONDigitail = false
//                let deviceActor = AppDelegate_.digitailDeviceActor
                
                for connectedDevices in AppDelegate_.tempDigitailDeviceActor {
                    let deviceActor = connectedDevices
                    
                    if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                        let tailMoveString = kAutoModeStopAutoCommand
                        let data = Data(tailMoveString.utf8)
                        deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                    }
                }
            }
            if self.isFlutterConnected() && AppDelegate_.casualONFlutter {
                AppDelegate_.casualONFlutter = false
//                let deviceActor = AppDelegate_.digitailDeviceActor
                
                for connectedDevices in AppDelegate_.tempFlutterDeviceActor {
                    let deviceActor = connectedDevices
                    
                    if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                        let tailMoveString = kAutoModeStopAutoCommand
                        let data = Data(tailMoveString.utf8)
                        deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                    }
                }
            }
            
            if self.isMinitailConnected() && AppDelegate_.casualONMinitail {
                AppDelegate_.casualONMinitail = false
//                let deviceActor = AppDelegate_.digitailDeviceActor
                
                for connectedDevices in AppDelegate_.tempMinitailDeviceActor {
                    let deviceActor = connectedDevices
                    
                    if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                        let tailMoveString = kAutoModeStopAutoCommand
                        let data = Data(tailMoveString.utf8)
                        deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                    }
                }
            }
            
            self.tblVwActions.reloadData()
        } else {
            let casualModeSettingVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CasualModeSettingVC") as? CasualModeSettingVC
            self.navigationController?.pushViewController(casualModeSettingVC!, animated: true)
        }
       
    }
    
    @IBAction func actionWalkMode_Clicked(_ sender: UIButton) {
        if self.isDIGITAiLConnected() || self.isFlutterConnected() || self.isMinitailConnected() || self.isEARGEAR2Connected() {
            if #available(iOS 14.0, *) {
                if statusOfLocation == 3 {
                    if (isWalkModeON) {
                        isWalkModeON = false
                        AppDelegate_.walkModeOn = false
                        stopMotionDetection()
                    } else {
                        isWalkModeON = true
                        AppDelegate_.walkModeOn = true
                        startMotionDetection()
                        showAlert(title:NSLocalizedString("kLocationPermission", comment: ""), msg: NSLocalizedString("kAllowBackgroundPermission", comment: ""))
                    }
                } else {
                    askUserAlwaysPermission()
                }
            } else {
                if (isWalkModeON) {
                    isWalkModeON = false
                    AppDelegate_.walkModeOn = false
                    stopMotionDetection()
                } else {
                    isWalkModeON = true
                    AppDelegate_.walkModeOn = true
                    startMotionDetection()
                }
            }
            self.tblVwActions.reloadData()
        } else {
            isWalkModeON = true
            AppDelegate_.walkModeOn = true
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
    }
    
    @objc func locationSettingsUpdated(note: Notification) {
        if let status = note.userInfo?["status"] {
            print("status \(status)")
            statusOfLocation = (status as AnyObject).integerValue
        }
    }
    func askUserAlwaysPermission() {
        let alertController = UIAlertController.init(title: NSLocalizedString("kLocationPermission", comment: ""), message: NSLocalizedString("kPleaseAlwaysAllowLOcation", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: kAlertActionOK, style: .default, handler: { action in
                //redirect to setting screen for enable bluetooth or location permision
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    func walkModeCommand(command: String) {
        if self.isDIGITAiLConnected() {
            for connectedDevices in AppDelegate_.tempDigitailDeviceActor {
                let deviceActor = connectedDevices
                if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                    let tailMoveString = command
                    let data = Data(tailMoveString.utf8)
                    deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                }
            }
        }
        
        if self.isFlutterConnected() {
            for connectedDevices in AppDelegate_.tempFlutterDeviceActor {
                let deviceActor = connectedDevices
                if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                    let tailMoveString = command
                    let data = Data(tailMoveString.utf8)
                    deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                }
            }
        }
        
        if self.isMinitailConnected() {
            for connectedDevices in AppDelegate_.tempMinitailDeviceActor {
                let deviceActor = connectedDevices
                if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                    let tailMoveString = command
                    let data = Data(tailMoveString.utf8)
                    deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                }
            }
        }
        
        if self.isEARGEAR2Connected() {
            for connectedDevices in AppDelegate_.tempEargearDeviceActor {
                let deviceActor = connectedDevices
                if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                    let tailMoveString = command
                    let data = Data(tailMoveString.utf8)
                    deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                }
            }
        }
    }
    
    @IBAction func TailMoves_Clicked(_ sender: UIButton) {
        let tailMovesVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TailMovesVC") as? TailMovesVC
        
        if self.isDIGITAiLConnected(){
            self.navigationController?.pushViewController(tailMovesVC!, animated: true)
        } else {
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
        
    }
    
    @IBAction func FlutterTailMoves_Clicked(_ sender: UIButton) {
        let tailMovesVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FlutterTailMovesVC") as? FlutterTailMovesVC
        
        if self.isFlutterConnected() {
            self.navigationController?.pushViewController(tailMovesVC!, animated: true)
        } else {
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
        
    }
    
    @IBAction func MiniTailMoves_Clicked(_ sender: UIButton) {
        let tailMovesVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MiniTailMovesVC") as? MiniTailMovesVC
        
        if self.isMinitailConnected() {
            self.navigationController?.pushViewController(tailMovesVC!, animated: true)
        } else {
            showAlert(title:  NSLocalizedString("kTitleConnect", comment: ""), msg: NSLocalizedString("kMsgConnect", comment: ""))
        }
        
    }
    
    @IBAction func devieInfoClicked(_ sender: Any) {
        if let button = (sender as? UIButton) {
            if let cell = button.superview?.superview?.superview as? TblVw_ConnectedDeviceLIst_Cell {
                print("battery clicked - \(button.tag)")
                var firmwareVersion = ""
                if cell.tag == 0 {
                    if let version = AppDelegate_.tempDigitailDeviceActor[button.tag].state["FirmwareVersion"] {
                        firmwareVersion = version as! String
                    }
                } else if cell.tag == 1 {
                    if let version = AppDelegate_.tempEargearDeviceActor[button.tag].state["FirmwareVersion"] {
                        firmwareVersion = version as! String
                    }
                    
                } else if cell.tag == 2{
                    if let version = AppDelegate_.tempFlutterDeviceActor[button.tag].state["FirmwareVersion"] {
                        firmwareVersion = version as! String
                    }
                    
                } else {
                    if let version = AppDelegate_.tempMinitailDeviceActor[button.tag].state["FirmwareVersion"] {
                        firmwareVersion = version as! String
                    }
                    
                }
                
                showAlert(title: NSLocalizedString("kCurrentFirmwareVersion", comment: ""), msg: firmwareVersion)
            }
        }
    }
    
    var tField: UITextField!
    
    @IBAction func editDeviceClicked(_ sender: Any) {
        if let button = (sender as? UIButton) {
            if let cell = button.superview?.superview?.superview as? TblVw_ConnectedDeviceLIst_Cell {
                
                print(cell.tag) // which section
                print(button.tag) // which array
                
                var alert = UIAlertController(title: "Rename your gear?", message: "", preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: configurationTextField)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ [weak self] (UIAlertAction) in
                    guard let weakSelf = self else { return }
                    if let name = weakSelf.tField.text, !name.isBlank {
                        print("\(name)")
                        
                        switch (cell.tag) {
                        case 0:
                            let oneDevice = AppDelegate_.tempDigitailDeviceActor[button.tag]
                            
                            if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == oneDevice.peripheralActor.peripheral?.identifier.uuidString }).first {
                                weakSelf.updateName(deviceInfo: localStoredDevice, name: name)
                            }
                            
                        case 1:
                            let oneDevice = AppDelegate_.tempEargearDeviceActor[button.tag]
                            if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == oneDevice.peripheralActor.peripheral?.identifier.uuidString }).first {
                                weakSelf.updateName(deviceInfo: localStoredDevice, name: name)
                            }
                        case 2:
                            let oneDevice =  AppDelegate_.tempFlutterDeviceActor[button.tag]
                            if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == oneDevice.peripheralActor.peripheral?.identifier.uuidString }).first {
                                weakSelf.updateName(deviceInfo: localStoredDevice, name: name)
                            }
                        case 3:
                            let oneDevice =  AppDelegate_.tempMinitailDeviceActor[button.tag]
                            if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == oneDevice.peripheralActor.peripheral?.identifier.uuidString }).first {
                                weakSelf.updateName(deviceInfo: localStoredDevice, name: name)
                            }
                        default:
                            print("\(name)")
                        }
                        
                    }
                }))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
            }

        }
    }

    func updateName(deviceInfo: DeviceInfo, name: String) {
        try! AppDelegate_.realm.write {
            deviceInfo.name = name
            AppDelegate_.realm.add(deviceInfo, update: .modified)
        }
        tblVwConnectedDeviceList.reloadData()
    }
    
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter an item"
        tField = textField
    }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    //MARK: - TableView Delegate Methods -
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblVwActions {
            return 1
        }
        
        return 4
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwActions {
            return arrMenuList.count
        } else {
            switch (section) {
            case 0:
                return AppDelegate_.tempDigitailDeviceActor.count
            case 1:
                return AppDelegate_.tempEargearDeviceActor.count
            case 2:
                return AppDelegate_.tempFlutterDeviceActor.count
            case 3:
                return AppDelegate_.tempMinitailDeviceActor.count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwActions {
            return 60
        } else {
            if indexPath.section == 0 && self.isDIGITAiLConnected() {
                return kDeviceInfoCellHeight
            } else if indexPath.section == 1 && self.isEARGEARConnected() {
                return kDeviceInfoCellHeight
            } else if indexPath.section == 2 && self.isFlutterConnected() {
                return kDeviceInfoCellHeight
            }  else if indexPath.section == 3 && self.isMinitailConnected() {
                return kDeviceInfoCellHeight
            } else {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwActions {
            print("tblVwAction clicked - \(indexPath.row)")
            let cell = tableView.cellForRow(at: indexPath)
            
            let actionName = arrMenuList[indexPath.row]
             switch actionName {
             case kMoves :
                 TailMoves_Clicked(self.btnLookForTails)
                 break
             case kGlowTipsTitle :
                 GlowTips_Clicked(self.btnLookForTails)
                 break
             case kEarGearPoses :
                 EarGearMoves_Clicked(self.btnLookForTails)
                 break
             case kListenMode :
//                 ListenMode_Clicked(self.btnLookForTails)
                 break
             case kTiltMode :
//                 TiltMode_Clicked(self.btnLookForTails)
                 break
             case kCasualMode :
                 CasualMode_Clicked(self.btnLookForTails)
                 break
             case "Casual Mode Settings" :
                 CasualMode_Clicked(self.btnLookForTails)
                 break
             case kWalkMode :
//                 actionWalkMode_Clicked(self.btnLookForTails)
                 break
             case kMovesFlutter:
                 FlutterTailMoves_Clicked(self.btnLookForTails)
             case kMovesMinitail:
                 MiniTailMoves_Clicked(self.btnLookForTails)
             default:
                 break
             }
        } else {
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwActions {
            let cell = tblVwActions.dequeueReusableCell(withIdentifier: "TblCellSideMenu", for: indexPath) as! TblCellSideMenu
            cell.lblMenuName.text = arrMenuList[indexPath.row]
            
            cell.accessoryType = .disclosureIndicator
            cell.modeSwitch.isHidden = true
            if arrMenuList[indexPath.row] == kWalkMode {                
                
                if AppDelegate_.casualONDigitail || AppDelegate_.casualONFlutter || AppDelegate_.moveOn || AppDelegate_.casualONMinitail {
                    cell.isUserInteractionEnabled = false
                    cell.alpha = 0.5
                } else {
                    cell.isUserInteractionEnabled = true
                    cell.alpha = 1.0
                }
                cell.accessoryType = .none
                cell.modeSwitch.isHidden = false
                cell.modeSwitch.isOn = isWalkModeON
                cell.lblMenuName.text = isWalkModeON ? kWalkModeOn : kWalkModeOff
                
            }
            else if arrMenuList[indexPath.row] == kCasualMode {
                if AppDelegate_.casualONEarGear || AppDelegate_.casualONDigitail || AppDelegate_.casualONFlutter || AppDelegate_.casualONMinitail {
                    cell.lblMenuName.text = kCasualModeOff
                }
                
                if isWalkModeON || AppDelegate_.moveOn {
                    cell.isUserInteractionEnabled = false
                    cell.alpha = 0.5
                } else {
                    cell.isUserInteractionEnabled = true
                    cell.alpha = 1.0
                }
                
            } else if arrMenuList[indexPath.row] == kListenMode {
                cell.accessoryType = .none
                
                cell.modeSwitch.isHidden = false
                cell.modeSwitch.isOn = isListenModeON
                cell.lblMenuName.text = isListenModeON ? kListenModeON : kListenModeOFF
                
                cell.isUserInteractionEnabled = true
                cell.alpha = 1.0
            } else if arrMenuList[indexPath.row] == kTiltMode {
                cell.accessoryType = .none
                
                cell.modeSwitch.isHidden = false
                cell.modeSwitch.isOn = isTiltModeON
                cell.lblMenuName.text = isTiltModeON ? kTiltModeON : kTiltModeOFF
                
                cell.isUserInteractionEnabled = true
                cell.alpha = 1.0
            }  else {
                cell.isUserInteractionEnabled = true
                cell.alpha = 1.0
            }
            
            cell.changeMode = { [weak self] mode in
                guard let self = self else { return }
                if self.arrMenuList[indexPath.row] == kListenMode {
                    self.ListenMode_Clicked(self.btnLookForTails)
                } else if self.arrMenuList[indexPath.row] == kTiltMode {
                    self.TiltMode_Clicked(self.btnLookForTails)
                } else if self.arrMenuList[indexPath.row] == kWalkMode {
                    self.actionWalkMode_Clicked(self.btnLookForTails)
                }
            }
            
            let imageName = arrMenuImages[arrMenuList[indexPath.row]]
            cell.imgView.image = UIImage(named: imageName ?? "")
            cell.lblMenuName.textColor = UIColor.black
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TblVw_ConnectedDeviceLIst_Cell") as! TblVw_ConnectedDeviceLIst_Cell
            
            cell.tag = indexPath.section
            cell.btnEdit.tag = indexPath.row
            cell.btnDeviceInfo.tag = indexPath.row
            
            if indexPath.section == 0 {
               //DIGITAil DEVICE LISTS AND BATTERY STATUS --
                guard AppDelegate_.tempDigitailDeviceActor.count > 0 else {
                    return cell
                }
               
                let oneDevice = AppDelegate_.tempDigitailDeviceActor[indexPath.row]
                
               if oneDevice.peripheralActor == nil {
                   DispatchQueue.main.async {
                       cell.lblPercentage.text = ""
                   }
               } else {
                   
                   
                   let objPeripharal:CBPeripheral = (oneDevice.peripheralActor.peripheral!)
                   
                   if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == objPeripharal.identifier.uuidString }).first {
                       cell.lblDeviceName.text = localStoredDevice.name
                   } else {
                       cell.lblDeviceName.text = oneDevice.state[Constants.kDeviceName] as? String
                   }
                   
                   let batteryLevel = oneDevice.state["BatteryLevel"]
                   let batteryPercentage = oneDevice.state["BatteryPercentage"]

                   if batteryLevel != nil {
                       let battery  = (batteryLevel as! NSString).integerValue
                       DispatchQueue.main.async {
                           cell.iv_BatteryStatus.stopAnimating()
                           if battery == 0 {
                               cell.iv_BatteryStatus.animationImages = [UIImage(named: "battery_0"),UIImage(named: "battery_1")] as? [UIImage]
                               cell.iv_BatteryStatus.animationDuration = 1.0
                               cell.iv_BatteryStatus.startAnimating()
                           } else if battery == 1 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_1")
                           } else if battery == 2 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_2")
                           } else if battery == 3 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_3")
                           } else if battery == 4 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_4")
                           }
                       }
                   }
                   
                   
                   if batteryPercentage != nil {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = "\(batteryPercentage ?? "")%"
                       }
                   } else {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = ""
                       }
                   }
               }
               
            } else if indexPath.section == 1 {
               //EARGEAR DEVICE LISTS AND BATTERY STATUS --
               
                guard AppDelegate_.tempEargearDeviceActor.count > 0 else {
                    return cell
                }
                
                let oneDevice = AppDelegate_.tempEargearDeviceActor[indexPath.row]
                
               if oneDevice.peripheralActor == nil {
                   DispatchQueue.main.async {
                       cell.lblPercentage.text = ""
                   }
               } else {
                   
                   
                   
                   let objPeripharal:CBPeripheral = (oneDevice.peripheralActor.peripheral!)
                   
                   if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == objPeripharal.identifier.uuidString }).first {
                       cell.lblDeviceName.text = localStoredDevice.name
                   } else {
                       cell.lblDeviceName.text = oneDevice.state[Constants.kDeviceName] as? String
                   }
                   
                   let batteryLevel = oneDevice.state["BatteryLevel"]
                   let batteryPercentage = oneDevice.state["BatteryPercentage"]
                   print("Eargear battery :: ",batteryLevel as Any)

                   if batteryLevel != nil {
                       let battery  = (batteryLevel as! NSString).integerValue

                       DispatchQueue.main.async {
                           cell.iv_BatteryStatus.stopAnimating()
                           if battery == 0 {
                               cell.iv_BatteryStatus.animationImages = [UIImage(named: "battery_0"),UIImage(named: "battery_1")] as? [UIImage]
                               cell.iv_BatteryStatus.animationDuration = 1.0
                               cell.iv_BatteryStatus.startAnimating()
                           } else if battery == 1 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_1")
                           } else if battery == 2 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_2")
                           } else if battery == 3 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_3")
                           } else if battery == 4 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_4")
                           }
                       }
                   }
                   
                   
                   if batteryPercentage != nil {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = "\(batteryPercentage ?? "")%"
                       }
                   } else {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = ""
                       }
                   }
               }
               
           } else if indexPath.section == 2 {
               //Flutter DEVICE LISTS AND BATTERY STATUS --
               
               guard AppDelegate_.tempFlutterDeviceActor.count > 0 else {
                   return cell
               }
               
               let oneDevice = AppDelegate_.tempFlutterDeviceActor[indexPath.row]
               
               if oneDevice.peripheralActor == nil {
                   DispatchQueue.main.async {
                       cell.lblPercentage.text = ""
                   }
               } else {
                  
                   let objPeripharal:CBPeripheral = (oneDevice.peripheralActor.peripheral!)
                   
                   if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == objPeripharal.identifier.uuidString }).first {
                       cell.lblDeviceName.text = localStoredDevice.name
                   } else {
                       cell.lblDeviceName.text = oneDevice.state[Constants.kDeviceName] as? String
                   }
                   
                   let batteryLevel = oneDevice.state["BatteryLevel"]
                   let batteryPercentage = oneDevice.state["BatteryPercentage"]

                   if batteryLevel != nil {
                       let battery  = (batteryLevel as! NSString).integerValue
                       DispatchQueue.main.async {
                           cell.iv_BatteryStatus.stopAnimating()
                           if battery == 0 {
                               cell.iv_BatteryStatus.animationImages = [UIImage(named: "battery_0"),UIImage(named: "battery_1")] as? [UIImage]
                               cell.iv_BatteryStatus.animationDuration = 1.0
                               cell.iv_BatteryStatus.startAnimating()
                           } else if battery == 1 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_1")
                           } else if battery == 2 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_2")
                           } else if battery == 3 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_3")
                           } else if battery == 4 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_4")
                           }
                       }
                   }
                   
                   if batteryPercentage != nil {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = "\(batteryPercentage ?? "")%"
                       }
                   } else {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = ""
                       }
                   }
               }
               
           } else {
               //Minitail DEVICE LISTS AND BATTERY STATUS --
               
               guard AppDelegate_.tempMinitailDeviceActor.count > 0 else {
                   return cell
               }
               
               let oneDevice = AppDelegate_.tempMinitailDeviceActor[indexPath.row]
               
               if oneDevice.peripheralActor == nil {
                   DispatchQueue.main.async {
                       cell.lblPercentage.text = ""
                   }
               } else {
                   
                   let objPeripharal:CBPeripheral = (oneDevice.peripheralActor.peripheral!)
                   
                   if let localStoredDevice = Array(AppDelegate_.realm.objects(DeviceInfo.self)).filter({ $0.btIdentifier == objPeripharal.identifier.uuidString }).first {
                       cell.lblDeviceName.text = localStoredDevice.name
                   } else {
                       cell.lblDeviceName.text = oneDevice.state[Constants.kDeviceName] as? String
                   }
                   
                   let batteryLevel = oneDevice.state["BatteryLevel"]
                   let batteryPercentage = oneDevice.state["BatteryPercentage"]

                   if batteryLevel != nil {
                       let battery  = (batteryLevel as! NSString).integerValue
                       DispatchQueue.main.async {
                           cell.iv_BatteryStatus.stopAnimating()
                           if battery == 0 {
                               cell.iv_BatteryStatus.animationImages = [UIImage(named: "battery_0"),UIImage(named: "battery_1")] as? [UIImage]
                               cell.iv_BatteryStatus.animationDuration = 1.0
                               cell.iv_BatteryStatus.startAnimating()
                           } else if battery == 1 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_1")
                           } else if battery == 2 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_2")
                           } else if battery == 3 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_3")
                           } else if battery == 4 {
                               cell.iv_BatteryStatus.image = UIImage(named: "battery_4")
                           }
                       }
                   }
                   
                   if batteryPercentage != nil {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = "\(batteryPercentage ?? "")%"
                       }
                   } else {
                       DispatchQueue.main.async {
                           cell.lblPercentage.text = ""
                       }
                   }
               }
               
           }
            
            return cell
        }
    }
    
    
    //MARK:- BLE METHODS -
    
    @objc func refreshHome(_ note: Notification) {
        self.isWalkModeON = AppDelegate_.walkModeOn
        self.tblVwActions.reloadData()
    }
    
    @objc func DeviceIsReady(_ note: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateConnectionUI()
            if (self.isDIGITAiLConnected()) {
                self.sendMitailBatteryCommand()
                self.startMitailBatteryTimer()
                self.versionCommandMitail()
            }
            if (self.isEARGEARConnected()) {
                self.versionCommandEG2()
                for connectedDevice in AppDelegate_.tempEargearDeviceActor {
                    let deviceActor = connectedDevice
                    deviceActor.readProperty(Constants.kCharacteristic_BatteryLevel)
                }
            }
            if (self.isFlutterConnected()) {
                self.sendFlutterBatteryCommand()
                self.startFlutterBatteryTimer()
                self.versionCommandFlutter()
            }
            if (self.isMinitailConnected()) {
                self.sendMitailBatteryCommand()
                self.startMinitailBatteryTimer()
                self.versionCommandMinitail()
            }
        }
    }
    
    @objc func DeviceDidUpdateProperty(_ note: Notification) {
        let objActor : BLEActor = note.object as! BLEActor
        debugPrint(#function,"UpdateValue Data %@", note.userInfo!)
        let responseData = note.userInfo as! [String:Any]
        if let data = responseData["value"] as? Data {
            let str = String(decoding: data, as: UTF8.self)
            if str.lowercased().hasSuffix(" end") {
                AppDelegate_.moveOn = false
                DispatchQueue.main.async {
                    self.tblVwActions.reloadData()
                }
            }
        }
        if responseData["name"] as? String == Constants.kCharacteristic_WriteData || responseData["name"] as? String == Constants.kCharacteristic_ReadData {
            if let data = responseData["value"] as? Data {
                var str = String(decoding: data, as: UTF8.self)
                if str.contains("BAT") {
                    let val = Int.init(String(str.last!))
                    if AppDelegate_.tempDigitailDeviceActor.contains(objActor) || AppDelegate_.tempFlutterDeviceActor.contains(objActor) ||
                        AppDelegate_.tempMinitailDeviceActor.contains(objActor){ //AppDelegate_.digitailDeviceActor {
                        objActor.state.setValue("\(val ?? 0)", forKey: "BatteryLevel")
                        AppDelegate_.storeDeviceState()
                        self.tblVwConnectedDeviceList.reloadData()
//                        updateBatteryUI(imgView: self.imgViewBatteryStatus, val: val!)
                    }
                } else if str.contains("GT0") {
                    self.arrMenuList.removeAll { $0 == kGlowTipsTitle }
                    glowTipRemoved = true
                    self.tblVwActions.reloadData()
                } else if str.contains("GT1") {
                    glowTipRemoved = false
                    self.tblVwActions.reloadData()
                }
                if str.contains(".") {
                    let array = str.components(separatedBy: ".")
                    str = str.replacingOccurrences(of: "GT1", with: "")
                    str = str.replacingOccurrences(of: "GT0", with: "")
                    if array.count > 2 {
                        objActor.state.setValue(str , forKey: "FirmwareVersion")
                        AppDelegate_.storeDeviceState()
                        self.tblVwConnectedDeviceList.reloadData()
                    }
                }
                
            }
        } else if responseData["name"] as? String == Constants.kCharacteristic_BatteryLevel {
            if let data = responseData["value"] as? Data {
                var val: Int = data.withUnsafeBytes { $0.pointee }
                if AppDelegate_.tempEargearDeviceActor.contains(objActor) || AppDelegate_.tempDigitailDeviceActor.contains(objActor) || AppDelegate_.tempFlutterDeviceActor.contains(objActor) || AppDelegate_.tempMinitailDeviceActor.contains(objActor) {
                    objActor.state.setValue(val , forKey: "BatteryPercentage")
                    if val < 25 {
                        val = 1
                    } else if val < 50 {
                        val = 2
                    } else if val < 75 {
                        val = 3
                    } else  {
                        val = 4
                    }
                    
                    objActor.state.setValue("\(val)", forKey: "BatteryLevel")
                    AppDelegate_.storeDeviceState()
                    self.tblVwConnectedDeviceList.reloadData()
                }
            }
        }
    }
    

    @objc func DeviceDisconnected(_ note: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let actor = note.object as? BLEActor

            AppDelegate_.walkModeOn = false
            self.isWalkModeON = false
            AppDelegate_.casualONDigitail = false
            AppDelegate_.casualONEarGear = false
            AppDelegate_.casualONFlutter = false
            AppDelegate_.casualONMinitail = false
            AppDelegate_.moveOn = false
            AppDelegate_.casualWalkModeTimer?.invalidate()
            AppDelegate_.duration = 0
            
            
            AppDelegate_.tempDigitailDeviceActor.removeAll { actorObj in
                actorObj.peripheralActor.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            AppDelegate_.tempEargearDeviceActor.removeAll { actorObj in
                actorObj.peripheralActor.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            AppDelegate_.tempFlutterDeviceActor.removeAll { actorObj in
                actorObj.peripheralActor.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            AppDelegate_.tempMinitailDeviceActor.removeAll { actorObj in
                actorObj.peripheralActor.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            AppDelegate_.deviceActors.removeAll { actorObj in
                actorObj.peripheralActor.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            AppDelegate_.tempDigitailPeripheral.removeAll { model in
                model.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            AppDelegate_.tempeargearPeripheral.removeAll { model in
                model.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            AppDelegate_.tempFlutterPeripheral.removeAll { model in
                model.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            AppDelegate_.tempMinitailPeripheral.removeAll { model in
                model.peripheral?.identifier == actor?.peripheralActor.peripheral?.identifier
            }
            
            self.updateConnectionUI()
            if !(self.isDIGITAiLConnected()) {
                self.batteryTimerMitail.invalidate()
            }
            
            if !(self.isEARGEARConnected()) {
                self.batteryTimerEarGear.invalidate()
            }
            
            if !(self.isFlutterConnected()) {
                self.batteryTimerFlutter.invalidate()
            }
            
            if !(self.isMinitailConnected()) {
                self.batteryTimerMinitail.invalidate()
            }
            
            if !self.isDIGITAiLConnected() && !self.isEARGEARConnected() && !self.isFlutterConnected() && !self.isMinitailConnected() {
                self.startScan()
            }
        }
    }

    func startMitailBatteryTimer() {
        self.batteryTimerMitail.invalidate()
        let loopTime = 30
        self.batteryTimerMitail = Timer.scheduledTimer(timeInterval: TimeInterval(loopTime), target: self, selector:#selector(self.sendMitailBatteryCommand) , userInfo: nil, repeats: true)
    }
    
    func startFlutterBatteryTimer() {
        self.batteryTimerFlutter.invalidate()
        let loopTime = 30
        self.batteryTimerFlutter = Timer.scheduledTimer(timeInterval: TimeInterval(loopTime), target: self, selector:#selector(self.sendFlutterBatteryCommand) , userInfo: nil, repeats: true)
    }
    
    func startMinitailBatteryTimer() {
        self.batteryTimerMinitail.invalidate()
        let loopTime = 30
        self.batteryTimerMinitail = Timer.scheduledTimer(timeInterval: TimeInterval(loopTime), target: self, selector:#selector(self.sendMinitailBatteryCommand) , userInfo: nil, repeats: true)
    }
    
    func startBatteryTimerEarGear() {
        self.batteryTimerEarGear.invalidate()
        let loopTime = 30
        self.batteryTimerEarGear = Timer.scheduledTimer(timeInterval: TimeInterval(loopTime), target: self, selector:#selector(self.sendBatteryCommandEarGear) , userInfo: nil, repeats: true)
    }
    
    @objc func versionCommandMitail() {
        for connectedDevices in AppDelegate_.tempDigitailDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                let tailMoveString = kVersionCommand
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
    }
    
    @objc func versionCommandEG2() {
        for connectedDevices in AppDelegate_.tempEargearDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                let tailMoveString = kVersionCommand
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
    }
    
    @objc func versionCommandFlutter() {
        for connectedDevices in AppDelegate_.tempFlutterDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                let tailMoveString = kVersionCommand
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
    }
    
    @objc func versionCommandMinitail() {
        for connectedDevices in AppDelegate_.tempMinitailDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                let tailMoveString = kVersionCommand
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
    }
    
    @objc func sendMitailBatteryCommand() {
//        let deviceActor = AppDelegate_.digitailDeviceActor
//        if ((deviceActor!.isDeviceIsReady) && ((deviceActor?.isConnected())!)) {
        
        for connectedDevices in AppDelegate_.tempDigitailDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                if (deviceActor.bleDeviceType == .mitail) {
                    deviceActor.readProperty(Constants.kCharacteristic_BatteryLevel)
                } else {
                    let tailMoveString = kBatteryCommand
                    let data = Data(tailMoveString.utf8)
                    deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                }
            }
        }
    }
    
    @objc func sendFlutterBatteryCommand() {
//        let deviceActor = AppDelegate_.digitailDeviceActor
//        if ((deviceActor!.isDeviceIsReady) && ((deviceActor?.isConnected())!)) {
        
        for connectedDevices in AppDelegate_.tempFlutterDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                if (deviceActor.bleDeviceType == .flutter) {
                    deviceActor.readProperty(Constants.kCharacteristic_BatteryLevel)
                } else {
                    let tailMoveString = kBatteryCommand
                    let data = Data(tailMoveString.utf8)
                    deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                }
            }
        }
    }
    
    @objc func sendMinitailBatteryCommand() {
//        let deviceActor = AppDelegate_.digitailDeviceActor
//        if ((deviceActor!.isDeviceIsReady) && ((deviceActor?.isConnected())!)) {
        
        for connectedDevices in AppDelegate_.tempMinitailDeviceActor {
            let deviceActor = connectedDevices
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                if (deviceActor.bleDeviceType == .minitail) {
                    deviceActor.readProperty(Constants.kCharacteristic_BatteryLevel)
                } else {
                    let tailMoveString = kBatteryCommand
                    let data = Data(tailMoveString.utf8)
                    deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
                }
            }
        }
    }
    
    func sendListenModeCommand(command: String) {
//        let deviceActor = AppDelegate_.eargearDeviceActor
        for connectedDevice in AppDelegate_.tempEargearDeviceActor {
            let deviceActor = connectedDevice
            if ((deviceActor.isDeviceIsReady) && ((deviceActor.isConnected()))) {
                let data = Data(command.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
    }
    
    @objc func sendBatteryCommandEarGear() {
//        let deviceActor = AppDelegate_.eargearDeviceActor
        for connectedDevice in AppDelegate_.tempEargearDeviceActor {
            let deviceActor = connectedDevice
            if ((deviceActor.isDeviceIsReady) && (deviceActor.isConnected())) {
                let tailMoveString = kBatteryCommand
                let data = Data(tailMoveString.utf8)
                deviceActor.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
            }
        }
    }
    
    func showAlert(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: kAlertActionOK, style: .default, handler:{ (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
            ///print("User click Ok button")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startMotionDetection() {
        SOMotionDetector.sharedInstance()?.startDetection()
        SOLocationManager.sharedInstance()?.start()
    }
    func stopMotionDetection() {
        SOMotionDetector.sharedInstance()?.stopDetection()
        SOLocationManager.sharedInstance()?.stop()
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

    
    
    


