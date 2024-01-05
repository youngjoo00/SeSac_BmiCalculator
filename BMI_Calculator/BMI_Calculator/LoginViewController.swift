//
//  LoginViewController.swift
//  BMI_Calculator
//
//  Created by youngjoo on 1/4/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nicknameTextField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var logoutBtn: UIButton!
    
    var isLogin: Bool = false
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitleLabel(titleLabel)
        setNicknameTextField(nicknameTextField)
        setBtn(loginBtn, title: "Login", backgroundColor: .purple)
        setBtn(logoutBtn, title: "Logout", backgroundColor: .lightGray)
        showBtn()
    }
    
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        
        if let nickname = nicknameTextField.text, nickname != "" {
            loginAlert("\(nickname)", title: "로그인이 완료되었습니다!")
        } else {
            descriptionAlert(title: "로그인에 실패했습니다", message: "닉네임을 입력해주세요.")
        }
        checkedLogin()
        setTitleLabel(titleLabel)
        setNicknameTextField(nicknameTextField)
        showBtn()
    }
    
    @IBAction func logoutBtnClicked(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "nickname")
        UserDefaults.standard.removeObject(forKey: "savedWeight")
        UserDefaults.standard.removeObject(forKey: "savedHeight")
        descriptionAlert(title: "로그아웃에 성공했습니다!", message: "")
        checkedLogin()
        setTitleLabel(titleLabel)
        setNicknameTextField(nicknameTextField)
        showBtn()
        
    }
    
    func setTitleLabel(_ titleLabel: UILabel) {
        checkedLogin()
        if let nickname {
            titleLabel.text = "안녕하세요! \(nickname)님"
        } else {
            titleLabel.text = "안녕하세요! 로그인 하시겠어요?"
        }
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    func setNicknameTextField(_ nicknameTF: UITextField) {
        if isLogin {
            nicknameTF.text = nickname
        } else {
            nicknameTF.text = ""
        }
        nicknameTF.placeholder = "닉네임을 입력하세요."
    }
    
    func loginAlert(_ nickname: String, title: String) {
        UserDefaults.standard.set(nickname, forKey: "nickname")
        print(nickname)
        let alert = UIAlertController(title: title, message: "\(nickname)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "ok", style: .default)
        
        alert.addAction(confirmButton)
        present(alert, animated: true)
    }

    func descriptionAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "ok", style: .default)
        
        alert.addAction(confirmButton)
        present(alert, animated: true)
    }
    
    func setBtn(_ btn: UIButton, title: String, backgroundColor: UIColor) {
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = backgroundColor
    }
    
    func checkedLogin() {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else {
            isLogin = false
            self.nickname = nil
            return
        }
        
        isLogin = true
        self.nickname = nickname
    }
    
    func showBtn() {
        if isLogin {
            logoutBtn.isHidden = false
            loginBtn.isHidden = true
        } else {
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
        }
    }
}
