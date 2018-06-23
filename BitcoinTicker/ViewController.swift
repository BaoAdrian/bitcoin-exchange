//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Adrian Bao on 6/12/2018
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var currencySelected = ""
    
    var finalURL = ""

    // IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }
    
    
    
    
    // Tells the UIPickerView that we only have one column of items to choose from
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Returns the number of currency options to choose from
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // Grabs the title for the specified row in order to use that data to grab the correct equivalencies
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        // Creates the final URL needed to get specified information
        finalURL = baseURL + currencyArray[row]
        // print(finalURL)
        
        // Getting currency symbol
        currencySelected = currencySymbolArray[row]
        
        // Pass this url to update app
        getBitcoinData(url: finalURL)
        
    }
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    // print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    

    //MARK: - JSON Parsing
    /***************************************************************/

    func updateBitcoinData(json : JSON) {

        // Gets the current asking price of Bitcoin
        if let bitcoinResults = json["ask"].double {
            
            // Update price label
            bitcoinPriceLabel.text = currencySelected + String(format: "%.2f", bitcoinResults)
            
        } else {
            
            // Some Error occurred
            bitcoinPriceLabel.text = "Price Unavailable"
            
        }

        
    }





}

