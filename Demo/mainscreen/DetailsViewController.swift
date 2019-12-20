//
//  DetailsViewController.swift
//  Demo
//
//  Created by Maxim Dymnov on 12/20/19.
//  Copyright © 2019 Maxim Dymnov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var detailsLabel: UILabel!

    private var details: String?

    override func viewDidAppear(_ animated: Bool) {
        detailsLabel.text = details
    }

    func setDetails(details: String) {
        self.details = details
    }
}
