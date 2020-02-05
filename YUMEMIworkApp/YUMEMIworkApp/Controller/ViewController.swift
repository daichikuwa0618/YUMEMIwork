//
//  ViewController.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class ViewController: UIViewController, UINavigationBarDelegate {
    
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
        
        inputTextView.layer.cornerRadius = 5
        outputTextView.layer.cornerRadius = 5
    }
    
    // 変換ボタンが押されたときの処理
    @IBAction func tapConvert(_ sender: Any) {
        
        let japaneseSentence: String = inputTextView.text ?? ""
        APIClient().convert(japaneseSentence, convertOutputStyle) { text in
            self.outputTextView.text = text
            self.outputTextView.textColor = UIColor.label
        }
        // キーボードを閉じる
        inputTextView.endEditing(true)
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
    
    // 出力がタップされたときの処理
    @IBAction func tapOutput(_ sender: Any) {
        UIPasteboard.general.string = outputTextView.text
        print("clipboard: \(UIPasteboard.general.string!)")
    }
    
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

