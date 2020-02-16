//
//  APIClientProtocol.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import Foundation

typealias APIClientResult = Result<String, APIError>

protocol APIClientType {

    func convert(_ japaneseString: String, _ outputStyle: String, completionHandler: @escaping (APIClientResult) -> Void)
}
