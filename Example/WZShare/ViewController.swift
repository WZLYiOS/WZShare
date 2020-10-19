//
//  ViewController.swift
//  WZShare
//
//  Created by LiuSky on 12/12/2019.
//  Copyright (c) 2019 LiuSky. All rights reserved.
//

import UIKit
import WZShareKit

/// MARK - 分组
public enum Section: Int, CaseIterable {
    
    case weChat
    case qq
    case weibo
    
    /// 标题
    public var title: String {
        switch self {
        case .weChat:
            return "微信"
        case .qq:
            return "QQ"
        case .weibo:
            return "微博"
        }
    }
}


/// MARK - 类型
public enum RowType: Int, CaseIterable {
    
    case isAppInstalled
    case oAuth
    case share
    
    /// 标题
    public var title: String {
        switch self {
        case .isAppInstalled:
            return "是否安装"
        case .oAuth:
            return "授权"
        case .share:
            return "分享"
        }
    }
}



/// MARK - Demo集合
final class ViewController: UIViewController {
    
    
    /// 列表
    private lazy var tableView: UITableView = {
        let temTableView = UITableView()
        temTableView.rowHeight = 50
        temTableView.dataSource = self
        temTableView.delegate = self
        temTableView.tableFooterView = UIView()
        temTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        temTableView.translatesAutoresizingMaskIntoConstraints = false
        return temTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerAccounts()
        navigationItem.title = "分享Demo集合"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItem.Style.done, target: self, action: #selector(eventForShare))
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    /// 分享
    @objc private func eventForShare() {
        
        let vc = ShareViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    /// 注册
    private func registerAccounts() {
        
        let account = MonkeyKing.Account.weChat(appID: Configs.WeChat.appID, appKey: Configs.WeChat.appKey, miniAppID: Configs.WeChat.miniAppID, universalLink: nil)
        MonkeyKing.registerAccount(account)
        
        let qq = MonkeyKing.Account.qq(appID: Configs.QQ.appID, universalLink: nil)
        MonkeyKing.registerAccount(qq)
        
        let weibo = MonkeyKing.Account.weibo(appID: Configs.Weibo.appID, appKey: Configs.Weibo.appKey, redirectURL: Configs.Weibo.redirectURL)
        MonkeyKing.registerAccount(weibo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

/// MARK - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = "\(Section.allCases[indexPath.section].title) - \(RowType.allCases[indexPath.row].title)"
        switch (Section.allCases[indexPath.section], RowType.allCases[indexPath.row]) {
        case (.weChat, .isAppInstalled):
            cell.accessoryType = MonkeyKing.SupportedPlatform.weChat.isAppInstalled ? .checkmark : .none
        case (.qq, .isAppInstalled):
            cell.accessoryType = MonkeyKing.SupportedPlatform.qq.isAppInstalled ? .checkmark : .none
        case (.weibo, .isAppInstalled):
            cell.accessoryType = MonkeyKing.SupportedPlatform.weibo.isAppInstalled ? .checkmark : .none
        default:
            break
        }
        return cell
    }
}

/// MARK - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (Section.allCases[indexPath.section], RowType.allCases[indexPath.row]) {
        case (.weChat, .oAuth):
            
//            MonkeyKing.oauth(for: MonkeyKing.SupportedPlatform.weChat) { (result) in
//                switch result {
//                case .success(let dictionary):
//                    guard
//                        let token = dictionary?["access_token"] as? String,
//                        let openID = dictionary?["openid"] as? String,
//                        let refreshToken = dictionary?["refresh_token"] as? String,
//                        let expiresIn = dictionary?["expires_in"] as? Int else {
//                        return
//                    }
//                    debugPrint("Token:\(token)====OpenID:\(openID)====refreshToken:\(refreshToken)=====expiresIn:\(expiresIn)")
//                case .failure(let error):
//                    print("error \(String(describing: error))")
//                }
//            }
            
            MonkeyKing.weChatOAuthForCode { result in
                switch result {
                case let .success(code):
                    debugPrint(code)
                case let .failure(error):
                    debugPrint(error)
                }
            }
            
        case (.weChat, .share):
            
            let info = MonkeyKing.Info(
                title: "这是一段文本内容的分享",
                description: nil,
                thumbnail: UIImage(named: "微信"),
                media: .image(UIImage(named: "微信")!)
            )
            shareInfo(info, type: 0)
            
        case (.qq, .oAuth):
            
            MonkeyKing.oauth(for: MonkeyKing.SupportedPlatform.qq) { (result) in
                switch result {
                case .success(let dictionary):
                    guard
                        let unwrappedInfo = dictionary,
                        let token = unwrappedInfo["access_token"] as? String,
                        let openID = unwrappedInfo["openid"] as? String else {
                            return
                    }
                 debugPrint("Token:\(token)========OpenID:\(openID)")
                case .failure(let error):
                    print("error \(String(describing: error))")
                }
            }
        case (.qq, .share):
            
            let info = MonkeyKing.Info(
                title: "QQ Audio, \(UUID().uuidString)",
                description: "Hello World, \(UUID().uuidString)",
                thumbnail: UIImage(named: "QQ")!,
                media: .audio(audioURL: URL(string: "http://stream20.qqmusic.qq.com/32464723.mp3")!, linkURL: nil)
            )
            shareInfoQQ(info, type: 0)
        case (.weibo, .oAuth):
            
            MonkeyKing.oauth(for: MonkeyKing.SupportedPlatform.weibo) { (result) in
               switch result {
                case .success(let dictionary):
                    guard
                        let unwrappedInfo = dictionary,
                        let token = (unwrappedInfo["access_token"] as? String) ?? (unwrappedInfo["accessToken"] as? String),
                        let userID = (unwrappedInfo["uid"] as? String) ?? (unwrappedInfo["userID"] as? String) else {
                            return
                    }
                    debugPrint("Token:\(token)========userID:\(userID)")
                case .failure(let error):
                    print("error \(String(describing: error))")
                }
            }
        case (.weibo, .share):
            
            let message = MonkeyKing.Message.weibo(.default(info: (
                title: "Image",
                description: "Rabbit",
                thumbnail: nil,
                media: .image(UIImage(named: "微博")!)
            ), accessToken: nil))
            MonkeyKing.deliver(message) { result in
                print("result: \(result)")
            }
        default:
            break
        }
    }
    
    
    
    /// 微信分享内容
    /// - Parameters:
    ///   - info: 信息
    ///   - type: 类型
    private func shareInfo(_ info: MonkeyKing.Info, type: Int) {
        var message: MonkeyKing.Message?
        switch type {
        case 0:
            message = MonkeyKing.Message.weChat(.session(info: info))
        case 1:
            message = MonkeyKing.Message.weChat(.timeline(info: info))
        case 2:
            message = MonkeyKing.Message.weChat(.favorite(info: info))
        default:
            break
        }
        guard let temMessage = message else {
            return
        }
        MonkeyKing.deliver(temMessage) { result in
            print("result: \(result)")
        }
    }
    
    
    private func shareInfoQQ(_ info: MonkeyKing.Info, type: Int) {
        var message: MonkeyKing.Message?
        switch type {
        case 0:
            message = .qq(.friends(info: info))
        case 1:
            message = .qq(.zone(info: info))
        case 2:
            message = .qq(.dataline(info: info))
        case 3:
            message = .qq(.favorites(info: info))
        default:
            break
        }
        guard let temMessage = message else {
            return
        }
        MonkeyKing.deliver(temMessage) { result in
            print("result: \(result)")
        }
    }
}
