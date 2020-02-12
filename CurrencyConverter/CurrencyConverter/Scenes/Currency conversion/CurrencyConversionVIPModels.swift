//
//  CurrencyConversionModels.swift
//  CurrencyConverter
//
//  Created by Tiago Chaves on 09/02/20.
//  Copyright (c) 2020 Tiago Chaves. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum CurrencyConversion {
    // MARK: -
    enum LoadSupportedCurrencies {
        struct Request {
        }
        
        struct Response {
            let success: Bool
        }
        
        struct ViewModel {
            let currencies: [Currency]
        }
    }
    
    // MARK: -
    enum GetExchangeRates {
        struct Request {
        }
        
        struct Response {
            let success: Bool
        }
        
        struct ViewModel {
        }
    }
    
    //MARK: -
    enum FormatTextField {
        struct Request {
            let textFieldValue: String
            let newText: String
            let currencyInitials: String
            let textField: TextFieldCurrencyType
        }
        
        struct Response {
            let number: Double
            let currencyInitials: String
            let textField: TextFieldCurrencyType
        }
        
        struct ViewModel {
            let formattedText: String
            let textField: TextFieldCurrencyType
        }
    }
    
    //MARK: -
    enum ConvertValue {
        struct Request {
            let sourceInitials: String
            let sourceValue: String
            let resultInitials: String
            let textField: TextFieldCurrencyType
        }
        
        struct Response {
        }
        
        struct ViewModel {
            let resultValue: String
        }
    }
}
