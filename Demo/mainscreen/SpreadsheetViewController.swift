//
//  SpreadsheetViewController.swift
//  Demo
//
//  Created by Maxim Dymnov on 12/19/19.
//  Copyright © 2019 Maxim Dymnov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "spreadsheetCell"

class SpreadsheetViewController: UICollectionViewController, SpreadsheetViewLayoutDelegate  {
    private var data: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        generateMockData(m: 5, n: 50)

        if let layout = collectionView?.collectionViewLayout as? SpreadsheetViewLayout {
            layout.delegate = self
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func generateMockData(m: Int, n: Int) {
        for row in  0 ..< n {
            data.append([String]())
            for col in 0 ..< m {
                data[row].append("Row: \(row), col: \(col + 1)")
            }
        }
    }

    private func showDetails(details: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        destination.setDetails(details: details)
        navigationController?.pushViewController(destination, animated: true)
    }

    // MARK: SpreadsheetLayoutViewDelegate
    func itemWidth(forColumn column: Int, collectionView: UICollectionView) -> Double {
        return 150
    }

    func itemHeight(forRow row: Int, collectionView: UICollectionView) -> Double {
        return 50
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count + 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[1].count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SpreadsheetCell
        if indexPath.item != 0 && indexPath.section != 0 {
            cell.label.text = data[indexPath.section - 1][indexPath.item - 1]
        }


    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 && indexPath.section != 0 {
            showDetails(details: data[indexPath.section - 1][indexPath.item - 1])
        }
    }

}
