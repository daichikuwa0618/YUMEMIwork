//
//  APIClient.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import Foundation
import Alamofire

class APIClient: APIClientType {
    
    func convert(_ japaneseString: String, _ outputStyle: String, completionHandler: @escaping (String) -> Void) {

        // API URL
        let url = "https://labs.goo.ne.jp/api/hiragana"
        let appId = "279f620fb4f3b2aa347fd421071581c3bc64b2838efda477756521b5acec801b"
        let parameters = ["app_id": appId, "sentence": japaneseString, "output_type": outputStyle]
        
        Alamofire.request(url, method: .post, parameters: parameters).response { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let task: GooTask = try decoder.decode(GooTask.self, from: data)
                print(task.converted)
                completionHandler(task.converted)
            } catch {
                print(error)
            }
        }
    }
}
