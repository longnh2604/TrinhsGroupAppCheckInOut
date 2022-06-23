//
//  Utility.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/09.
//

import UIKit
import MBProgressHUD

struct DateStringFormat {
    static let checkInFormat: String = "EEE, dd MMM YYYY HH:mm"
}

class Utility {
    //Show/Hide loading
    static func showHUD(in view: UIView, _ animated: Bool = true) {
        Utility.performOnMainThread {
            let hud = MBProgressHUD.showAdded(to: view, animated: animated)
            hud.mode = .customView
            hud.bezelView.color = UIColor.clear
            hud.bezelView.style = .solidColor
            hud.customView = LoadingView(CGRect(x: 0, y: 0, width: 30.0, height: 30.0), .blue)
            hud.show(animated: animated)
        }
    }

    static func hideHUD(in view: UIView, _ animated: Bool = true) {
        Utility.performOnMainThread {
            MBProgressHUD.hide(for: view, animated: animated)
        }
    }
    
    static func performOnMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    static func rotate(_ target: UIView, _ duration: CFTimeInterval) {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = duration
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.isCumulative = true
        target.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    static func onConvertDateToString(date: Date, format: String?)-> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format ?? DateStringFormat.checkInFormat
        return formatter.string(from: date)
    }
    
    static func onConvertStringToDate(date: String, format: String?)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format ?? DateStringFormat.checkInFormat
        return dateFormatter.date(from: date) ?? Date()
    }
}

class LoadingView: UIView {

    private var tint: UIColor = .blue
    
    init(_ frame: CGRect, _ tint: UIColor) {
        super.init(frame: frame)
        self.tint = tint
        self.addCirclePath()
        Utility.rotate(self, 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCirclePath() {
        let circlePath = UIBezierPath(arcCenter: .zero, radius: bounds.height/2.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2 - 1.0), clockwise: true)
            
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
            
        // Change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        // You can change the stroke color
        shapeLayer.strokeColor = self.tint.cgColor
        // You can change the line width
        shapeLayer.lineWidth = 2.0
            
        self.layer.addSublayer(shapeLayer)
    }
    
}
