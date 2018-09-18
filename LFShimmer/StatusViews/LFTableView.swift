//
//  LFTableView.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/21/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import Foundation
import UIKit

public enum LFState {
    case success
    case loading
    case error(title: String, subtitle: String, buttonAction: () -> Void)
    case unknown
}

class LFTableView: UITableView {
    
    var stackView = UIStackView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var actionButton = UIButton()
    
    var buttonAction: (() -> Void)?
    
    var currentState: LFState = .unknown
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        build()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        build()
    }
    
    private func build() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 54)
        titleLabel.textAlignment = .center
        titleLabel.textColor = Color.gray60
    
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = Color.gray60
    
        actionButton.layer.borderColor = Color.gray60.cgColor
        actionButton.layer.borderWidth = 1.0
        actionButton.layer.cornerRadius = 6.0
        actionButton.setTitle("Retry", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        actionButton.setTitleColor(Color.gray60, for: .normal)
        actionButton.setNeedsLayout()
        
        actionButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        actionButton.addTarget(self, action: #selector(self.retryButtonTapped(_:)), for: .touchUpInside)
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 12.0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(actionButton)
        
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Sizes.gutter).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Sizes.gutter).isActive = true
        
        if case LFState.error(_, _, _) = currentState {
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        build()
    }
    
    public func setState(_ state: LFState) {
        self.currentState = state
        reloadData()
        
        switch state {
        case .success:
            configForSuccess()
        case .loading:
            configForLoading()
        case .error(let title, let subtitle, let buttonAction):
            configForError(title: title, subtitle: subtitle, action: buttonAction)
        case .unknown:
            ()
        }
        self.setNeedsLayout()
    }
    
    private func configForSuccess() {
        stackView.isHidden = true
    }
    
    private func configForLoading() {
        stackView.isHidden = true
    }
    
    private func configForError(title: String, subtitle: String, action: @escaping () -> Void) {
        backgroundColor = Color.gray20
        stackView.isHidden = false
        titleLabel.text = title
        subtitleLabel.text = subtitle
        buttonAction = action
        
    }

    @objc func retryButtonTapped( _ sender: UIButton) {
        guard let action = self.buttonAction else {
            print("Retry Action not Found")
            return
        }
        action()
    }
    
    
    
}
