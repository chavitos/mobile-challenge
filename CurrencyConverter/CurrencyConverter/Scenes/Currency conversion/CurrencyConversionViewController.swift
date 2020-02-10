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
}

class CurrencyConversionViewController: UIViewController, CurrencyConversionDisplayLogic {
    var interactor: CurrencyConversionBusinessLogic?
    
    // MARK: - Object lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
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
        setup()
        getSupportedCurrencies()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    private func getSupportedCurrencies() {
        interactor?.getSupportedCurrencies()
    }
    
    func loadSupportedCurrencies(viewModel: CurrencyConversion.LoadSupportedCurrencies.ViewModel) {
        print(viewModel.currencies)
    }
    
    func displayErrorMessage(_ message: String) {
        print("error")
    }
}
