//
//  HistoryDataSource.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/10.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import UIKit
import RealmSwift

extension ConvertViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // 取得したリストからn番目を変数に代入
        let item: HistoryModel = self.historyItems.reversed()[(indexPath as NSIndexPath).row]

        // 取得した情報をセルに反映
        cell.textLabel?.text = item.contentKanji
        cell.detailTextLabel?.text = item.contentRubi

        return cell
    }

    // セルの編集を可能にする
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let realm = try! Realm()

        if editingStyle == .delete {
            try! realm.write {
                realm.delete(self.historyItems.reversed()[(indexPath as NSIndexPath).row])
            }
            self.historyTableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
