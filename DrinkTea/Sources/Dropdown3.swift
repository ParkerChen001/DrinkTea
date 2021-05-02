//
//  Dropdown3.swift
//  Dropdown3
//
//  Created by Parker Chen on 2021/4/25.
//

import UIKit

public struct BKItem {
    public var title:String
    public var image:UIImage?
}

class Dropdown3: UIViewController {

    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var rootViewX: NSLayoutConstraint!
    @IBOutlet weak var rootViewY: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    private struct Appearance {
        struct Title {
            var textNormal:UIColor = .black
            var textHighlight:UIColor = .white
            var font:UIFont = .systemFont(ofSize: 14)
            var alignment:NSTextAlignment = .center
        }
        
        struct Cell {
            var viewNormal:UIColor = .white
            var viewHighlight:UIColor = .lightGray
            var rowHeight:CGFloat = 50
            var rowWidth:CGFloat?
            var visibleItems:Int?
        }
        
        struct Padding {
            var top:CGFloat = 0
            var bottom:CGFloat = 0
            var leading:CGFloat = 0
            var trailing:CGFloat = 0
        }
        
        struct View {
            var cornerRadius:CGFloat = 0
            var borderWidth:CGFloat = 0.5
            var borderColor:UIColor = .lightGray
            var backgroundColor:UIColor = .white
        }
        
        var title = Title()
        var cell = Cell()
        var padding = Padding()
        var view = View()
    }
    private var appearance = Appearance()
    
    /// bind
    private var arrItems:[BKItem] = []
    private var firstItem:Int?
    private var mPrevItem:Int?
    
    /// setDelayAnimation
    private var delayAnimation:TimeInterval = 0.2
    
    /// setDidSelectRowAt
    public typealias EVENT = (Int, BKItem, Dropdown3)->()
    private var didSelectEvent:EVENT?
    
