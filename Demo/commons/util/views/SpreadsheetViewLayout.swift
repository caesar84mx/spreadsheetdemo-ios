//
//  SpreadsheetViewLayout.swift
//  Demo
//
//  Created by Maxim Dymnov on 12/19/19.
//  Copyright © 2019 Maxim Dymnov. All rights reserved.
//

import UIKit

class SpreadsheetViewLayout: UICollectionViewLayout {
    weak var delegate: SpreadsheetViewLayoutDelegate!

    private var layoutAttributesCache: [UICollectionViewLayoutAttributes]!
    private var layoutAttributesInRectCache = CGRect.zero
    private var contentSizeCache = CGSize.zero
    private var columnCountCache = 0
    private var rowCountCache = 0

    private var originalContentOffset = CGPoint.zero

    override var collectionViewContentSize: CGSize {
        guard contentSizeCache.equalTo(CGSize.zero) else {
            return contentSizeCache
        }

        originalContentOffset = collectionView!.contentOffset
        columnCountCache = collectionView!.numberOfItems(inSection: 0)
        rowCountCache = collectionView!.numberOfSections

        var contentSize = CGSize(width: originalContentOffset.x, height: originalContentOffset.y)

        for column in 0 ..< columnCountCache {
            contentSize.width += CGFloat(delegate.itemWidth(
                forColumn: column, collectionView: collectionView!
            ))
        }

        for row in 0 ..< rowCountCache {
            contentSize.height += CGFloat(delegate.itemHeight(
                forRow: row, collectionView: collectionView!
            ))
        }

        contentSizeCache = contentSize

        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let itemSize = CGSize(
            width: delegate.itemWidth(
                forColumn: indexPath.row, collectionView: collectionView!
            ),
            height: delegate.itemHeight(
                forRow: indexPath.section, collectionView: collectionView!
            )
        )

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var frame = CGRect(
            x: (itemSize.width * CGFloat(indexPath.row)) + originalContentOffset.x,
            y: (itemSize.height * CGFloat(indexPath.section)) + originalContentOffset.y,
            width: itemSize.width,
            height: itemSize.height
        )

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            attributes.zIndex = 2
            frame.origin.y = collectionView!.contentOffset.y
            frame.origin.x = collectionView!.contentOffset.x

        case (0, _):
            attributes.zIndex = 1
            frame.origin.y = collectionView!.contentOffset.y

        case (_, 0):
            attributes.zIndex = 1
            frame.origin.x = collectionView!.contentOffset.x

        default:
            attributes.zIndex = 0
        }

        attributes.frame = frame.integral

        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard !rect.equalTo(layoutAttributesInRectCache) else {
            return layoutAttributesCache
        }

        layoutAttributesInRectCache = rect

        var attributes = Set<UICollectionViewLayoutAttributes>()

        for column in 0 ..< columnCountCache {
            for row in 0 ..< rowCountCache {
                let attribute = layoutAttributesForItem(at: IndexPath(row: column, section: row))!

                attributes.insert(attribute)
            }
        }

        layoutAttributesCache = Array(attributes)

        return layoutAttributesCache
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func invalidateLayout() {
        super.invalidateLayout()

        layoutAttributesCache = nil
        layoutAttributesInRectCache = CGRect.zero
    }
}

protocol SpreadsheetViewLayoutDelegate: UICollectionViewDelegate {
    func itemWidth(forColumn column: Int, collectionView: UICollectionView) -> Double
    func itemHeight(forRow row: Int, collectionView: UICollectionView) -> Double
}
