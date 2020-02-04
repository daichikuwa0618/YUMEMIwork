//
//  APIClientProtocol.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import Foundation

protocol APIClientType {

    func convert(_ japaneseString: String, _ outputStyle: String, completionHandler: @escaping (String) -> Void)
}