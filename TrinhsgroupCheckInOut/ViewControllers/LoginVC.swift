//
//  LoginVC.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/09.
//

import UIKit

class LoginVC: UIViewController {

    // StackView
    @IBOutlet weak var viewUsername: UIStackView!
    @IBOutlet weak var viewPassword: UIStackView!
    @IBOutlet weak var viewEmail: UIStackView!
    @IBOutlet weak var viewShop: UIStackView!
    
    // TextField
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfShop: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDropDown: UIButton!
    
    var isRegister: Bool = false {
        didSet {
            lblTitle.text = isRegister ? "Register" : "Login"
            viewEmail.isHidden = !isRegister
            btnLogin.setTitle(isRegister ? "Register" : "Login", for: .normal)
            btnSignUp.setTitle(isRegister ? "Login" : "SignUp", for: .normal)
            tfUsername.isUserInteractionEnabled = isRegister ? true : false
            btnDropDown.isHidden = isRegister ? true : false
        }
    }
    
    var dropDownUIView = DropDownUIView()
    var listUsers = [String]()
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
        resetData()
    }
    
    // Actions
    @IBAction func onProcessAction(_ sender: UIButton) {
        if validConditions() {
            guard let username = tfUsername.text, let password = tfPassword.text else { return }
            if isRegister {
                guard let email = tfEmail.text else { return }
                Utility.showHUD(in: self.view)
                FirebaseAuthManager.shared.createUser(email: email, password: password) { [weak self] success, error in
                    guard let self = self else { return }
                    if success {
                        guard let id = GlobalVariables.shared.user?.uid else { return }
                        DBManagers.shared.onCreateUser(email: email, uid: id, username: username, imageURL: nil) { success, log in
                            if success {
                                guard let vc = Storyboards.main.instantiate() as? MainVC else { return }
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                self.view.makeToast(log)
                            }
                        }
                    } else {
                        self.view.makeToast(error)
                    }
                    Utility.hideHUD(in: self.view)
                }
            } else {
                guard let email = GlobalVariables.shared.userList[dropDownUIView.selectedIndex].email else { return }
                Utility.showHUD(in: self.view)
                FirebaseAuthManager.shared.signIn(email: email, pass: password) { [weak self] success, error in
                    guard let self = self else { return }
                    if success {
                        guard let uid = GlobalVariables.shared.user?.uid else { return }
                        DBManagers.shared.onGetUser(uid: uid) { success, log in
                            if success {
                                if let admin = GlobalVariables.shared.user?.isAdmin, admin {
                                    guard let vc = Storyboards.admin.instantiate() as? AdminVC else { return }
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else {
                                    guard let vc = Storyboards.main.instantiate() as? MainVC else { return }
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            } else {
                                self.view.makeToast(log)
                            }
                        }
                    } else {
                        self.view.makeToast(error)
                    }
                    Utility.hideHUD(in: self.view)
                }
            }
        }
    }
    
    @IBAction func onSwitchType(_ sender: UIButton) {
        self.view.endEditing(true)
        if dropDownUIView.isShowing {
            dropDownUIView.showHide()
        }
        isRegister = !isRegister
    }
    
    @IBAction func onDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        dropDownUIView.showHide()
    }
}

extension LoginVC {
    private func setupViews() {
        self.navigationController?.isNavigationBarHidden = true
        btnLogin.layer.cornerRadius = 10
        btnSignUp.layer.cornerRadius = 10
        tfShop.text = "TrinhsKitchenMelton"
        tfShop.isUserInteractionEnabled = false
        isRegister = false
    }
    
    private func validConditions() -> Bool {
        if isRegister {
            guard let username = tfUsername.text, let password = tfPassword.text, let email = tfEmail.text else { return false }
            if username.isEmpty || password.isEmpty || email.isEmpty {
                self.view.makeToast("Please fill all username, password and email")
                return false
            }
        } else {
            guard let username = tfUsername.text, let password = tfPassword.text else { return false }
            if username.isEmpty || password.isEmpty {
                self.view.makeToast("Please fill your username and password")
                return false
            }
        }
        return true
    }
    
    private func setupDropDown() {
        dropDownUIView.create(content: view, topView: tfUsername, height: CGFloat(50 * listUsers.count))
        dropDownUIView.list = listUsers
        dropDownUIView.selectedIndex = -1
        dropDownUIView.delegate = self
    }
    
    private func resetData() {
        tfUsername.text = ""
        tfPassword.text = ""
        tfEmail.text = ""
        tfPassword.resignFirstResponder()
        tfEmail.resignFirstResponder()
    }
    
    private func setupData() {
        Utility.showHUD(in: self.view)
        DBManagers.shared.onListAllUser { success, users, log in
            if success {
                GlobalVariables.shared.userList = users
                for user in users {
                    self.listUsers.append(user.username ?? "")
                }
                self.setupDropDown()
            } else {
                self.view.makeToast(log)
            }
            Utility.hideHUD(in: self.view)
        }
    }
}

extension LoginVC: DropDownUIViewDelegate {
    func startEditing(dropDownUIView: DropDownUIView) {
        
    }
    
    func stopEditing(dropDownUIView: DropDownUIView) {
        
    }
    
    func select(dropDownUIView: DropDownUIView, selected text: String) {
        tfUsername.text = text
    }
}

