//
//  AutomaticExchangeRatesGenerator.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

//import Foundation
//
//class AutomaticExchangeRatesGenerator {
//    static func generateRates(currencies: [String], exchangeRates: [String: Double], flags: [String: String]) -> [String] {
//        let automaticExchangeRates: [String] = currencies.compactMap { currency in
//            if currency.localizedCaseInsensitiveCompare("EUR") == .orderedSame {
//                return nil
//            }
//
//            let rate = exchangeRates[currency] ?? 0.0
//
//            let formatter = NumberFormatter()
//            formatter.minimumFractionDigits = 2
//            formatter.maximumFractionDigits = 4
//            formatter.numberStyle = .decimal
//
//            guard let formattedRate = formatter.string(from: NSNumber(value: rate)) else {
//                print("Formatting Error for \(currency)")
//                return "1 \(flags[currency] ?? "") = \(rate) \(currency)"
//            }
//            return "\(flags[currency] ?? "") 1 EUR = \(formattedRate) \(currency)"
//        }
//
//        return automaticExchangeRates
//    }
//}
import Foundation

class AutomaticExchangeRatesGenerator {
    static func generateRates(currencies: [String], exchangeRates: [String: Double], flags: [String: String], baseCurrency: String) -> [String] {
        var rates = [String]()
        
        for currency in currencies {
            if currency != baseCurrency, let rate = exchangeRates[currency] {
                let flag = flags[currency] ?? ""
                let formattedRate = String(format: "%.4f", rate)
                rates.append("\(flag) = \(formattedRate) \(currency)")
            }
        }
        
        return rates
    }
}



