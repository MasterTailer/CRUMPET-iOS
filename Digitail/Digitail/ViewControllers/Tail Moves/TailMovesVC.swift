//
//  TailMovesVC.swift
//  Digitail
//
//  Created by Iottive on 11/06/19.
//  Copyright © 2019 Iottive. All rights reserved.
//

import UIKit
import JTMaterialSpinner
import CoreBluetooth
import SideMenu

class TailMovesVC: UIViewController{
   
    //MARK: - Properties
    @IBOutlet weak var viewTailMovesDesc: UIView!
    @IBOutlet weak var viewFindGetTail: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewActivityIndicator: JTMaterialSpinner!
    @IBOutlet weak var lblSearchingForDigitail: UILabel!
    @IBOutlet weak var lblDigitailDesc: UILabel!
    @IBOutlet weak var btnCntOrLookForDigitail: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var viewMoves: UIView!
    var indexPathForOpr : Int!

    
    let arrTailMoves = ["TAILS1","TAILS2","TAILS3","TAILFA","TAILSH","TAILHA","TAILER","TAILEP","TAILT1","TAILT2","TAILET"]
    
    let arrHomePosition = ["Slow wag 1","Slow wag 2","Slow wag 3","FAst wag","SHort wag","HAppy wag","ERect","Erect Pulse","Tremble 1","Tremble 2","Erect Trem"]
    
    
     //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainUI()
        //Register for Bluetooth State Updates
        RegisterForNote(#selector(TailMovesVC.DeviceIsReady(_:)),kDeviceIsReady, self)
        RegisterForNote(#selector(TailMovesVC.DeviceDisconnected(_:)),kDeviceDisconnected, self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateConnectionUI()
    }

    func updateConnectionUI() {
        let deviceActor = AppDelegate_.digitailDeviceActor
        if (deviceActor?.peripheralActor != nil && (deviceActor?.isConnected())!) {
            self.viewFindGetTail.isHidden = true
            self.viewTailMovesDesc.isHidden = false
            self.viewMoves.isHidden = false
        } else {
            self.viewActivityIndicator.isHidden = true
            self.btnCntOrLookForDigitail.isHidden = false
            self.btnCntOrLookForDigitail.setTitle("CONNECT", for: .normal)
            self.lblSearchingForDigitail.text = kOneTailFound
            self.lblDigitailDesc.text = kNotConnected
            self.viewFindGetTail.isHidden = true
            self.viewTailMovesDesc.isHidden = false
            self.viewMoves.isHidden = false
        }
    }
    
    //MARK: - Custome Function
    func setUpMainUI(){
        btnMenu.layer.cornerRadius = 5.0

        viewActivityIndicator.circleLayer.lineWidth = 3.0
        viewActivityIndicator.circleLayer.strokeColor = UIColor(red: 96/255, green: 125/255, blue: 138/255, alpha: 1.0).cgColor
        viewActivityIndicator.beginRefreshing()

        viewMoves.isHidden = true
        
        viewFindGetTail.layer.shadowColor = UIColor.darkGray.cgColor
        viewFindGetTail.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        viewFindGetTail.layer.shadowRadius = 2.5
        viewFindGetTail.layer.shadowOpacity = 0.5
        
        viewTailMovesDesc.layer.shadowColor = UIColor.darkGray.cgColor
        viewTailMovesDesc.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        viewTailMovesDesc.layer.shadowRadius = 1.7
        viewTailMovesDesc.layer.shadowOpacity = 0.5
        
        viewTailMovesDesc.isHidden = true
        btnCntOrLookForDigitail.isHidden = true
        
        btnStop.layer.cornerRadius = btnStop.frame.height/2.0
        btnStop.clipsToBounds = true
        
        if AppDelegate_.isScanning == true {
            self.viewActivityIndicator.isHidden = false
            self.viewActivityIndicator.beginRefreshing()
            self.btnCntOrLookForDigitail.isHidden = true
            self.lblSearchingForDigitail.text = kSearchingForDigitail
            self.lblDigitailDesc.text = kNoneFoundYet
        }
        else{
            self.btnCntOrLookForDigitail.setTitle("LOOK FOR TAILS", for: .normal)
            self.lblSearchingForDigitail.text = kNoTailsFound
          //  self.lblDigitailDesc.text = "We were unable to find any tails.Please ensure that it is nearby and Switched on."
             self.lblDigitailDesc.text = "We were unable to find your Tail. Please ensure that it is nearby and switched on"
            btnCntOrLookForDigitail.isHidden = false
            self.viewActivityIndicator.isHidden = true
        }
    }
    
    func showBluetoothAlert() {
        let alert = UIAlertController(title: kBlueoothOnTitle, message: kBlueoothOnMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(kAlertActionOK, comment: "Default action"), style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString(kAlertActionSettings, comment: "Default action"), style: .default, handler: { _ in
            if let url = URL(string:UIApplication.openSettingsURLString)
            {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Start Scan Method
    func startScan() {
        AppDelegate_.startScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if AppDelegate_.peripheralList.count == 0 {
                self.viewActivityIndicator.isHidden = true
                self.btnCntOrLookForDigitail.isHidden = false
                self.btnCntOrLookForDigitail.setTitle("LOOK FOR TAILS", for: .normal)
                self.lblSearchingForDigitail.text = kNoTailsFound
                self.lblDigitailDesc.text = "We were unable to find your Tail. Please ensure that it is nearby and switched on"
                self.viewFindGetTail.isHidden = false
                self.viewTailMovesDesc.isHidden = true
                self.viewMoves.isHidden = true
            }
            else{
                self.viewActivityIndicator.isHidden = true
                self.btnCntOrLookForDigitail.isHidden = false
                self.btnCntOrLookForDigitail.setTitle("CONNECT", for: .normal)
                self.lblSearchingForDigitail.text = kOneTailFound
                self.lblDigitailDesc.text = kNotConnected
                self.viewFindGetTail.isHidden = true
                self.viewTailMovesDesc.isHidden = false
                self.viewMoves.isHidden = false
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func Menu_clicked(_ sender: UIButton) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func moveClicked(_ sender: UIButton) {
        let deviceActor = AppDelegate_.digitailDeviceActor
        if (deviceActor != nil && (deviceActor?.isDeviceIsReady)! && (deviceActor?.isConnected())!) {
            let tailMoveString = arrTailMoves[sender.tag]
            let data = Data(tailMoveString.utf8)
            deviceActor?.performCommand(Constants.kCommand_SendData, withParams:NSMutableDictionary.init(dictionary: [Constants.kCharacteristic_WriteData : [Constants.kData:data]]));
        }
    }
    

    @IBAction func ConnectLookForDigitail_Clicked(_ sender: UIButton) {
        if AppDelegate_.peripheralList.count == 0 {
            self.viewActivityIndicator.isHidden = false
            self.viewActivityIndicator.beginRefreshing()
            btnCntOrLookForDigitail.isHidden = true
            self.lblSearchingForDigitail.text = kSearchingForDigitail
            self.lblDigitailDesc.text = kNoneFoundYet
            AppDelegate_.isScanning = true
            self.startScan()
        }
        else {
            connectDevice(device: AppDelegate_.peripheralList.first!)
            self.viewActivityIndicator.isHidden = false
            self.viewActivityIndicator.beginRefreshing()
            self.lblSearchingForDigitail.text = kOneTailAvailble
            self.lblDigitailDesc.text = kNotConnected
        }
    }
   
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    @objc func DeviceIsReady(_ note: Notification) {
        let actor = note.object as! BLEActor
        self.viewActivityIndicator.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateConnectionUI()
        }
    }
    
    @objc func DeviceDisconnected(_ note: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateConnectionUI()
        }
    }
    
    func connectDevice(device: DeviceModel) {
        self.view.bringSubviewToFront(viewActivityIndicator)
        self.viewActivityIndicator.isHidden = false
        AppDelegate_.centralManagerActor.add(device.peripheral)
    }
    
}

     
