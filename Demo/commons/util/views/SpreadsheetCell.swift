//
//  SpreadsheetCell.swift
//  Demo
//
//  Created by Maxim Dymnov on 12/19/19.
//  Copyright © 2019 Maxim Dymnov. All rights reserved.
//

import UIKit

class SpreadsheetCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    var defaultColor: UIColor = .white
    var selectedColor: UIColor = .cyan
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
        setup()
    }

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = self.isSelected ? selectedColor : defaultColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setup()
    }

    override func prepareForReuse() {
        self.label.text = nil
    }

    private func commonInit() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setup() {
        self.backgroundColor = defaultColor
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
    }
}
