//
//  ViewController.swift
//  LineLoginSample
//
//  Created by 苅米 春奈 on 2019/03/13.
//  Copyright © 2019 苅米 春奈. All rights reserved.
//

import UIKit
import LineSDK

final class ViewController: UIViewController {
    @IBOutlet weak var userIdLabel: UILabel! {
        didSet {
            userIdLabel.text = (UserDefaults.standard.object(forKey: "LineLoginUserIdKey")) as? String
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = (UserDefaults.standard.object(forKey: "LineLoginUserNameKey")) as? String
        }
    }
    
    @IBOutlet weak var statusLable: UILabel! {
        didSet {
            statusLable.text = (UserDefaults.standard.object(forKey: "LineLoginUserStatusKey")) as? String
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            
//            print(UserDefaults.standard.url(forKey: "LineLoginPictureKey")!)
            
            let url = UserDefaults.standard.url(forKey: "LineLoginPictureKey")
            do {
                if url != nil {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    userImageView.image = image
                }

            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
        }
        
    }
    @IBOutlet weak var reloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // アクセストークンの有効期限
        if let token = AccessTokenStore.shared.current {
            print("Token expires at:\(token.expiresAt)")
            print(token.expiresAt.toStringWithCurrentLocale())
        }
        /* あなたのアプリケーションやサーバーにプレーンテキストで機密のユーザデータを保存するか、または非セキュアHTTP通信を介してそれらを転送します。このようなデータには、アクセストークン、ユーザーID、ユーザー名、およびIDトークン内の任意の情報が含まれます。LINE SDKはあなたの代わりにユーザーのアクセストークンを保存します。必要に応じて、以下のコードを使用して承認後にアクセスできます。 */
        // 現在のアクセストークン
        if let token = AccessTokenStore.shared.current {
            print("Token value:\(token.value)")
            print("--------------------------")
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("ほげ")

//        [self.view setNeedsLayout];
//        [self.view layoutIfNeeded];
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userIdLabel.text = (UserDefaults.standard.object(forKey: "LineLoginUserIdKey")) as? String
        nameLabel.text = (UserDefaults.standard.object(forKey: "LineLoginUserNameKey")) as? String
        statusLable.text = (UserDefaults.standard.object(forKey: "LineLoginUserStatusKey")) as? String
        let url = UserDefaults.standard.url(forKey: "LineLoginPictureKey")
        do {
            if url != nil {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                userImageView.image = image
            }
            
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        print("ほげほげマガジン〜〜〜〜〜〜")
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        // ログイン
        login()
    }
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        // ログアウト
        logout()
    }

    @IBAction func didTapReload(_ sender: UIButton) {
        print("ほっげげっげゲゲゲっげ")
        self.view.setNeedsLayout()
        self.view.layoutSubviews()
    }
    func login() {
        LoginManager.shared.login(permissions: [.profile], in: self) {
            result in
            switch result {
            case .success(let loginResult):
                if let profile = loginResult.userProfile {
                    //  アプリ内へLINEログインで取得した情報を保存する
                    
                    UserDefaults.standard.set(profile.userID, forKey: "LineLoginUserIdKey")
                    UserDefaults.standard.set(profile.displayName, forKey: "LineLoginUserNameKey")
                    UserDefaults.standard.set(profile.pictureURL, forKey: "LineLoginPictureKey")
                    UserDefaults.standard.set(profile.statusMessage, forKey: "LineLoginUserStatusKey")
                    
                    print(profile.userID)
                    print(profile.displayName)
                    print(profile.pictureURL!)
//                    print(profile.statusMessage!)
                    
                    // 注意↓
                    print(UserDefaults.standard.object(forKey: "LineLoginPictureKey")!)
                    print(UserDefaults.standard.url(forKey: "LineLoginPictureKey")!)
                    
                    self.view.reloadInputViews()
                }
                //print(loginResult.accessToken.value)
                
            // Do other things you need with the login result
            case .failure(let error):
                print("エラー：",error)
            }
        }
    }
    
    func logout() {
        LoginManager.shared.logout { result in
            switch result {
            case .success:
                print("Logout from LINE")
            case .failure(let error):
                print(error)
            }
        }
    }
}



extension Date {
    
    func toStringWithCurrentLocale() -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }
    
}


