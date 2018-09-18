//
//  LoadingLabel.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/19/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit
import QuartzCore

final class LoadingLabel: UIView {
        
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    private let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.gray20
        return view
    }()
    
    private let loadingAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.fromValue = Color.gray20.cgColor
        animation.toValue = Color.gray45.cgColor
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.6, 1)
        return animation
    }()
    
    init( withTextStyle textStyle: UIFont) {
        self.label.font = textStyle
        super.init(frame: .zero)
        
        addSubview(background)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
        
            
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: LoadingTextViewModel) {
        label.isHidden = viewModel.isLoading
        label.text = viewModel.text
        background.isHidden = !viewModel.isLoading
        animate(viewModel.isLoading)
    }
    
    func animate(_ animate: Bool){
        let key = "key"
        let isAnimating = background.layer.animation(forKey: key) != nil
        label.isHidden = animate
        background.isHidden = !animate
        switch (animate, isAnimating) {
        case (true, false):
            
            background.layer.add(loadingAnimation, forKey: key)
        case (false, true):
            background.layer.removeAnimation(forKey: key)
        case (true, true),
             (false, false):
            break
        }
    }
}

