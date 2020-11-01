//
//  Date+Extensions.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

extension Date {
    
    func formatCurrentDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let formattedDateString = dateFormatter.string(from: self)
        return formattedDateString
    }
}
