//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func requestResultAlert(with statistic: String?) {
        guard let statistic = statistic  else {
            return
        }
        delegate?.showAlert(alert: show(quiz: preparationAndTransmissionOfAlertModel(with: statistic)))
    }
    
    func preparationAndTransmissionOfAlertModel(with statistic: String) -> AlertModel {
        let alertModel: AlertModel = AlertModel(
             title: "Этот раунд окончен!",
             text: statistic,
             buttonText: "Сыграть еще раз",
             completion: {_ in
                 print("Кнопка Сыграть еще раз была нажата!")
                 self.delegate?.restartGame()
             })
        return alertModel
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
