//
//  ViewController.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import PKHUD

class ConvertViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var kanaSelect: UISegmentedControl!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var outputTextView: UITextView!
    
    private var convertOutputStyle: String = "hiragana"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationBar.delegate = self
        
        inputTextView.placeholder = "ここに変換するテキストを入力してください"
        outputTextView.placeholder = "読みがなが出力されます"
        
        inputTextView.tintColor = UIColor.BlogBlue()
        
        convertButton.layer.shadowOpacity = 0.4
        convertButton.layer.shadowColor = UIColor.black.cgColor
        convertButton.layer.shadowRadius = 7
        convertButton.layer.shadowOffset = CGSize(width: 1, height: 1)

        // HUD アニメーション
        HUD.dimsBackground = false // アニメーション時の暗転をなくす
    }

    // 変換ボタンが押されたときの処理
    @IBAction func tapConvert(_ sender: Any) {
        
        // input が空の時
        if inputTextView.text == "" {
            
            print("Do nothing because: Empty input textview")

        } else {
            
            HUD.show(.progress)
            outputTextView.text = ""
            outputTextView.placeholder = "変換中"
            let japaneseSentence = inputTextView.text ?? ""
            APIClient().convert(japaneseSentence, convertOutputStyle) { result in
                if result == "error" {
                    HUD.hide() // dismiss progress anim.
                    HUD.flash(.labeledError(title: "失敗しました", subtitle: ""), delay: 0.8)
                } else {
                    self.outputTextView.text = result
                    self.outputTextView.textColor = UIColor.label
                    HUD.hide() // dismiss progress anim.
                }
            }
            // キーボードを閉じる
            inputTextView.endEditing(true)
        }
    }

    // SegmentControl の処理 (ひらがな，カタカナ切り替え)
    @IBAction func kanaSelectControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            convertOutputStyle = "hiragana"
        case 1:
            convertOutputStyle = "katakana"
        default:
            convertOutputStyle = "hiragana"
        }
    }
    
    // TextView とキーボード以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 出力がタップされたときの処理 (コピー)
    @IBAction func tapOutput(_ sender: Any) {
        UIPasteboard.general.string = outputTextView.text
        print("clipboard: \(UIPasteboard.general.string!)")
        HUD.flash(.labeledSuccess(title: "コピーしました", subtitle: ""), delay: 0.3)
    }
    
    // ナビゲーションバーとステータスバーの境目をなくす
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

