//
//  CustomLoaderView.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 15/03/21.
//

import UIKit
import NVActivityIndicatorView

class CustomLoaderView: UIView {
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballSpinFadeLoader, color:UIColor.white.withAlphaComponent(0.9))
    var roundLoaderView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    var image = UIImageView()
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
    var tapGesture:UITapGestureRecognizer!
    var loaderText = ""
    
    init(frame: CGRect, icon:UIImage?, loaderText:String) {
        super.init(frame: frame)
        
        self.loaderText = loaderText
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(sender:)))
        self.addGestureRecognizer(tapGesture)
        self.backgroundColor = .clear
        label.text = self.loaderText
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.center = self.center
        label.numberOfLines = 2
        label.textAlignment = .center
        label.frame.origin.y += 80
        roundLoaderView.backgroundColor = ThemeManager.currentTheme().watermelon.withAlphaComponent(0.8)
        roundLoaderView.layer.cornerRadius = 40
        activityIndicator.center = self.center
        image = UIImageView(image:icon)
        image.center = self.center
        roundLoaderView.center = self.center
        
        if self.loaderText != ""{
            self.addSubview(label)
            self.backgroundColor = ThemeManager.currentTheme().white
        }else{
            
        }
        self.addSubview(image)
        self.addSubview(roundLoaderView)
        self.addSubview(activityIndicator)
        
        image.alpha = 0
        roundLoaderView.alpha = 0
        label.alpha = 0
        self.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.activityIndicator.alpha = 1
            self.alpha = 1
            self.image.alpha = 1
            self.roundLoaderView.alpha = 1
            self.label.alpha = 1
            self.activityIndicator.startAnimating()
        }) { (finished) in
            
        }
        
        if self.loaderText != ""{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
                self.activityIndicator.center.y -= 50
                self.image.center.y -= 50
                self.roundLoaderView.center.y -= 50
                self.label.center.y -= 50
            }) { (finished) in
                
            }
        }
    }
    
    @objc private func tapView(sender:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3, delay: 0.3, options: [.curveEaseOut], animations: {
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func hide(){
        UIView.animate(withDuration: 0.1, animations: {
            self.activityIndicator.alpha = 0
            self.roundLoaderView.alpha = 0
            self.image.alpha = 0
            self.alpha = 0
            self.label.alpha = 0
        }) { (finished) in
            self.image.image = nil
            self.image.removeFromSuperview()
            self.label.removeFromSuperview()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.roundLoaderView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}
