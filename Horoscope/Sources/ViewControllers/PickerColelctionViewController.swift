//
//  PickerColelctionViewController.swift
//  Horoscope
//
//  Created by Dmitry Osipa on 2/8/16.
//  Copyright © 2016 MediaApps. All rights reserved.
//

import UIKit

private let kReuseIdentifier = "buttonCell"
private let kRowHeightPhone : CGFloat = 60.0
private let kRowHeightPad : CGFloat = 90.0

protocol PickerDelegate {
    func picker(picker: PickerColelctionViewController, didPickCategory category: HoroCategory, type: HoroType)
}

class PickerColelctionViewController: UICollectionViewController, ZodiacCellDelegate, KRLCollectionViewDelegateGridLayout {

    internal var type : HoroType = .Today {
        didSet {
            self.updateButtons()
        }
    }
    internal var category : HoroCategory = .General
    internal var delegate: PickerDelegate?
    internal var categoryImages : [String]
    internal var typeImages : [String]?

    required init?(coder aDecoder: NSCoder) {
        categoryImages = ["carier", "family", "health", "love", "money", "teen"]
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        self.collectionView!.registerClass(ZodiacCell.self, forCellWithReuseIdentifier: kReuseIdentifier)
        self.collectionView!.backgroundColor = UIColor(red: 35.0/255.0, green: 35.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        let layout = self.collectionViewLayout as! KRLCollectionViewGridLayout
        layout.interitemSpacing = 0.0
        layout.lineSpacing = 0.0
    }
    
    func updateButtons() {
        switch type {
        case .Today:
            typeImages = ["tomorrow", "year"]
        case .Tomorrow:
            typeImages = ["today", "year"]
        default:
            typeImages = ["today", "tomorrow"]
        }
        self.collectionView?.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = self.collectionViewLayout as! KRLCollectionViewGridLayout
        if traitCollection.userInterfaceIdiom == .Phone {
            if traitCollection.verticalSizeClass == .Compact {
                let inset : CGFloat = view.frame.width * 0.20
                layout.sectionInset = UIEdgeInsetsMake(0.0, inset, 0.0, inset)
            } else {
                let inset : CGFloat = view.frame.width
                layout.sectionInset = UIEdgeInsetsMake(0.0, inset, 0.0, inset)
            }
        } else {
            let inset : CGFloat = view.frame.width * 0.10
            layout.sectionInset = UIEdgeInsetsMake(0.0, inset, 0.0, inset)
        }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.categoryImages.count
        case 1:
            guard let count = self.typeImages?.count
                else {return 0}
            return count
        default:
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kReuseIdentifier, forIndexPath: indexPath) as! ZodiacCell
        let index = indexPath.item
        if indexPath.section == 0 {
            let image = UIImage.init(named: categoryImages[index])
            cell.button.setImage(image, forState: .Normal)
            cell.button.tag = index + 1
        } else {
            let image = UIImage.init(named: typeImages![index])
            cell.button.setImage(image, forState: .Normal)
            cell.button.tag = index + 1
        }
        cell.delegate = self
        return cell
    }

    func cellDidButtonAction(cell: ZodiacCell, sender: UIButton) {
//        pickedItem = Gender(rawValue: sender.tag)
    }

    func typeAction(sender: AnyObject) {
        guard let senderView = sender as? UIView
            else { return }
        let tag = senderView.tag
        let newCategory = HoroCategory(rawValue: tag)!
        self.delegate?.picker(self, didPickCategory: newCategory, type: type)
    }

    func dateAction(sender: AnyObject) {
        guard let senderView = sender as? UIButton
            else { return }
        let tag = senderView.stringTag
        let newType = HoroType(rawValue: tag!)!
        self.delegate?.picker(self, didPickCategory: category, type: newType)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberItemsPerLineForSectionAtIndex section: Int) -> Int {
        if section == 0 {
            if traitCollection.verticalSizeClass == .Compact || traitCollection.userInterfaceIdiom == .Pad {
                return 3
            } else {
                return 2
            }
        } else {
            guard let array = typeImages
                else { return 0 }
            return array.count
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, aspectRatioForItemsInSectionAtIndex section: Int) -> CGFloat {
        let layout = collectionViewLayout as! KRLCollectionViewGridLayout
        let insets = layout.sectionInset.left + layout.sectionInset.right
        let rowHeight = itemHeight()
        if (section == 0) {
            if traitCollection.verticalSizeClass == .Compact || traitCollection.userInterfaceIdiom == .Pad  {
                return  ((view.frame.width - insets) * 0.33) / rowHeight
            } else {
                return  ((view.frame.width - insets) * 0.5) / rowHeight
            }
        } else {
            return  ((view.frame.width - insets) * 0.5) / rowHeight
        }
    }

    func itemHeight() -> CGFloat {
        if (traitCollection.userInterfaceIdiom == .Pad) {
            return kRowHeightPad
        } else {
            return kRowHeightPhone
        }
    }

}
