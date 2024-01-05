//
//  ViewController.swift
//  BMI_Calcurator
//
//  Created by youngjoo on 1/3/24.
//

import UIKit

// 함수를 추가할수록 뭔가 로직이 점점 이상해진다.
// 로그인 or 로그아웃 시 바로 화면에 적용되도록 하고 싶지만 시간관계상 다음에,,
class ViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var askHeightLabel: UILabel!
    @IBOutlet var askWeightLabel: UILabel!
    
    @IBOutlet var inputHeightTextField: UITextField!
    @IBOutlet var inputWeightTextField: UITextField!
    
    @IBOutlet var randomCalculatorBtn: UIButton!
    @IBOutlet var resultBtn: UIButton!
    
    @IBOutlet var hideBtn: UIButton!
    
    @IBOutlet var resetInfoBtn: UIButton!
    
    var height: Double = 0
    var weight: Double = 0
    var isLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "BMI Calculator"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        setSubtitleLabel(subtitleLabel)
        
        mainImageView.image = UIImage(named: "image")
        mainImageView.contentMode = .scaleToFill
        
        askHeightLabel.text = "키가 어떻게 되시나요?"
        askWeightLabel.text = "몸무게는 어떻게 되시나요?"
        
        checkedLogin()
        
        setInputTextField(inputHeightTextField, placeholder: "키를 입력해주세요.")
        setInputTextField(inputWeightTextField, placeholder: "몸무게를 입력해주세요.")
        
        randomCalculatorBtn.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomCalculatorBtn.setTitleColor(.purple, for: .normal)

        inputWeightTextField.isSecureTextEntry = true
        hideBtnClicked(hideBtn)
        hideBtn.tintColor = .lightGray
        
        resultBtn.setTitle("결과 확인", for: .normal)
        resultBtn.layer.cornerRadius = 20
        resultBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        setResetInfoBtn(resetInfoBtn)
        vaildationTextField()
    }

    // Bmi 계산함수 호출한 뒤, 알람창만 띄우는 역할
    @IBAction func resultBtnClicked(_ sender: UIButton) {
        
        let bmi = bmiCalculate()
        
        if bmi < 18.5 {
            showAlert(bmi, message: "저체중")
        } else if bmi < 23 {
            showAlert(bmi, message: "정상")
        } else if bmi < 25 {
            showAlert(bmi, message: "과체중")
        } else {
            showAlert(bmi, message: "비만")
        }
        
        if isLogin {
            UserDefaults.standard.set(self.height, forKey: "savedHeight")
            UserDefaults.standard.set(self.weight, forKey: "savedWeight")
            print("저장완료")
        }
    }
    
    @IBAction func randomBmiBtnClicked(_ sender: UIButton) {
        let randomHeight = Double.random(in: 100...200)
        let randomWeight = Double.random(in: 40...100)
        inputHeightTextField.text = String(format: "%.1f", randomHeight)
        inputWeightTextField.text = String(format: "%.1f", randomWeight)
        
        vaildationTextField()
    }
    
    // 텍스트 필드가 수정되거나, 수정이 끝났을때 검사
    @IBAction func changedTextField(_ sender: UITextField) {
        vaildationTextField()
    }
    
    @IBAction func didEndTextField(_ sender: UITextField) {
        vaildationTextField()
    }
    
    @IBAction func hideBtnClicked(_ sender: UIButton) {
        // 비밀번호 입력처럼 가려져야 하고, 이미지가 변경되어야 함
        
        inputWeightTextField.isSecureTextEntry.toggle()
        
        if inputWeightTextField.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func returnKeyboardClicked(_ sender: UITextField) {
        view.endEditing(true)
    }
    
    @IBAction func resetInfoBtnClicked(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "savedWeight")
        UserDefaults.standard.removeObject(forKey: "savedHeight")
        
        inputHeightTextField.text = ""
        inputWeightTextField.text = ""
        vaildationTextField()
    }
    
    func showAlert(_ bmi: Double, message: String) {
        let bmi = String(format: "%.2f", bmi)
        let alert = UIAlertController(title: "당신의 BMI 지수는 \(bmi) 입니다.", message: message, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "ok", style: .default)
        
        alert.addAction(confirmButton)
        
        present(alert, animated: true)
    }
    
    func vaildationTextField() {
        
        if let weight = Double(inputWeightTextField.text!), let height = Double(inputHeightTextField.text!), (weight > 0 && weight < 500), (height > 0 && height < 300) {
            designResultBtn(resultBtn, enabled: true)
            self.weight = Double(String(format: "%.1f", weight))!
            self.height = Double(String(format: "%.1f", height))!
        } else {
            designResultBtn(resultBtn, enabled: false)
        }
    }
    
    func bmiCalculate() -> Double {
        let bmi = self.weight / (self.height * self.height) * 10000
        return bmi
    }
    
    func setInputTextField(_ tf: UITextField, placeholder: String) {
        if isLogin {
            let info = checkedInfo()
            print("정보 가져옴")
            if info.isInfo {
                inputHeightTextField.text = info.savedHeight
                print(info.savedHeight)
                inputWeightTextField.text = info.savedWeight
            }
        } else {
            inputHeightTextField.text = ""
            inputWeightTextField.text = ""
        }
        
        tf.placeholder = placeholder
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.black.cgColor
        tf.keyboardType = .decimalPad
    }
    
    // userDefaluts 로 저장된 몸무게와 키가 있는지 확인하는 코드를 중복 없이 한 번만 확인해서 가져오기 위해
    // 리턴 값을 여러개로 줄 수 있는 방법 없는지 찾아본 결과 튜플을 이용한 리턴이 있었다,,
    func checkedInfo() -> (isInfo: Bool, savedWeight: String, savedHeight: String) {
        guard let savedWeight = UserDefaults.standard.string(forKey: "savedWeight"),
           let savedHeight = UserDefaults.standard.string(forKey: "savedHeight") else {
            return (false, "", "")
        }
        return (true, savedWeight, savedHeight)
    }
    
    func designResultBtn(_ resultBtn:UIButton, enabled: Bool) {
        resultBtn.isEnabled = enabled
        
        if resultBtn.isEnabled {
            resultBtn.setTitleColor(.white, for: .normal)
            resultBtn.backgroundColor = .purple
        } else {
            resultBtn.backgroundColor = .lightGray
            resultBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    func setSubtitleLabel(_ subtitle: UILabel) {
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            subtitleLabel.text = "\(nickname)님의 BMI 지수를\n알려드릴게요."
        } else {
            subtitleLabel.text = "손님의 BMI 지수를\n알려드릴게요."
        }
        
        subtitleLabel.numberOfLines = 0
    }
    
    func checkedLogin() {
        if let _ = UserDefaults.standard.string(forKey: "nickname") {
            isLogin = true
        } else {
            isLogin = false
        }
    }
    
    func setResetInfoBtn(_ btn: UIButton) {
        if isLogin {
            btn.isHidden = false
        } else {
            btn.isHidden = true
        }
        
        btn.setTitle("내 정보 초기화", for: .normal)
        btn.setTitleColor(.purple, for: .normal)
    }
}

