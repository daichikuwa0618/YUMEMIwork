//
//  ViewController.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var kanaSelect: UISegmentedControl!
    
    private var convertOutputStyle: String = "hiragana"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        inputTextView.placeholder = "変換したいテキストを入力してください"
    }
    
    // 変換ボタンが押されたときの処理
    @IBAction func tapConvert(_ sender: Any) {
        
        let japaneseSentence: String = inputTextView.text ?? ""
        APIClient().convert(japaneseSentence, convertOutputStyle) { text in
            self.outputLabel.text = text
            self.outputLabel.textColor = UIColor.label
        }
        // キーボードを閉じる
        inputTextView.endEditing(true)
    }
    
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
    
    // ラベルがタップされたときの処理
    @IBAction func tapLabel(_ sender: Any) {
        UIPasteboard.general.string = outputLabel.text
        print("clipboard copied: \(UIPasteboard.general.string!)")
    }
}

