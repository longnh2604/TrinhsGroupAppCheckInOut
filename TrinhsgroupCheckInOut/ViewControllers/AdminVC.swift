//
//  AdminVC.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/06/19.
//

import UIKit
import SwiftCSVExport
import MessageUI

class AdminVC: UIViewController {

    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnPrint: UIButton!
    @IBOutlet weak var btnPrintAll: UIButton!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    
    var userDD = DropDownUIView()
    var monthDD = DropDownUIView()
    var yearDD = DropDownUIView()
    
    var listMonths = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var listYears = ["2022","2023"]
    var listUsers = [String]()
    var userSelecting: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDropDown()
    }
    
    @IBAction func onClickDropDown(_ sender: UIButton) {
        userDD.showHide()
    }
    
    @IBAction func onPrint(_ sender: UIButton) {
        guard let userSelecting = userSelecting, let id = userSelecting.uid else {
            self.view.makeToast("Please select user to print report first")
            return
        }
        
        Utility.showHUD(in: view)
        DBManagers.shared.onGetCheckInOutHistory(uid: id) { success, log in
            if success {
                self.onPrintData()
            } else {
                self.view.makeToast("Get Check In & Out history failed. Please try again")
            }
            Utility.hideHUD(in: self.view)
        }
    }
    
    @IBAction func onPrintAll(_ sender: UIButton) {
        Utility.showHUD(in: view)
        DBManagers.shared.onGetCheckInOutHistoryAll { success, log in
            if success {
                self.onPrintData()
            } else {
                self.view.makeToast("Get Check In & Out history failed. Please try again")
            }
            Utility.hideHUD(in: self.view)
        }
    }
    
    @IBAction func onSelectMonth(_ sender: UIButton) {
        monthDD.showHide()
    }
    
    @IBAction func onSelectYear(_ sender: UIButton) {
        yearDD.showHide()
    }
}

extension AdminVC {
    private func setupViews() {
        btnPrint.layer.cornerRadius = 10
        btnPrintAll.layer.cornerRadius = 10
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Admin Management"
        tfUsername.isUserInteractionEnabled = false
        
        btnYear.layer.borderWidth = 1
        btnMonth.layer.borderWidth = 1
        btnYear.layer.borderColor = UIColor.black.cgColor
        btnMonth.layer.borderColor = UIColor.black.cgColor
        
        let leftBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(backTapped))
        leftBarButton.tintColor = .black
        leftBarButton.title = "Logout"
        navigationItem.leftItemsSupplementBackButton = false
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func backTapped() {
        Utility.showHUD(in: self.view)
        FirebaseAuthManager.shared.signOut { success in
            if success {
                GlobalVariables.shared.resetAllData()
                self.navigationController?.popToRootViewController(animated: true)
            }
            Utility.hideHUD(in: self.view)
        }
    }
    
    private func setupDropDown() {
        listUsers.removeAll()
        GlobalVariables.shared.userList.forEach { user in
            listUsers.append(user.username ?? "")
        }
        userDD.create(content: view, topView: tfUsername, height: CGFloat(50 * listUsers.count))
        userDD.list = listUsers
        userDD.selectedIndex = -1
        userDD.delegate = self
        userDD.tag = 0
        
        monthDD.create(content: view, topView: btnMonth, height: CGFloat(250))
        monthDD.list = listMonths
        monthDD.selectedIndex = -1
        monthDD.delegate = self
        monthDD.tag = 1
        
        yearDD.create(content: view, topView: btnYear, height: CGFloat(100))
        yearDD.list = listYears
        yearDD.selectedIndex = -1
        yearDD.delegate = self
        yearDD.tag = 2
    }
    
    private func onPrintData() {
        let writeCSVObj = CSV()
        
        // Add dictionary into rows of CSV Array
        let data:NSMutableArray = NSMutableArray()
        GlobalVariables.shared.inoutHistory.forEach { dataInOut in
            let newData = NSMutableDictionary()
            newData.setObject(dataInOut.username, forKey: "username" as NSCopying)
            newData.setObject(dataInOut.type, forKey: "type" as NSCopying)
            newData.setObject(dataInOut.time, forKey:"time" as NSCopying)
            data.add(newData)
        }
        writeCSVObj.rows = data
        
        writeCSVObj.delimiter = DividerType.comma.rawValue
        
        // Add fields into columns of CSV headers
        let header = ["username", "type", "time"]
        writeCSVObj.fields = header as NSArray
        
        writeCSVObj.name = "InOut\(Utility.onConvertDateToString(date: Date(), format: nil))"
        
        // Write File using CSV class object
        let output = CSVExport.export(writeCSVObj);
        if output.result.isSuccess {
            guard let filePath =  output.filePath else {
                print("Export Error: \(String(describing: output.message))")
                return
            }
            
            self.onSendEmail(filePath: filePath)
        } else {
            print("Export Error: \(String(describing: output.message))")
        }
    }
    
    func onSendEmail(filePath: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("Check In Out TrinhsMelton Report")
            mailComposer.setMessageBody("", isHTML: false)
            mailComposer.setToRecipients(["longnh264@gmail.com"])
            mailComposer.mailComposeDelegate = self
            
            let url = URL(fileURLWithPath: filePath)
            
            do {
            let attachmentData = try Data(contentsOf: url)
                mailComposer.addAttachmentData(attachmentData, mimeType: "text/csv", fileName: "CSV")
                mailComposer.mailComposeDelegate = self
                self.present(mailComposer, animated: true
                    , completion: nil)
            } catch let error {
                print("We have encountered error \(error.localizedDescription)")
            }
            
        } else {
            print("Email is not configured in settings app or we are not able to send an email")
        }
    }
}

extension AdminVC: DropDownUIViewDelegate {
    func startEditing(dropDownUIView: DropDownUIView) {
        
    }
    
    func stopEditing(dropDownUIView: DropDownUIView) {
        
    }
    
    func select(dropDownUIView: DropDownUIView, selected text: String) {
        switch dropDownUIView.tag {
        case 0:
            tfUsername.text = text
            userSelecting = GlobalVariables.shared.userList.filter({ $0.username == text }).first
        case 1:
            btnMonth.setTitle(text, for: .normal)
        case 2:
            btnYear.setTitle(text, for: .normal)
        default:
            break
        }
    }
}

extension AdminVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                                       didFinishWith result: MFMailComposeResult,
                                       error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
