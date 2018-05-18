//
//  Globals.swift
//  Crosswind Calculator
//
//  Created by Corey Davis on 5/18/18.
//  Copyright © 2018 Conxsys LLC. All rights reserved.
//

import UIKit

enum Color {
    case lightRed
    
    var value: UIColor {
        switch self {
        case .lightRed: return UIColor(red: 255.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        }
    }
}

enum Strings {
    enum Error: String {
        case runwayError = "Enter a number between 1 - 36"
        case windDirectionError = "Enter a number between 0 - 360"
    }
    
    enum RestorationIdentifier: String {
        case runway = "runway"
        case speed = "speed"
        case direction = "direction"
    }
    
    enum General: String {
        case tailwind = "Tailwind:"
        case headwind = "Headwind:"
        case crosswind = "Crosswind:"
    }
}
