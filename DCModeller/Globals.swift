//
//  GlobalConstants.swift
//  DCModeller
//
//  Created by Daniel Jinks on 21/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation

var annuitiesUpdated = false



struct GlobalConstants {
    
    struct DCPaymentMethods {
        static let NetPay = "net pay"
        static let ReliefAtSource = "relief at source"
        static let SalarySacrifice = "salary sacrifice"
        static let All = [DCPaymentMethods.NetPay, DCPaymentMethods.ReliefAtSource, DCPaymentMethods.SalarySacrifice]
    }
    
    struct TaxLimits {
        static let AnnualAllowance = 40000.0
        static let LifetimeAllowance = 1000000.0
        static let TaxFreeCashProportion = 0.25
    }
    
    static let ContributionRateIncrements = [
        0.000,0.005,0.01,0.015,0.02,0.025,0.03,0.035,0.04,0.045,0.05,
        0.055,0.06,0.065,0.07,0.075,0.08,0.085,0.09,0.095,0.1,
        0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.2,
        0.22,0.24,0.26,0.28,0.3,0.32,0.34,0.36,0.38,0.4,
        0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1
    ]
    
    struct ColorPalette {
        static let PrimaryColorDark = FAColors.FABlue100
        static let PrimaryColorLight = FAColors.FABlue50
        static let SecondaryColorDark = FAColors.UnofficialOrange100
        static let SecondaryColorLight = FAColors.UnofficialOrange80
        static let SecondaryColorExtraLight = FAColors.UnofficialOrange50
    }
    
    static let DrawdownIncomeIncrements: [Float] = [
    0,100,200,300,400,500,600,700,800,900,
    1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,
    2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,
    3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,
    4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,
    5000,5200,5400,5600,5800,6000,6200,6400,6600,6800,
    7000,7200,7400,7600,7800,8000,8200,8400,8600,8800,
    9000,9200,9400,9600,9800,10000,
    10500,11000,11500,12000,12500,13000,13500,14000,14500,15000,
    15500,16000,16500,17000,17500,18000,18500,19000,19500,20000,
    21000,22000,23000,24000,25000,26000,27000,28000,29000,30000,
    31000,32000,33000,34000,35000,36000,37000,38000,39000,40000,
    41000,42000,43000,44000,45000,46000,47000,48000,49000,50000,
    55000,60000,65000,70000,75000,80000,85000,90000,95000,100000
    ]
}

var currentUser: User? //= nil
var currentDCPension: DCPension? //= nil