    //MARK:- @Inner
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.alpha = 0
        rootView.layer.borderWidth = appearance.view.borderWidth
        rootView.layer.borderColor = appearance.view.borderColor.cgColor
        rootView.layer.cornerRadius = appearance.view.cornerRadius
        rootView.backgroundColor = appearance.view.backgroundColor
        tableView.backgroundColor = appearance.view.backgroundColor
    }
    
    //MARK:- @Public
    static public func instance() -> Dropdown3 {
        return UIStoryboard(name: "Dropdown3", bundle: Bundle(identifier: "org.cocoapods.Dropdown3"))
                .instantiateInitialViewController() as! Dropdown3
    }
    
    public func bind(_ items:[String], first:Int?=nil) -> Dropdown3 {
        if let first = first {
            assert(first > -1, "It cannot be negative.")
            assert(items.count > first, "OverFlows, You cannot exceed the range of items.")
        }
        var tmpArray:[BKItem] = []
        for item in items {
            tmpArray.append(BKItem(title: item, image: nil))
        }
        arrItems = tmpArray
        firstItem = first
        return self
    }
    
    public func bind(_ items:[BKItem], first:Int?=nil) -> Dropdown3 {
        if let first = first {
            assert(first > -1, "It cannot be negative.")
            assert(items.count > first, "OverFlows, You cannot exceed the range of items.")
        }
        print("tip021")
        arrItems = items
        firstItem = first
        return self
    }
    
    public func setLayoutTitle(normal:UIColor?=nil, highlight:UIColor?=nil, font:UIFont?=nil, alignment:NSTextAlignment?=nil) -> Dropdown3 {
        if let font = font {
            appearance.title.font = font
        }
        if let normal = normal {
            appearance.title.textNormal = normal
        }
        if let highlight = highlight {
            appearance.title.textHighlight = highlight
        }
        if let alignment = alignment {
            appearance.title.alignment = alignment
        }
        return self
    }
    
    public func setLayoutCell(normal:UIColor?=nil, highlight:UIColor?=nil, width:CGFloat?=nil, height:CGFloat?=nil, visibleItems:Int?=nil) -> Dropdown3 {
        if let normal = normal {
            appearance.cell.viewNormal = normal
        }
        if let highlight = highlight {
            appearance.cell.viewHighlight = highlight
        }
        if let width = width {
            appearance.cell.rowWidth = width
        }
        if let height = height {
            appearance.cell.rowHeight = height
        }
        if let visibleItems = visibleItems {
            appearance.cell.visibleItems = visibleItems
        }
        return self
    }
    
    public func setPadding(top:CGFloat?=nil, bottom:CGFloat?=nil, leading:CGFloat?=nil, trailing:CGFloat?=nil) -> Dropdown3 {
        if let top = top {
            appearance.padding.top = top
        }
        if let bottom = bottom {
            appearance.padding.bottom = bottom
        }
        if let leading = leading {
            appearance.padding.leading = leading
        }
        if let trailing = trailing {
            appearance.padding.trailing = trailing
        }
        return self
    }
    
    public func setViewLayer(cornerRadius:CGFloat?=nil, borderWidth:CGFloat?=nil, borderColor:UIColor?=nil) -> Dropdown3 {
        if let cornerRadius = cornerRadius {
            appearance.view.cornerRadius = cornerRadius
        }
        if let borderWidth = borderWidth {
            appearance.view.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            appearance.view.borderColor = borderColor
        }
        return self
    }
    
    public func setDelayAnimation(_ interval:TimeInterval) -> Dropdown3 {
        delayAnimation = interval
        return self
    }
    
    public func setDidSelectRowAt(_ event:@escaping EVENT) -> Dropdown3 {
        didSelectEvent = event
        return self
    }
    
    public func show(_ target:UIViewController, targetView:UIView) {
        var tmpView = targetView.superview
        var tmpRect = targetView.frame
        while tmpView != target.view {
            tmpRect = tmpView?.convert(tmpRect, to: tmpView?.superview) ?? tmpRect
            tmpView = tmpView?.superview
        }
        show(target, targetFrame: tmpRect)
    }
    
    public func show(_ target:UIViewController, targetFrame:CGRect) {
        target.present(self, animated: false) { [weak self] in
            guard let `self` = self else { return }
            self.tableViewTop.constant = self.appearance.padding.top
            self.tableViewBottom.constant = self.appearance.padding.bottom
            
            if let rowWidth = self.appearance.cell.rowWidth {
                self.tableViewWidth.constant = rowWidth
                self.rootViewX.constant = targetFrame.origin.x + ((targetFrame.size.width-rowWidth)/2)
            } else {
                self.tableViewWidth.constant = targetFrame.size.width
                self.rootViewX.constant = targetFrame.origin.x
            }
            
            self.rootViewY.constant = targetFrame.origin.y + targetFrame.height
            // If you enter the number of cells to show
            let rowHeight = self.appearance.cell.rowHeight
            if let visibleItems = self.appearance.cell.visibleItems {
                self.tableViewHeight.constant = CGFloat(visibleItems) * rowHeight + rowHeight/2
            } else {
                self.tableViewHeight.constant = CGFloat(self.arrItems.count) * rowHeight
            }

            var targetViewHeight:CGFloat = target.view.frame.height
            if #available(iOS 11.0, *) {
                targetViewHeight = target.view.frame.height - (target.view.safeAreaInsets.top + target.view.safeAreaInsets.bottom)
            }
            
            // Switch to DropUp if DropDown's (Position Y + Height) is larger than the view to be shown
            let isDropUp:Bool = self.rootViewY.constant + self.tableViewHeight.constant > targetViewHeight
            
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            
            if isDropUp {
                let isInvert = (targetViewHeight/2 + statusBarHeight + targetFrame.height) < self.rootViewY.constant
                
                if !isInvert {
                    // Invert X, if there are many items to display on the screen
                    self.tableViewHeight.constant = targetViewHeight - self.rootViewY.constant
                } else {
                    let height1 = self.tableViewHeight.constant
                    let height2 = targetFrame.origin.y - statusBarHeight
                    if height1 < height2 {
                        // Invert O, if the item to be displayed on the screen is smaller than the full screen
                        self.rootViewY.constant = targetFrame.origin.y - height1
                        
                    } else {
                        // Invert O, if the item to be displayed on the screen is larger than the full screen
                        self.tableViewHeight.constant = height2
                        self.rootViewY.constant = statusBarHeight
                    }
                }
            }
            
            if let prevItem = self.mPrevItem {
                self.tableView.selectRow(at: IndexPath(row: prevItem, section: 0), animated: false, scrollPosition: .none)
            } else {
                if let firstItem = self.firstItem {
                    self.tableView.selectRow(at: IndexPath(row: firstItem, section: 0), animated: false, scrollPosition: .none)
                }
            }
            
            UIView.animate(withDuration: self.delayAnimation) {
                self.rootView.alpha = 1
            }
        }
    }

    //Original
    @IBAction func actionHide(_ sender: Any) {
        hide()
    }
    
    public func hide(_ completion:(()->())?=nil) {
        UIView.animate(withDuration: delayAnimation, animations: {
            self.rootView.alpha = 0
        }) { (finished) in
            if finished {
                self.dismiss(animated: false, completion:completion)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
}

extension Dropdown3: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = arrItems[row]
        let identifier = item.image != nil ? "BKDropDownImageCell" : "BKDropDownCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BKDropDownCell else {
            return UITableViewCell.init()
        }
        
        cell.lbTitle.text = item.title
        cell.lbTitle.font = appearance.title.font
        cell.lbTitle.textColor = appearance.title.textNormal
        cell.lbTitle.highlightedTextColor = appearance.title.textHighlight
        cell.lbTitle.textAlignment = appearance.title.alignment
        cell.ivLogo?.image = item.image
        cell.paddingLeading.constant = appearance.padding.leading
        cell.paddingTrailing.constant = appearance.padding.trailing
        
        cell.backgroundColor = appearance.cell.viewNormal
        cell.selectedBackgroundView?.backgroundColor = appearance.cell.viewHighlight

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row

        mPrevItem = row
        didSelectEvent?(row, arrItems[row], self)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return appearance.cell.rowHeight
    }
}

class BKDropDownCell: UITableViewCell {
    
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var paddingLeading: NSLayoutConstraint!
    @IBOutlet weak var paddingTrailing: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectionView = UIView(frame: frame)
        selectedBackgroundView = selectionView
    }
}
