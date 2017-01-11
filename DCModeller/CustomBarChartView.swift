//
//  customBarChartView.swift
//  DCModeller
//
//  Created by Daniel Jinks on 18/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import Charts

class CustomBarChartView: BarChartView {
    //var cornerRadius: CGFloat = 5.0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setAppearance()
    }
    
    func setAppearance() {
        
        //let barRenderer = renderer as! BarChartRenderer
        //barRenderer.cornerRadius = cornerRadius
        
        self.dragEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        
        self.drawValueAboveBarEnabled = false
        self.drawGridBackgroundEnabled = false
        self.drawBordersEnabled = false
        self.chartDescription?.text = ""
        self.legend.enabled = false
        self.drawBarShadowEnabled = false
        
        self.xAxis.enabled = true
        self.xAxis.drawLabelsEnabled = true
        self.xAxis.labelPosition = .bottom
        self.xAxis.drawLimitLinesBehindDataEnabled = false
        self.xAxis.drawGridLinesEnabled = false
        
        self.leftAxis.drawLabelsEnabled = true
        self.leftAxis.drawGridLinesEnabled = false
        self.leftAxis.drawTopYLabelEntryEnabled = true
        //self.leftAxis.enabled = false
        self.leftAxis.axisMinimum = 0.0
        
        self.rightAxis.drawLabelsEnabled = false
        self.rightAxis.enabled = false
        self.rightAxis.drawGridLinesEnabled = false
        self.rightAxis.drawAxisLineEnabled = false
        
        let myFont = UIFont(name: "ArialMT", size: 10.0 * getFontScalingForScreenSize())!
        //self.xAxis.setLabelsToSkip(0)
        self.xAxis.labelFont = myFont
        self.legend.font = myFont
        self.leftAxis.labelFont = myFont
        self.leftAxis.labelTextColor = GlobalConstants.ColorPalette.SecondaryColorLight
        
    }
    

    func setFundvalueBarChart(labels: [String], values: [Double], maxValue: Double, limitLine: Double) {
        
        self.leftAxis.axisMaximum = roundUpForAxisMax(maxValue)
        
        let formatter = createNumberFormatter(maxValue: maxValue, prefix: "£")
        
        var dataEntries: [BarChartDataEntry] = []
        
        if values.count == 1 {
            dataEntries.append(BarChartDataEntry(x: 0, y: 0))
            dataEntries.append(BarChartDataEntry(x: 1, y: values[0]))
            dataEntries.append(BarChartDataEntry(x: 2, y: 0))
        } else {
            for i in 0..<values.count {
                let dataEntry = BarChartDataEntry(x: Double(labels[i])!, y: values[i])
                dataEntries.append(dataEntry)
            }
        }
        
        let dataSet = BarChartDataSet(values: dataEntries, label: "blibble")
        dataSet.drawValuesEnabled = false
        dataSet.stackLabels = labels
        
        
        let chartData = BarChartData(dataSet: dataSet)
        self.data = chartData
        
        //changes to appearance
        dataSet.colors = [GlobalConstants.ColorPalette.SecondaryColorLight]
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        let myFont = UIFont(name: "ArialMT", size: 10.0 * getFontScalingForScreenSize())!
        chartData.setValueFont(myFont)

        //self.xAxis.setLabelsToSkip(4)
        self.xAxis.labelFont = myFont
        self.leftAxis.enabled = true
        self.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        
        
        let limit = ChartLimitLine(limit: Double(limitLine))
        limit.lineColor = GlobalConstants.ColorPalette.PrimaryColorDark
        limit.lineDashLengths = [5.0]
        self.xAxis.removeAllLimitLines()
        self.xAxis.addLimitLine(limit)
        setNeedsDisplay()
    }
    
    func setAnnuityIncomeBarChart(labels: [String], values: [Double], maxValue: Double, limitLine: Double) {
        
        self.leftAxis.axisMaximum = roundUpForAxisMax(maxValue)

        
        var dataEntries: [BarChartDataEntry] = []
        
        if values.count == 1 {
            dataEntries.append(BarChartDataEntry(x: 0, y: 0))
            dataEntries.append(BarChartDataEntry(x: 1, y: values[0]))
            dataEntries.append(BarChartDataEntry(x: 2, y: 0))
        } else {
            for i in 0..<values.count {
                let dataEntry = BarChartDataEntry(x: Double(labels[i])!, y: values[i])
                dataEntries.append(dataEntry)
            }
        }
        
        let dataSet = BarChartDataSet(values: dataEntries, label: "income per year")
        dataSet.drawValuesEnabled = false
        dataSet.stackLabels = labels
        
        let chartData = BarChartData(dataSets: [dataSet])
        self.data = chartData
        
        
        let formatter = createNumberFormatter(maxValue: roundUpForAxisMax(maxValue), prefix: "£")
        
        //changes to appearance
        dataSet.colors = [GlobalConstants.ColorPalette.SecondaryColorLight]
        
        let myFont = UIFont(name: "ArialMT", size: 10.0 * getFontScalingForScreenSize())!
        
        //self.xAxis.setLabelsToSkip(4)
        self.xAxis.labelFont = myFont
        
        self.leftAxis.enabled = true
        self.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        
        
        let limit = ChartLimitLine(limit: Double(limitLine))
        limit.lineColor = UIColor.black
        limit.lineDashLengths = [5.0]
        limit.lineWidth = 1.0
        self.xAxis.removeAllLimitLines()
        self.xAxis.addLimitLine(limit)
        
        self.legend.enabled = true
        self.legend.horizontalAlignment = .center
        self.legend.setCustom(colors: [GlobalConstants.ColorPalette.SecondaryColorLight, UIColor.black], labels: ["income per year", "life expectancy"])
        //self.legend.setExtra(colors: [UIColor.blackColor()], labels: ["life expectancy"])
        setNeedsDisplay()
    }

    
    func roundUpForAxisMax(_ highestValue: Double) -> Double {
        switch highestValue {
        case 0..<10000: return 10000
        case 0..<20000: return 20000
        case 0..<50000: return 50000
        case 0..<100000: return 100000
        case 0..<200000: return 200000
        case 0..<500000: return 500000
        case 0..<1000000: return 1000000
        case 0..<2000000: return 2000000
        case 0..<5000000: return 5000000
        default: return highestValue
        }
    }

}
