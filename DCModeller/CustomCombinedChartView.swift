//
//  CustomCombinedChartView.swift
//  DCModeller
//
//  Created by Daniel Jinks on 29/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import Charts

class CustomCombinedChartView: CombinedChartView {
    
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
        
        self.dragEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        
        self.drawValueAboveBarEnabled = true
        self.drawGridBackgroundEnabled = false
        self.drawBordersEnabled = false
        self.chartDescription?.text = ""
        self.legend.enabled = true
        self.legend.horizontalAlignment = .center
        self.legend.maxSizePercent = 100
        self.legend.setExtra(colors: [UIColor.black], labels: ["life expectancy"])
        self.drawBarShadowEnabled = false
        
        self.xAxis.enabled = true
        self.xAxis.drawLabelsEnabled = true
        self.xAxis.labelPosition = .bottom
        self.xAxis.drawLimitLinesBehindDataEnabled = false
        self.xAxis.drawGridLinesEnabled = false
        
        self.leftAxis.drawLabelsEnabled = true
        self.leftAxis.drawGridLinesEnabled = false
        self.leftAxis.drawTopYLabelEntryEnabled = true
        self.leftAxis.enabled = true
        self.leftAxis.axisMinimum = 0.0
        
        self.rightAxis.drawLabelsEnabled = true
        self.rightAxis.enabled = true
        self.rightAxis.drawGridLinesEnabled = false
        self.rightAxis.drawAxisLineEnabled = true
        self.rightAxis.axisMinimum = 0.0
        
        let myFont = UIFont(name: "ArialMT", size: 10.0 * getFontScalingForScreenSize())!
        //self.xAxis.setLabelsToSkip(4)
        self.xAxis.labelFont = myFont
        self.leftAxis.labelFont = myFont
        self.leftAxis.labelTextColor = GlobalConstants.ColorPalette.SecondaryColorLight
        self.rightAxis.labelFont = myFont
        self.rightAxis.labelTextColor = GlobalConstants.ColorPalette.PrimaryColorDark
    }
    
    
    func setCombinedChart(xValues: [Double], barValues: [Double], lineValues: [Double], barValueUnit: String, lineValueUnit: String, maxBarValue: Double, maxLineValue: Double, verticalLimit: Double) -> Void {
        
        var yVals1 = [BarChartDataEntry]()
        var yVals2 = [ChartDataEntry]()
        
        for i in 0..<xValues.count {
            yVals1.append(BarChartDataEntry(x: xValues[i], y: barValues[i]))
            yVals2.append(ChartDataEntry(x: xValues[i], y: lineValues[i]))
        }

        let barDataSet = BarChartDataSet(values: yVals1, label: "income per year")
        barDataSet.valueFormatter = DefaultValueFormatter(formatter: createNumberFormatter(maxValue: maxBarValue, prefix: "£"))
        barDataSet.colors = [GlobalConstants.ColorPalette.SecondaryColorLight]
        barDataSet.axisDependency = .left
        barDataSet.drawValuesEnabled = false
        
        var formatter = createNumberFormatter(maxValue: roundUpForAxisMax(maxBarValue), prefix: "£")
        self.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        
        let lineDataSet = LineChartDataSet(values: yVals2, label: "fund value")
        lineDataSet.colors = [GlobalConstants.ColorPalette.PrimaryColorDark]
        lineDataSet.setCircleColor(GlobalConstants.ColorPalette.PrimaryColorDark)
        lineDataSet.circleRadius = 1.5
        lineDataSet.axisDependency = .right
        lineDataSet.drawValuesEnabled = false
        
        formatter = createNumberFormatter(maxValue: roundUpForAxisMax(maxLineValue), prefix: "£")
        self.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)

        let chartData = CombinedChartData()
        chartData.barData = BarChartData(dataSets: [barDataSet])
        chartData.lineData = LineChartData(dataSets: [lineDataSet])
        
        self.leftAxis.axisMaximum = roundUpForAxisMax(maxBarValue)
        self.rightAxis.axisMaximum = roundUpForAxisMax(maxLineValue)

        self.xAxis.removeAllLimitLines()
        let limit = ChartLimitLine(limit: verticalLimit)
        limit.lineColor = UIColor.black
        limit.lineWidth = 1.0
        limit.lineDashLengths = [5.0]
        self.xAxis.addLimitLine(limit)
        
        self.data = chartData
        
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
