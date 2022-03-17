//
//  DateValueFormatter.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 3/12/22.
//

import Foundation
import Charts

public class DateValueFormatter: IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    var dates: [String] = []
    var dates2: [String] = []
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        for date in dates {
            let string = date
            let substring = string.dropLast(5)
            dates2.append(String(substring))
        }
        //print(dates)
        return dates2[Int(value)]
    }
}
