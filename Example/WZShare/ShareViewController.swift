//
//  ShareViewController.swift
//  WZShare_Example
//
//  Created by xiaobin liu on 2020/5/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import WZShareKit

/// MARK - ShareViewController
final class ShareViewController: UIViewController {
    
    /// 唯一标识
    private let identifier = "shareCollectionViewCell"
    
    /// minimumInteritemSpacing
    private let minimumInteritemSpacing: CGFloat = 10
    
    /// minimumLineSpacing
    private let minimumLineSpacing: CGFloat = 10
    
    /// sectionInset
    private let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// itemSize
    private var itemSize: CGSize {
        let width = (self.view.frame.width - sectionInset.left - sectionInset.right - minimumLineSpacing * (self.lineCount - 1))/lineCount
        return CGSize(width: width, height: 80)
    }
    
    /// 一行4个
    private let lineCount: CGFloat = 4
    
    /// 集合视图高度(itemSizeHeight = 80)
    private var collectionViewHeight: CGFloat {
        
        let totalLine = Type.allCases.count / Int(lineCount) + (Type.allCases.count % Int(lineCount) > 0 ? 1 : 0)
        return itemSize.height * CGFloat(totalLine) + sectionInset.top + sectionInset.bottom + CGFloat(totalLine - 1) * minimumLineSpacing
    }
    
    
    /// 集合视图
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = sectionInset
        layout.itemSize = itemSize
        
        let temCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        temCollectionView.dataSource = self
        temCollectionView.delegate = self
        temCollectionView.backgroundColor = UIColor(red: 0.937255, green: 0.937255, blue: 0.956863, alpha: 1.0)
        temCollectionView.register(ShareCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        temCollectionView.translatesAutoresizingMaskIntoConstraints = false
        temCollectionView.isScrollEnabled = false
        return temCollectionView
    }()
    
    /// 取消按钮高度
    private let cancelButtonHeight: CGFloat = 50.0
    /// 取消按钮
    private lazy var cancelButton: UIButton = {
        let temButton = UIButton(type: .custom)
        temButton.backgroundColor = UIColor.white
        temButton.setTitle("取消", for: UIControl.State.normal)
        temButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        temButton.translatesAutoresizingMaskIntoConstraints = false
        temButton.addTarget(self, action: #selector(eventForCancel), for: UIControl.Event.touchUpInside)
        return temButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configView()
        configLocation()
    }
    
    /// 配置位置
    private func configView() {
        
        view.addSubview(collectionView)
        view.addSubview(cancelButton)
    }
    
    /// 配置位置
    private func configLocation() {
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
        ])
        
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ShareViewController.safeAreaInsetsBottom),
            cancelButton.heightAnchor.constraint(equalToConstant: cancelButtonHeight),
        ])
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .custom
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16.0, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    /// 安全区域底部
    public static var safeAreaInsetsBottom: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    /// 取消事件
    @objc private func eventForCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 背景点击
    @objc private func eventForBackgroundTap() {
        eventForCancel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK - UICollectionViewDataSource
extension ShareViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Type.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ShareCollectionViewCell
        cell.iconImageView.image = Type.allCases[indexPath.row].iconImage
        cell.titleLabel.text = Type.allCases[indexPath.row].title
        return cell
    }
}

/// MARK - UICollectionViewDelegate
extension ShareViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let info = MonkeyKing.Info(
            title: "你皮任你皮，让你吃瓜皮，额💩真香",
            description: "你皮任你皮，让你吃瓜皮，额💩真香",
            thumbnail: nil,
            media: nil)
        
        var message: MonkeyKing.Message?
        switch Type.allCases[indexPath.row] {
        case .wechat:
            message = MonkeyKing.Message.weChat(.session(info: info))
        case .timeline:
            message = MonkeyKing.Message.weChat(.timeline(info: info))
        case .qq:
            message = MonkeyKing.Message.qq(.friends(info: info))
        case .zone:
            message = MonkeyKing.Message.qq(.zone(info: info))
        case .weibo:
            message = MonkeyKing.Message.weibo(.default(info: info, accessToken: nil))
        }
        
        guard let temMessage = message else {
            return
        }
        MonkeyKing.deliver(temMessage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                debugPrint("分享成功")
                self.eventForCancel()
            case let .failure(error):
                debugPrint(error)
                self.eventForCancel()
            }
        }
    }
}

/// MARK - Enum
extension ShareViewController {
    
    /// 类型
    private enum `Type`: Int, CaseIterable {
        
        case wechat = 0
        case timeline
        case qq
        case zone
        case weibo
        
        
        /// 标题
        public var title: String {
            switch self {
            case .wechat:
                return "微信"
            case .timeline:
                return "朋友圈"
            case .qq:
                return "QQ"
            case .zone:
                return "QQ空间"
            case .weibo:
                return "微博"
            }
        }
        
        /// 图标
        public var iconImage: UIImage {
            switch self {
            case .wechat:
                return #imageLiteral(resourceName: "微信")
            case .timeline:
                return #imageLiteral(resourceName: "朋友圈")
            case .qq:
                return #imageLiteral(resourceName: "QQ")
            case .zone:
                return #imageLiteral(resourceName: "QQ空间")
            case .weibo:
                return #imageLiteral(resourceName: "微博")
            }
        }
    }
}

/// MARK - 分享Cell
final class ShareCollectionViewCell: UICollectionViewCell {
    
    /// 图标视图
    private(set) lazy var iconImageView: UIImageView = {
        let temImageView = UIImageView()
        temImageView.backgroundColor = UIColor.clear
        temImageView.translatesAutoresizingMaskIntoConstraints = false
        return temImageView
    }()
    
    /// 标题标签
    private(set) lazy var titleLabel: UILabel = {
        let temLabel = UILabel()
        temLabel.backgroundColor = UIColor.clear
        temLabel.textAlignment = .center
        temLabel.font = UIFont.systemFont(ofSize: 16)
        temLabel.translatesAutoresizingMaskIntoConstraints = false
        return temLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        configView()
        configLocation()
    }
    
    /// 配置视图
    private func configView() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
    }
    
    /// 配置位置
    private func configLocation() {
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK - UIViewControllerTransitioningDelegate
extension ShareViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        ShartPresentationController(presentedViewController: presented, presenting: presenting, height: collectionViewHeight + cancelButtonHeight + ShareViewController.safeAreaInsetsBottom)
    }
}
