//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 23.03.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
