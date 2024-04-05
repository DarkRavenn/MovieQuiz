//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 20.03.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didLoadDataFromServer(with errorMessage: String)
    func didFailToLoadData(with error: Error)
}
