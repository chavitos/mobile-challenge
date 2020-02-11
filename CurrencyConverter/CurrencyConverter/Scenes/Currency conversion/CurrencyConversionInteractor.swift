//
//  CurrencyConversionInteractor.swift
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

protocol CurrencyConversionBusinessLogic {
    func getSupportedCurrencies()
    func getExchangeRates()
    func convertCurrency(request: CurrencyConversion.ConvertValue.Request)
    func convertStringValueInNumber(request: CurrencyConversion.FormatTextField.Request)
}

protocol CurrencyConversionDataStore {
    var usdCurrencyQuotes: [USDCurrencyQuote] { get set }
}

class CurrencyConversionInteractor: CurrencyConversionBusinessLogic, CurrencyConversionDataStore {
    var presenter: CurrencyConversionPresentationLogic?
    var supportedCurrenciesWorker: SupportedCurrenciesWorkerProtocol
    var exchangeRatesWorker: ExchangeRatesWorkerProtocol
    var currencyConversionWorker: CurrencyConversionWorkerProtocol
    
    var usdCurrencyQuotes: [USDCurrencyQuote] = []
    
    init(supportedCurrenciesWorker: SupportedCurrenciesWorkerProtocol = NetworkSupportedCurrenciesWorker(dataManager: NetworkDataManager()),
         exchangeRatesWorker: ExchangeRatesWorkerProtocol = NetworkExchangeRatesWorker(dataManager: NetworkDataManager()),
         currencyConversionWorker: CurrencyConversionWorkerProtocol = CurrencyConversionWorker()) {
        self.supportedCurrenciesWorker = supportedCurrenciesWorker
        self.exchangeRatesWorker = exchangeRatesWorker
        self.currencyConversionWorker = currencyConversionWorker
    }
    
    // MARK: - Get Supported Currencies
    func getSupportedCurrencies() {
        supportedCurrenciesWorker.loadSupportedCurrencies { (currencies, error) in
            let response = CurrencyConversion.LoadSupportedCurrencies.Response(currencies: currencies, error: error)
            self.presenter?.formatCurrencyListForView(response: response)
        }
    }
    
    // MARK: - Get Exchange Rates
    func getExchangeRates() {
        exchangeRatesWorker.getExchangeRates(completion: { (exchangeRates, error) in
            var success = false
            if error == nil {
                if let exchangeRates = exchangeRates, exchangeRates.success {
                    self.usdCurrencyQuotes = exchangeRates.getUSDCurrencyQuotes()
                    success = true
                }
            }
            
            self.presenter?.getExchangeRatesStatus(response: CurrencyConversion.GetExchangeRates.Response(success: success))
        })
    }
    
    // MARK: - Convert currency
    func convertCurrency(request: CurrencyConversion.ConvertValue.Request) {
        guard let sourceValue = NumberFormatter().getNumberValue(of: request.sourceInitials, request.sourceValue)?.doubleValue,
            let sourceInitialsIndex = usdCurrencyQuotes.firstIndex(where: { $0.currencyInitials == request.sourceInitials }),
            let resultInitialsIndex = usdCurrencyQuotes.firstIndex(where: { $0.currencyInitials == request.resultInitials }) else {
                
                let response = CurrencyConversion.FormatTextField.Response(number: -1, currencyInitials: "", textFieldTag: request.textFieldTag)
                presenter?.formatNumericValueToText(response: response)
                return
        }
        
        let sourceDolarQuote = usdCurrencyQuotes[sourceInitialsIndex]
        let resultDolarQuote = usdCurrencyQuotes[resultInitialsIndex]
        
        let result = currencyConversionWorker.convert(sourceValue, currency: sourceDolarQuote, to: resultDolarQuote)
        
        let response = CurrencyConversion.FormatTextField.Response(number: result, currencyInitials: request.resultInitials, textFieldTag: request.textFieldTag)
        presenter?.formatNumericValueToText(response: response)
    }
    
    //MARK: - Convert string in numeric
    func convertStringValueInNumber(request: CurrencyConversion.FormatTextField.Request) {
        guard let value = NumberFormatter().getNumberValue(of: request.currencyInitials, request.textFieldValue)?.doubleValue else {
            return
        }
        
        var newValue: Double = 0.0
        
        if request.newText != "" {
            if let newValueToSum = Double(request.newText) {
                newValue = (value * 10) + (newValueToSum / 100)
            }
        } else {
            if value > 0 {
                newValue = (value / 10).truncate(places: 2)
            }
        }
        
        let response = CurrencyConversion.FormatTextField.Response(number: newValue, currencyInitials: request.currencyInitials, textFieldTag: request.textFieldTag)
        presenter?.formatNumericValueToText(response: response)
    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places))
    }
}
