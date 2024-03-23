//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func requestResultAlert(correctAnswers: Int?) {
        guard let correctAnswers = correctAnswers else {
            return
        }
        delegate?.showAlert(alert: show(quiz: prepareAlertModel(correctAnswers)))
    }
    
    private func prepareAlertModel(_ correctAnswers: Int) -> AlertModel {
        let alertModel: AlertModel = AlertModel(
             title: "Этот раунд окончен!",
             text: "Ваш результат: \(correctAnswers)/10",
             buttonText: "Сыграть еще раз",
             completion: {_ in
                 self.delegate?.restartGame()
             })
        return alertModel
    }

    private func show(quiz result: AlertModel) -> UIAlertController {
                let alert = UIAlertController(
                    title: result.title,
                    message: result.text,
                    preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: result.completion)
        
                alert.addAction(action)
        
        return alert
    }
    

    
}
