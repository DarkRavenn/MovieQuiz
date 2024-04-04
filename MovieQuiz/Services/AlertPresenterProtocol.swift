//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

protocol AlertPresenterProtocol {
    func requestAlert(with alertModel: AlertModel?)
    func show(quiz result: AlertModel) -> UIAlertController
}
