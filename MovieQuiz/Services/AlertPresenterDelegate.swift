//
//  1.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alert: UIAlertController?)
    func restartGame()
}
