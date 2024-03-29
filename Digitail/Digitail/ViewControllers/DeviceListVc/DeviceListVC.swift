//
//  DeviceListVC.swift
//  CRUMPET
//
//  Created by Bhavik Patel on 05/03/21.
//  Copyright © 2021 Iottive. All rights reserved.
//

import UIKit
import SideMenu
import CoreBluetooth

class DeviceListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblVw_Devicelist: UITableView!
    @IBOutlet weak var connectAllButton: UIButton!
    
    var connectedAll = false
    
    //MARK:- LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register for Bluetooth State Updates
        RegisterForNote(#selector(self.DeviceIsReady(_:)),kDeviceIsReady, self)
        RegisterForNote(#selector(self.DeviceDisconnected(_:)),kDeviceDisconnected, self)

        self.title = kConnectGear
        self.tblVw_Devicelist.reloadData()
       
        connectAllButton.isHidden = AppDelegate_.tempDigitailPeripheral.count + AppDelegate_.tempeargearPeripheral.count + AppDelegate_.tempFlutterPeripheral.count + AppDelegate_.tempMinitailPeripheral.count == 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    //MARK:- CUSTOM METHODS -
    //Start Scan Method
    func startScan() {
        AppDelegate_.startScan()
        
        if (AppDelegate_.digitailPeripheral == nil) || (AppDelegate_.eargearPeripheral == nil) || (AppDelegate_.flutterPeripheral == nil) || (AppDelegate_.minitailPeripheral == nil) {
           AppDelegate_.isScanning = true
       }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.tblVw_Devicelist.reloadData()
        }
    }
    
    //MARK: - TableView Delegate Methods -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if AppDelegate_.tempDigitailPeripheral.count > 0 {
                return AppDelegate_.tempDigitailPeripheral.count
            } else {
                return 0
            }
        } else if section == 1 {
            if AppDelegate_.tempeargearPeripheral.count > 0 {
                return AppDelegate_.tempeargearPeripheral.count
            }  else {
                return 0
            }
        }  else if section == 2 {
            if AppDelegate_.tempFlutterPeripheral.count > 0 {
                return AppDelegate_.tempFlutterPeripheral.count
            }  else {
                return 0
            }
        }   else if section == 3 {
            if AppDelegate_.tempMinitailPeripheral.count > 0 {
                return AppDelegate_.tempMinitailPeripheral.count
            }  else {
                return 0
            }
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //DISCONNECTED DEVICE LIST --
        let deviceListCell = tableView.dequeueReusableCell(withIdentifier: "TblVw_DeviceList_Cell") as! TblVw_DeviceList_Cell
        deviceListCell.btnConnect.tag = indexPath.row
        deviceListCell.btnConnect.addTarget(self, action: #selector(Connect_Clicked(sender:)), for: .touchUpInside)
        
        if indexPath.section == 0 {
            let objPeripharal:CBPeripheral = AppDelegate_.tempDigitailPeripheral[indexPath.row].peripheral
//            deviceListCell.lblDeviceUuid.text = AppDelegate_.tempDigitailPeripheral[indexPath.row].peripheral.identifier.uuidString
            deviceListCell.lblDeviceName.text = AppDelegate_.tempDigitailPeripheral[indexPath.row].deviceName

            if objPeripharal.state == .connected {
                deviceListCell.btnConnect?.setTitle("DISCONNECT", for: .normal)
            } else {
                deviceListCell.btnConnect?.setTitle("Connect", for: .normal)
            }

        } else if indexPath.section == 1 {
            let objPeripharal:CBPeripheral = AppDelegate_.tempeargearPeripheral[indexPath.row].peripheral

//            deviceListCell.lblDeviceUuid.text = AppDelegate_.tempeargearPeripheral[indexPath.row].peripheral.identifier.uuidString
            deviceListCell.lblDeviceName.text = AppDelegate_.tempeargearPeripheral[indexPath.row].deviceName

            if objPeripharal.state == .connected {
                deviceListCell.btnConnect?.setTitle("DISCONNECT", for: .normal)
            } else {
                deviceListCell.btnConnect?.setTitle("Connect", for: .normal)
            }
        }  else if indexPath.section == 2{
            // Flutter
            let objPeripharal:CBPeripheral = AppDelegate_.tempFlutterPeripheral[indexPath.row].peripheral

//            deviceListCell.lblDeviceUuid.text = AppDelegate_.tempFlutterPeripheral[indexPath.row].peripheral.identifier.uuidString
            deviceListCell.lblDeviceName.text = AppDelegate_.tempFlutterPeripheral[indexPath.row].deviceName

            if objPeripharal.state == .connected {
                deviceListCell.btnConnect?.setTitle("DISCONNECT", for: .normal)
            } else {
                deviceListCell.btnConnect?.setTitle("Connect", for: .normal)
            }
        }  else {
            // Minitail
            let objPeripharal:CBPeripheral = AppDelegate_.tempMinitailPeripheral[indexPath.row].peripheral

//            deviceListCell.lblDeviceUuid.text = AppDelegate_.tempFlutterPeripheral[indexPath.row].peripheral.identifier.uuidString
            deviceListCell.lblDeviceName.text = AppDelegate_.tempMinitailPeripheral[indexPath.row].deviceName

            if objPeripharal.state == .connected {
                deviceListCell.btnConnect?.setTitle("DISCONNECT", for: .normal)
            } else {
                deviceListCell.btnConnect?.setTitle("Connect", for: .normal)
            }
        }
        return deviceListCell
        
    }
    
    @IBAction func onConnectAll(_ sender: Any) {
        connectedAll.toggle()
        
        if connectedAll {
            for digital in AppDelegate_.tempDigitailPeripheral {
                if digital.peripheral.state == .disconnected {
                    connectDevice(device: digital)
                }
            }
            
            for eargear in AppDelegate_.tempeargearPeripheral {
                if eargear.peripheral.state == .disconnected {
                    connectDevice(device: eargear)
                }
            }
            
            for eargear in AppDelegate_.tempFlutterPeripheral {
                if eargear.peripheral.state == .disconnected {
                    connectDevice(device: eargear)
                }
            }
            
            for eargear in AppDelegate_.tempMinitailPeripheral {
                if eargear.peripheral.state == .disconnected {
                    connectDevice(device: eargear)
                }
            }
            
            connectAllButton.setTitle("Disconnect All", for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.dismiss(animated: true) {
                    
                }
            })
            
        } else {
            for digital in AppDelegate_.tempDigitailPeripheral {
                if digital.peripheral.state == .connected {
                    AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(digital.peripheral)
                }
            }
            
            for eargear in AppDelegate_.tempeargearPeripheral {
                if eargear.peripheral.state == .connected {
                    AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(eargear.peripheral)
                }
            }
            
            for digital in AppDelegate_.tempFlutterPeripheral {
                if digital.peripheral.state == .connected {
                    AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(digital.peripheral)
                }
            }
            
            for digital in AppDelegate_.tempMinitailPeripheral {
                if digital.peripheral.state == .connected {
                    AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(digital.peripheral)
                }
            }
            
            connectAllButton.setTitle("Connect All", for: .normal)
        }
    }
    
    @IBAction func Close_Clicked(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    //MARK:-  BUTTON EVENTS -
    @IBAction func Menu_Clicked(_ sender: UIButton) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc
    func Connect_Clicked(sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw_Devicelist)
        let indexPath = self.tblVw_Devicelist.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if indexPath?.section == 0 {
                let selectedPeripharal = AppDelegate_.tempDigitailPeripheral[sender.tag]
                if selectedPeripharal.peripheral == nil {
                    AppDelegate_.isScanning = true
                    self.startScan()
                } else {
                    let objPeripharal:CBPeripheral = AppDelegate_.tempDigitailPeripheral[sender.tag].peripheral
                    if objPeripharal.state == .connected {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(objPeripharal)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.tblVw_Devicelist.reloadData()
                            }
                        }
                    } else {
                        connectDevice(device: selectedPeripharal)
                    }
                }
            } else if indexPath?.section == 1 {
                let selectedPeripharalEargear = AppDelegate_.tempeargearPeripheral[sender.tag]
                if selectedPeripharalEargear.peripheral == nil {
                    AppDelegate_.isScanning = true
                    self.startScan()
                } else {
                    let objPeripharal:CBPeripheral = AppDelegate_.tempeargearPeripheral[sender.tag].peripheral
                    if objPeripharal.state == .connected {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(objPeripharal)
                        }
                    } else {
                        connectDevice(device: selectedPeripharalEargear)
                    }
                }
            } else if indexPath?.section == 2 {
                let selectedPeripharal = AppDelegate_.tempFlutterPeripheral[sender.tag]
                if selectedPeripharal.peripheral == nil {
                    AppDelegate_.isScanning = true
                    self.startScan()
                } else {
                    let objPeripharal:CBPeripheral = AppDelegate_.tempFlutterPeripheral[sender.tag].peripheral
                    if objPeripharal.state == .connected {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(objPeripharal)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.tblVw_Devicelist.reloadData()
                            }
                        }
                    } else {
                        connectDevice(device: selectedPeripharal)
                    }
                }
            }  else {
                let selectedPeripharal = AppDelegate_.tempMinitailPeripheral[sender.tag]
                if selectedPeripharal.peripheral == nil {
                    AppDelegate_.isScanning = true
                    self.startScan()
                } else {
                    let objPeripharal:CBPeripheral = AppDelegate_.tempMinitailPeripheral[sender.tag].peripheral
                    if objPeripharal.state == .connected {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            AppDelegate_.centralManagerActor.centralManager?.cancelPeripheralConnection(objPeripharal)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.tblVw_Devicelist.reloadData()
                            }
                        }
                    } else {
                        connectDevice(device: selectedPeripharal)
                    }
                }
            }
        }
    }
    
    func connectDevice(device: DeviceModel) {
        AppDelegate_.centralManagerActor.add(device.peripheral)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tblVw_Devicelist.reloadData()
        }
    }
    
    //MARK:- BLE METHODS -
    @objc func DeviceDisconnected(_ note: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tblVw_Devicelist.reloadData()
        }
    }

    
    @objc
    func DeviceIsReady(_ note: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showToast(controller: self, message: "Device connected", seconds: 2)
            self.tblVw_Devicelist.reloadData()
        }
    }
    
    
    
}
