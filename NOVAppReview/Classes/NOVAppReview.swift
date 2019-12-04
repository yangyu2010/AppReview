//
//  NOVAppReview.swift
//  NOVAppReview
//
//  Created by YangYu on 2019/11/29.
//

import UIKit
import NOVRemoteConfig

/// 评论成功后发出通知
public let NOVAppReviewNeedRewarded = "NOVAppReviewNeedRewarded"

extension NOVAppReview {
    
    struct Key {
        /// 评论开关
        static let EnableKey                 = "rate_button_enable"
        /// 最多显示次数
        static let MaxCount                  = "rate_max_show"
        /// 触发间隔 以秒为单位
        static let TriggerCount              = "rate_split_count"
        /// appstre 链接
        static let ReviewURL                 = "rate_app_store_url"
        /// 点击评论间隔多久可以认为是评论成功
        static let TimeIntervalReview        = "rate_app_store_timeInterval"
        
        static let AlertTitle                = "rate_alert_title_key"
        static let ContentTitle              = "rate_content_title_key"
        static let ConfirmTitle              = "rate_confirm_title_key"
        
        /// UserDefaults
        static let ReviewInfo                = "nov_app_review_info"
        /// 是否已经显示过
        static let ReviewHadShow             = "nov_app_review_had_show"
        /// 当前显示的次数
        static let ReviewCurrentShowCount    = "nov_app_review_current_cout"
        /// 当前间隔数 跟 TriggerCount 比对
        static let ReviewCurrentTriggerCount = "nov_app_review_trigger_cout"
    }
}


public class NOVAppReview: NSObject {
    
    private var reviewInfo: [String: Any]!
    private var needCheckReviewResult = false
    private var timeGotoAppStore: TimeInterval = 0
    
    private override init() {
        
        if let info = UserDefaults.standard.object(forKey: Key.ReviewInfo) as? [String: Any] {
            reviewInfo = info
        } else {
            reviewInfo = [
                Key.ReviewHadShow:             false,
                Key.ReviewCurrentShowCount:    0,
                Key.ReviewCurrentTriggerCount: 0,
            ]
        }
    }
    
    @objc public static let shared = NOVAppReview()

    @objc public func showReview() {
        // 1.已经显示了直接返回
        guard reviewHadShow() == false else { return }
        
        // 2.获取网络配置文件
        NOVRemoteConfig.shared.setup()
        
        guard let info = NOVRemoteConfig.shared.configs else { return }

        /**
        #if DEBUG
        let path = Bundle.main.path(forResource: "test", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let info = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
        #else
        guard let info = NOVRemoteConfig.shared.configs else { return }
        #endif
        */
        
        // 2.1 把间隔保存起来
        reviewInfo[Key.TimeIntervalReview] = info[Key.TimeIntervalReview]
        
        // 3.判断评论是否开启 没有获取到或者是false返回
        guard let enable = info[Key.EnableKey] as? Bool,
            enable == true else { return }
        
        // 4.比对最大数 没有获取到或者不大于当前的(<=)就返回
        // to-do: 没有获取到最大数就是无限大?
        guard let maxCount = info[Key.MaxCount] as? Int else { return }
        let currentCount = getCurrentShowCount()
        guard currentCount < maxCount else { return }
        
        // 5.比对间隔数
        guard let triggerCount = info[Key.TriggerCount] as? Int else { return }
        let currentTriggerCount = getCurrentTriggerCount()
        if currentTriggerCount < triggerCount {
            // 0 1 2 3 --- 3
            // 间隔3次 是在第4次时弹出 默认置为0
            // 少于就是还没有到 把currentTriggerCount+1, 返回
            currentTriggerCountAddOne()
            return
        }
        
        // 6.显示评论
        showReviewAlert(with: info)

        // to-do 如果是已经点击了评论, 可以忽略下面的操作
        
        // 7.更新已经显示的次数
        currentShowCountAddOne()
        
        // 8.重置currentTriggerCount
        resetCurrentTriggerCount()
    }
}

extension NOVAppReview {
    
    private func showReviewAlert(with info: [String : Any]) {
        
        guard let appstore_url = info[Key.ReviewURL] as? String else { return }
        
        var title = "提示"
        if let info_title = info[Key.AlertTitle] as? String {
            title = info_title
        }
        
        var content = "快去给个好评吧!"
        if let info_content = info[Key.ContentTitle] as? String {
            content = info_content
        }
        
        var confim = "确定"
        if let info_confim = info[Key.ConfirmTitle] as? String {
            confim = info_confim
        }
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: "取消"), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let appStoreAction = UIAlertAction(title: NSLocalizedString(confim, comment: confim), style: .default, handler: { (_) in
            self.gotoAppStore(appstore_url)
        })
        alert.addAction(appStoreAction)

        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    
    
    private func gotoAppStore(_ urlStr: String) {
        
        guard let url = URL(string: urlStr) else { return }
        
        needCheckReviewResult = true
        timeGotoAppStore = Date().timeIntervalSince1970
        
        DispatchQueue.once(block: {
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil, using: { (_) in
                self.checkReviewResult()
            })
        })
        
        UIApplication.shared.open(url)

    }
    
    private func checkReviewResult() {
        guard needCheckReviewResult == true else { return }
        needCheckReviewResult = false
        
        var interval = 4.0
        if let info_interval = reviewInfo[Key.TimeIntervalReview] as? Double {
            interval = info_interval
        }
        
        let currentTimeInterval = Date().timeIntervalSince1970
        if currentTimeInterval - timeGotoAppStore > interval {
            // 认为评论了
            
            // 显示完成后 修改参数
            reviewFinishShow()
           
            // 发送通知给外界
            NotificationCenter.default.post(name: NSNotification.Name.init(NOVAppReviewNeedRewarded), object: nil)
            
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        
    }
}


extension NOVAppReview {
    
    private func reviewHadShow() -> Bool {
        if let bl = reviewInfo[Key.ReviewHadShow] as? Bool {
            return bl
        } else {
            return false
        }
    }
    
    private func getCurrentShowCount() -> Int {
        if let count = reviewInfo[Key.ReviewCurrentShowCount] as? Int {
            return count
        } else {
            return 0
        }
    }
    
    private func currentShowCountAddOne() {
        if let count = reviewInfo[Key.ReviewCurrentShowCount] as? Int {
            reviewInfo[Key.ReviewCurrentShowCount] = count + 1
            UserDefaults.standard.setValue(reviewInfo, forKey: Key.ReviewInfo)
        }
    }
    
    private func getCurrentTriggerCount() -> Int {
        if let count = reviewInfo[Key.ReviewCurrentTriggerCount] as? Int {
            return count
        } else {
            return Int.max
        }
    }
    
    private func currentTriggerCountAddOne() {
        if let count = reviewInfo[Key.ReviewCurrentTriggerCount] as? Int {
            reviewInfo[Key.ReviewCurrentTriggerCount] = count + 1
            UserDefaults.standard.setValue(reviewInfo, forKey: Key.ReviewInfo)
        }
    }
    
    private func resetCurrentTriggerCount() {
        reviewInfo[Key.ReviewCurrentTriggerCount] = 0
        UserDefaults.standard.setValue(reviewInfo, forKey: Key.ReviewInfo)
    }
    
    private func reviewFinishShow() {
        if let _ = reviewInfo[Key.ReviewHadShow] as? Bool {
            reviewInfo[Key.ReviewHadShow] = true
            UserDefaults.standard.setValue(reviewInfo, forKey: Key.ReviewInfo)
        }
    }
}



