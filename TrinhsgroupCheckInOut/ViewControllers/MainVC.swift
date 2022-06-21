//
//  MainVC.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/09.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnIn: UIButton!
    @IBOutlet weak var btnOut: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupData()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func onCheckIn(_ sender: UIButton) {
        guard let id = GlobalVariables.shared.user?.uid, let username = GlobalVariables.shared.user?.username else { return }
        DBManagers.shared.onSendInOutRequest(type: .checkIn, uid: id, username: username, time: Date()) { success, log in
            if success {
                self.view.makeToast("Check In success")
                self.reloadData()
            } else {
                self.view.makeToast("Check In failed. Please try  again")
            }
        }
    }
    
    @IBAction func onCheckOut(_ sender: UIButton) {
        guard let id = GlobalVariables.shared.user?.uid, let username = GlobalVariables.shared.user?.username else { return }
        DBManagers.shared.onSendInOutRequest(type: .checkOut, uid: id, username: username, time: Date()) { success, log in
            if success {
                self.view.makeToast("Check Out success")
                self.reloadData()
            } else {
                self.view.makeToast("Check Out failed. Please try  again")
            }
        }
    }
    
    private func setupViews() {
        let leftBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(backTapped))
        leftBarButton.tintColor = .black
        leftBarButton.title = "Logout"
        navigationItem.leftItemsSupplementBackButton = false
        navigationItem.leftBarButtonItem = leftBarButton
        
        btnIn.backgroundColor = .green
        btnIn.layer.cornerRadius = btnIn.frame.size.height/2
        btnOut.backgroundColor = .red
        btnOut.layer.cornerRadius = btnOut.frame.size.height/2
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.tableFooterView = UIView()
        tblList.register(UINib(nibName: "InOutCell", bundle: nil), forCellReuseIdentifier: "InOutCell")
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
    
    private func setupData() {
        lblName.text = GlobalVariables.shared.user?.username ?? ""
    }
    
    private func reloadData() {
        guard let id = GlobalVariables.shared.user?.uid else { return }
        Utility.showHUD(in: self.view)
        DBManagers.shared.onGetCheckInOutHistory(uid: id) { success, log in
            if success {
                self.tblList.reloadData()
            } else {
                self.view.makeToast("Get Check In & Out history failed. Please try again")
            }
            Utility.hideHUD(in: self.view)
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariables.shared.inoutHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InOutCell") as? InOutCell else { return UITableViewCell() }
        cell.configure(data: GlobalVariables.shared.inoutHistory[indexPath.row])
        return cell
    }
}
