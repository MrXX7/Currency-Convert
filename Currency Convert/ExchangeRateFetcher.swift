//
//  ExchangeRateFetcher.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Alamofire
import Foundation

class ExchangeRateFetcher {
    static func fetchRates(apiKey: String, selectedCurrencyIndex: Int, currencies: [String], completion: @escaping ([String: Double]) -> Void) {
        let url = "https://open.er-api.com/v6/latest/\(currencies[selectedCurrencyIndex])?apikey=\(apiKey)"

        AF.request(url).responseDecodable(of: ExchangeRatesResponse.self) { response in
            guard let rates = response.value?.rates else {
                return
            }

            DispatchQueue.main.async {
                completion(rates)
            }
        }
    }
}

