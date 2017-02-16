//
//  CategoryGraphViewController.swift
//  SaltEdge
//
//  Created by SureshKumar on 16/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit
import Charts

class CategoryGraphViewController: UIViewController {
    
    var categories = [[Transaction]]()
    var dataEntries: [BarChartDataEntry] = []
    var colors: [UIColor] = []
    var xAxisValues : [String] = []
    var yAxisValues: [Double] = []

    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setXYAxisValues()
        setChart()
    }
    
    private func setChart(){
        
        var dataEntries: [BarChartDataEntry] = []
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisValues)
        
        for i in 0..<xAxisValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yAxisValues[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Amount")
        chartDataSet.colors = colors
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData

    }
    
    private func setXYAxisValues(){
        
        for transactions in categories{
            let color = generateColor()
            
            let income = transactions.filter { $0.amount.doubleValue > 0.0 }.reduce(0.0, {$1.amount.doubleValue + $0 })
           
            let expense = transactions.filter { $0.amount.doubleValue < 0.0 }.reduce(0.0, {$1.amount.doubleValue + $0 })
            
            if income > 0.0 {
                xAxisValues.append(transactions[0].category!)
                yAxisValues.append(income)
                colors.append(color)
            }
            
            if expense < 0.0 {
                xAxisValues.append(transactions[0].category!)
                yAxisValues.append(expense)
                colors.append(color)
            }
        }
    }
    
    private func generateColor() -> UIColor{
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)

    }

}
