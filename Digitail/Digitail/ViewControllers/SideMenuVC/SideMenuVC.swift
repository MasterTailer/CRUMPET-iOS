//
//  SideMenuVC.swift
//  Digitail
//
//  Created by Iottive on 21/06/19.
//  Copyright © 2019 Iottive. All rights reserved.
//

import UIKit

//let k = "DIGITAIL"


class SideMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Properties
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tblViewMenuList: UITableView!
    var indexPathForTextColor : Int!
    
    var arrMenuList = ["DIGITAIL","Alarm","Move Lists","Tail Moves","Glow Tips","Casual Mode Settings","Settings","About"]
    var arrMenuImages = ["Home","Alarm","movelist","TailMoves","GlowTips","Casulal ModeSetting","Settings","About"]
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewMenuList.separatorStyle = .none
        tblViewMenuList.reloadData()
        // bottomTabs.drawBehind = true
        self.navigationController?.isNavigationBarHidden = true
      
        let tapGestureForDeveloper = UITapGestureRecognizer(target: self, action: #selector (addDeveloper_Clcked))
        tapGestureForDeveloper.numberOfTapsRequired = 5
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureForDeveloper)
    }
    
    @objc func addDeveloper_Clcked() {
        print("Tap happend")
        if !arrMenuList.contains("Developer") {
            arrMenuList.append("Developer")
            arrMenuImages.append("Settings")
            tblViewMenuList.reloadData()
        }
    }

    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewMenuList.dequeueReusableCell(withIdentifier: "TblCellSideMenu", for: indexPath) as! TblCellSideMenu
        cell.lblMenuName.text = arrMenuList[indexPath.row]
        cell.imgView.image = UIImage(named: arrMenuImages[indexPath.row])
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 96/255, green: 126/255, blue: 139/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        //cell.lblMenuName.highlightedTextColor = UIColor.white
        cell.lblMenuName.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let indexTitel = arrMenuList[indexPath.row]
        let section = 0
        let row = indexPath.row
        let indexPath = IndexPath(row: row, section: section)
        let cell: TblCellSideMenu = self.tblViewMenuList.cellForRow(at: indexPath) as! TblCellSideMenu
        //.imgView.tintColor = UIColor.white
        cell.imgView.image = cell.imgView.image?.withRenderingMode(.alwaysTemplate)
        
        let navigationController = AppDelegate_.window?.rootViewController as! UINavigationController
        dismiss(animated: true, completion: nil)
        navigationController.popToRootViewController(animated: false)
        switch indexTitel {
        case "Alarm" :
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let alarmVc = self.storyboard?.instantiateViewController(withIdentifier: "AlarmsVC") as! AlarmsVC
            navigationController.pushViewController(alarmVc, animated: true)
            
        case "Move Lists" :
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let moveListVC = storyboard.instantiateViewController(withIdentifier: "MoveListsVC") as! MoveListsVC
            navigationController.pushViewController(moveListVC, animated: true)
            
        case "Tail Moves" :
            if (self.isDIGITAiLConnected()) {
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tailsMoveVC = storyboard.instantiateViewController(withIdentifier: "TailMovesVC") as! TailMovesVC
                navigationController.pushViewController(tailsMoveVC, animated: true)
            } else {
                
            }
        case "Casual Mode Settings" :
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let casualModeSettingVC = storyboard.instantiateViewController(withIdentifier: "CasualModeSettingVC") as! CasualModeSettingVC
            navigationController.pushViewController(casualModeSettingVC, animated: true)
            
        case "Settings" :
            let rootViewController = AppDelegate_.window!.rootViewController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            
            navigationController.pushViewController(setViewController, animated: true)
            
        case "Glow Tips" :
            if (self.isDIGITAiLConnected()) {
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let objGlowTipsVC = storyboard.instantiateViewController(withIdentifier: "GlowTipsVC") as! GlowTipsVC
                self.navigationController?.pushViewController(objGlowTipsVC, animated: true)
            } else {
                
            }
            
        case "About" :
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let objAboutVC = storyboard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
            navigationController.pushViewController(objAboutVC, animated: true)
            
        case "Developer" :
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let objDeveloperVC = storyboard.instantiateViewController(withIdentifier: "DeveloperVC") as! DeveloperVC
            navigationController.pushViewController(objDeveloperVC, animated: true)
            
        default:
            break
        }
    }
    
    func isDIGITAiLConnected() -> Bool {
        if AppDelegate_.digitailDeviceActor != nil && (AppDelegate_.digitailDeviceActor?.peripheralActor != nil && (AppDelegate_.digitailDeviceActor?.isConnected())!) {
            return true
        } else {
            return false
        }
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 55
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //       // return 15.0
    //    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        indexPathForTextColor = indexPath.row
        tblViewMenuList.reloadData()
    }
    
}
