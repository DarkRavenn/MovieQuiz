//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func requestAlert(with alertModel: AlertModel?) {
        guard let statistic = alertModel  else {
            return
        }
        delegate?.showAlert(alert: show(quiz: statistic))
    }

    func show(quiz result: AlertModel) -> UIAlertController {
                let alert = UIAlertController(
                    title: result.title,
                    message: result.text,
                    preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: result.completion)
        
                alert.addAction(action)
        
        return alert
    }
    

    
}
