//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 24.03.2024.
//

import Foundation

class StatisticServiceImplementation: StatisticService {
    weak var delegate: StatisticServiceImplementationDelegate?
    
    var totalAccuracy: Double {
        get {
            let totalAccuracy = userDefaults.double(forKey: Keys.correct.rawValue)
            return totalAccuracy
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return gamesCount
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        
        gamesCount += 1
        
        CalculationTotalAccuracy(correct: count, total: amount)
        
        let currentDate = Date()
        
        let currentGame = GameRecord(correct: count, total: amount, date: currentDate)
        if bestGame.isBetterThan(currentGame) {
        } else {
            bestGame = GameRecord(correct: count, total: amount, date: currentDate)
        }
        
        let statistic = """
             Ваш результат: \(currentGame.correct)/\(currentGame.total)
             Количество сыгранных квизов: \(gamesCount)
             Рекорд \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
             Средняя точность: \(String(format: "%.2f", totalAccuracy))%
             """
        returnFinished(statistic)
    }
    
    private func returnFinished(_ statistic: String) {
        delegate?.transmitting(statistic)
    }
    
    private func CalculationTotalAccuracy(correct count: Int, total amount: Int) {
        if gamesCount == 1 {
            totalAccuracy = (Double(count) / Double(amount)) * 100
        } else {
            totalAccuracy = ((totalAccuracy / 100 * ( Double(gamesCount) - 1 ) + Double(count) / Double(amount) ) / Double(gamesCount)) * 100
        }
    }
}
