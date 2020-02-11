//
//  HistoryModel.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/10.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryModel: Object {
    @objc dynamic var contentKanji: String? = nil
    @objc dynamic var contentRubi: String? = nil
}
