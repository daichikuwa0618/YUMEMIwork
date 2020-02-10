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
    @IBOutlet private weak var historyTableView: UITableView!

    // MARK: - Property
    private var convertOutputStyle: String = "hiragana"
    private var historyItems: Results<HistoryModel>!
    private let realm = try! Realm()
    
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
    // 変換ボタンが押されたときの処理
    @IBAction func tapConvert(_ sender: Any) {

        // historyModel をインスタンス化
        let historyModel: HistoryModel = HistoryModel()
        
        // input が空の時
        if inputTextView.text.isEmpty {

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
                    historyModel.content = self.inputTextView.text
//                    let realm = try! Realm()

                    try! self.realm.write {
                        self.realm.add(historyModel)
                    }
                    self.historyTableView.reloadData()
                    HUD.hide() // dismiss progress anim.
                }
            }
            // キーボードを閉じる
            inputTextView.endEditing(true)
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
        if inputTextView.text.isEmpty {
            outputTextView.placeholder = "読みがなが出力されます"
        }
    }
}

// MARK: - UITableViewDataSource
extension ConvertViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // 取得したリストからn番目を変数に代入
        let item: HistoryModel = self.historyItems.reversed()[(indexPath as NSIndexPath).row]

        // 取得した情報をセルに反映
        cell.textLabel?.text = item.content

        return cell
    }

    // セルの編集を可能にする
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let deleteHistory = self.historyItems![indexPath.row]
            try! realm.write {
                realm.delete(deleteHistory)
            }
            self.historyTableView.reloadData()
        }
    }
}
