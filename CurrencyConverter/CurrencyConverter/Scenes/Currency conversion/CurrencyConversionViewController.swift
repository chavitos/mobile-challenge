//
//  CurrencyConversionViewController.swift
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

protocol CurrencyConversionDisplayLogic: class {
    func loadSupportedCurrencies(viewModel: CurrencyConversion.LoadSupportedCurrencies.ViewModel)
    func displayErrorMessage(_ message:String)
    func exchangeRatesLoaded()
    func displayFormattedValue(viewModel: CurrencyConversion.FormatTextField.ViewModel)
}

class CurrencyConversionViewController: UIViewController, CurrencyConversionDisplayLogic {
    var interactor: CurrencyConversionBusinessLogic?
    
    // MARK: - Object lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupVipCycle()
    }
    
    // MARK: - Setup
    private func setupVipCycle() {
        let viewController = self
        let interactor = CurrencyConversionInteractor()
        let presenter = CurrencyConversionPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVipCycle()
        setupTextFields(textFields: [sourceValueTextField])
        getSupportedCurrencies()
        getExchangeRates()
    }
    
    @IBOutlet weak var sourceValueTextField: UITextField!
    @IBOutlet weak var resultValueTextField: UITextField!
    @IBOutlet weak var sourceCurrencyButton: UIButton!
    @IBOutlet weak var resultCurrencyButton: UIButton!
    
    //MARK: - App data setup
    private func getSupportedCurrencies() {
        interactor?.getSupportedCurrencies()
    }
    
    private func getExchangeRates() {
        interactor?.getExchangeRates()
    }
    
    //MARK: - Load supported currencies
    func loadSupportedCurrencies(viewModel: CurrencyConversion.LoadSupportedCurrencies.ViewModel) {
        print(viewModel.currencies)
    }
    
    //MARK: - Exchange rates loaded
    func exchangeRatesLoaded() {
        interactor?.convertCurrency(request: CurrencyConversion.ConvertValue.Request(sourceInitials: "BRL",
                                                                                     sourceValue: "1,0",
                                                                                     resultInitials: "AWG",
                                                                                     textFieldTag: 1))
    }
    
    //MARK: - Error handle
    func displayErrorMessage(_ message: String) {
        print("error")
    }
    
    //MARK: - Show Formatted Value
    func displayFormattedValue(viewModel: CurrencyConversion.FormatTextField.ViewModel) {
        if viewModel.textFieldTag == 0 {
            self.sourceValueTextField.text = viewModel.formattedText
            
            interactor?.convertCurrency(request: CurrencyConversion.ConvertValue.Request(sourceInitials: "USD",
                                                                                         sourceValue: viewModel.formattedText,
                                                                                         resultInitials: "BRL",
                                                                                         textFieldTag: 1))
        } else if viewModel.textFieldTag == 1 {
            self.resultValueTextField.text = viewModel.formattedText
        }
    }
}

//MARK: - Text field delegate
extension CurrencyConversionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let request = CurrencyConversion.FormatTextField.Request(textFieldValue: textField.text ?? "",
                                                                 newText: string,
                                                                 currencyInitials: "USD",
                                                                 textFieldTag: 0)
        interactor?.convertStringValueInNumber(request: request)
        return false
    }
}
