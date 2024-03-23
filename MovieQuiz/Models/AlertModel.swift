//
//  1.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

// вью модель для состояния "Результат квиза"
struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
