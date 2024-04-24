//
//  ApiCaller.swift
//  CombineIntro
//
//  Created by PowerMac on 24.04.2024.
//

import Foundation
import Combine


class APICaller {
    static let shared = APICaller()
    
    func fetchCompanies() -> Future<[String], Error> {
        return Future { promixe in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promixe(.success(["Apple", "Google", "Microsoft", "Amazon"]))
            }
        }
    }
}
