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
import RealmSwift

class ConvertViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var convertButton: GradientButton!
    @IBOutlet private weak var kanaSelect: UISegmentedControl!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var outputTextView: UITextView!
    @IBOutlet weak var historyTableView: UITableView!

    // MARK: - Property
    private var convertOutputStyle: String = "hiragana"
    var historyItems: Results<HistoryModel>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        
        navigationBar.delegate = self
        inputTextView.delegate = self
        historyTableView.dataSource = self as UITableViewDataSource

        //TODO: Localize
        inputTextView.placeholder = "ここに変換するテキストを入力してください"
        outputTextView.placeholder = "読みがなが出力されます"
        
        inputTextView.tintColor = .blogBlue

        convertButton.layer.masksToBounds = false
        convertButton.layer.shadowOpacity = 0.4
        convertButton.layer.shadowColor = UIColor.black.cgColor
        convertButton.layer.shadowRadius = 7
        convertButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        convertButton.setColor(isEnable: false)

        // HUD アニメーション
        HUD.dimsBackground = false // アニメーション時の暗転をなくす

        // history
        self.historyItems = realm.objects(HistoryModel.self)
    }

    // MARK: - IBAction
    @IBAction func tapConvert(_ sender: Any) {

        let realm = try! Realm()
        // historyModel をインスタンス化
        let historyModel: HistoryModel = HistoryModel()

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
                historyModel.contentKanji = self.inputTextView.text
                historyModel.contentRubi = self.outputTextView.text

                try! realm.write {
                    realm.add(historyModel)
                }
                self.historyTableView.reloadData()
                HUD.hide() // dismiss progress anim.
                // ボタンを無効にする
                self.convertButton.setColor(isEnable: false)
            }
            // キーボードを閉じる
            self.inputTextView.endEditing(true)
        }
    }

    // SegmentControl の処理 (ひらがな，カタカナ切り替え)
    @IBAction func kanaSelectControl(_ sender: UISegmentedControl) {

        convertOutputStyle = sender.selectedSegmentIndex == 1 ? "katakana" : "hiragana"
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

// MARK: - UINavigationBarDelegate
extension ConvertViewController: UINavigationBarDelegate {

}

// MARK: - UITextViewDelegate
extension ConvertViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        convertButton.setColor(isEnable: !inputTextView.text.isEmpty)
        // 入力が空の時
        if inputTextView.text.isEmpty {
            outputTextView.placeholder = "読みがなが出力されます"
        // 前回の変換から変更がない時
        } else if inputTextView.text == self.historyItems.last?.contentKanji {
            print("Do nothing because: No change from last time")
            convertButton.setColor(isEnable: false)
        }
    }
}
