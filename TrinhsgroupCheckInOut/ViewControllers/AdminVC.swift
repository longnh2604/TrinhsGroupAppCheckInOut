//
//  AdminVC.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/06/19.
//

import UIKit
import PDFGenerator

class AdminVC: UIViewController {

    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnPrint: UIButton!
    @IBOutlet weak var btnPrintAll: UIButton!
    @IBOutlet weak var tfUsername: UITextField!
    
    var dropDownUIView = DropDownUIView()
    var listUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDropDown()
    }
    
    @IBAction func onClickDropDown(_ sender: UIButton) {
        dropDownUIView.showHide()
    }
    
    @IBAction func onPrint(_ sender: UIButton) {
    
    }
    
    @IBAction func onPrintAll(_ sender: UIButton) {
        
    }
}

extension AdminVC {
    private func setupViews() {
        btnPrint.layer.cornerRadius = 10
        btnPrintAll.layer.cornerRadius = 10
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Admin Management"
        tfUsername.isUserInteractionEnabled = false
        
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
        dropDownUIView.create(content: view, topView: tfUsername, height: CGFloat(50 * listUsers.count))
        dropDownUIView.list = listUsers
        dropDownUIView.selectedIndex = -1
        dropDownUIView.delegate = self
    }
}

extension AdminVC: DropDownUIViewDelegate {
    func startEditing(dropDownUIView: DropDownUIView) {
        
    }
    
    func stopEditing(dropDownUIView: DropDownUIView) {
        
    }
    
    func select(dropDownUIView: DropDownUIView, selected text: String) {
        tfUsername.text = text
    }
}
