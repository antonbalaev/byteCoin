//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Antony Balaev on 07/01/2021.
//  Copyright © 2021 Antony Balaev. All rights reserved.
//

import Foundation

//Создаем протокол
protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "42D0DEC8-6CE4-4BE9-B8AC-FFCFDA2534D3"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    //MARK: - getCoinPrice
    
    func getCoinPrice(for currency: String) {
//        Настраиваем нужную ссылку
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
//        Настраиваем джейсон
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
//                        Отправляем полученную цену в вьюконтроллер и валюту рикошетим туда же
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    //MARK: - parseJSON
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            print(error)
            return nil
        }
    }
}


