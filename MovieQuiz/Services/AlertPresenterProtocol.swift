//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

protocol AlertPresenterProtocol {
    func requestResultAlert(with statistic: String?)
    func preparationAndTransmissionOfAlertModel(with statistic: String) -> AlertModel
    func show(quiz result: AlertModel) -> UIAlertController
}
