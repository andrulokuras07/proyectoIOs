//
//  CardView.swift
//  HelloWorld
//
//  Created by Alumnos on 15/04/26.
//

import UIKit

@IBDesignable
class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 12
    }
}
