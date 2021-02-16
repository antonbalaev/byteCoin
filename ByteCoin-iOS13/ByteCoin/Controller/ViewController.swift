//
//  ViewController.swift
//  ByteCoin
//
//  Created by Antony Balaev on 07/01/2021.
//  Copyright © 2021 Antony Balaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    Переносим кнопки и лейблы
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
//    Представляем тут коин менеджер
    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Ставим делегатами себя
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String) {
        
//        При обновлении цены меняем лейблы на нужную инфу
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return coinManager.currencyArray.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return coinManager.currencyArray[row]
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        При выборе определенной валюты запускается эта функция
          let selectedCurrency = coinManager.currencyArray[row]
          coinManager.getCoinPrice(for: selectedCurrency)
      }
}

