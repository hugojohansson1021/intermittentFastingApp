//
//  WeightGoalDate.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-30.
//

import Foundation


func linearRegression(data: [(date: Date, weight: Double)]) -> (slope: Double, intercept: Double)? {
    guard data.count > 1 else { return nil }
    
    let sortedData = data.sorted(by: { $0.date < $1.date })
    let firstDate = sortedData.first!.date
    let xValues = sortedData.map { $0.date.timeIntervalSince(firstDate) / (60 * 60 * 24) }
    let yValues = sortedData.map { $0.weight }
    
    let n = Double(data.count)
    let sumX = xValues.reduce(0, +)
    let sumY = yValues.reduce(0, +)
    let sumXY = zip(xValues, yValues).map(*).reduce(0, +)
    let sumXSquare = xValues.map { $0 * $0 }.reduce(0, +)
    
    let slope = (n * sumXY - sumX * sumY) / (n * sumXSquare - sumX * sumX)
    let intercept = (sumY - slope * sumX) / n
    
    return (slope, intercept)
}


