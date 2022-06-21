//
//  DropDownUIView.swift
//  Family App
//
//  Created by Work on 2020-09-15.
//  Copyright © 2020 CONNECT2D. All rights reserved.
//

import UIKit

protocol DropDownUIViewDelegate: AnyObject {
    func startEditing(dropDownUIView: DropDownUIView)
    func stopEditing(dropDownUIView: DropDownUIView)
    func select(dropDownUIView: DropDownUIView, selected text: String)
}

class DropDownUIView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    let dialog = UIView()
    let tableView = UITableView()
    var height: CGFloat!
    var isShowing = false
    var selectedIndex = -1
    var delegate: DropDownUIViewDelegate?
    var list: [String] = []
    
    func create(content: UIView, topView: UIView, height: CGFloat) {
        content.addSubview(self)
        self.addSubview(dialog)
        dialog.addSubview(tableView)
        self.height = height
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: topView.leadingAnchor,constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.25
        
        dialog.translatesAutoresizingMaskIntoConstraints = false
        dialog.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dialog.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dialog.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dialog.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dialog.layer.masksToBounds = true
//        dialog.layer.cornerRadius = 25
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: dialog.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: dialog.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: dialog.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: dialog.trailingAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DropDownSelectionTableViewCell", bundle: .main), forCellReuseIdentifier: "DropDownSelectionTableViewCell")
        tableView.separatorStyle = .none
        dialog.transform = CGAffineTransform(translationX: 0, y: -110).scaledBy(x: 1, y: 0.025)
        self.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownSelectionTableViewCell", for: indexPath) as! DropDownSelectionTableViewCell

        cell.selectionStyle = .none
        cell.selection.text = list[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.contentUIView.layer.borderColor = UIColor.gray.cgColor
        } else {
            cell.contentUIView.layer.borderColor = UIColor.white.cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        delegate?.select(dropDownUIView: self, selected: list[indexPath.row])
        showHide()
    }
    
    func showHide() {
        if isShowing {
            isShowing = false
            hide()
        } else {
            isShowing = true
            show()
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dialog.transform = CGAffineTransform(translationX: 0, y: -110).scaledBy(x: 1, y: 0.025)
            self.dialog.alpha = 0
        }) { (_) in
            self.isHidden = true
            self.delegate?.stopEditing(dropDownUIView: self)
        }
    }
    
    private func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.dialog.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1, y: 1)
            self.dialog.alpha = 1.0
        }) { (_) in
            self.delegate?.startEditing(dropDownUIView: self)
        }
    }
}
