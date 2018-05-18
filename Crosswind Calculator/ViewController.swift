//
//  ViewController.swift
//  Crosswind Calculator
//
//  Created by Corey Davis on 5/17/18.
//  Copyright © 2018 Conxsys LLC. All rights reserved.
//

import UIKit

/*
 🤔 Thoughts on future enhacements:
    - Use a data model rather that calculating values directly from the text fields
    - Allow selection of actual runways from airport data
    - Use live weather (METAR) data
*/

class ViewController: UIViewController {

    // MARK: - Outlets & Actions
    @IBOutlet weak var runwayNumberTextField: UITextField!
    @IBOutlet weak var windSpeedTextField: UITextField!
    @IBOutlet weak var windDirectionTextField: UITextField!

    @IBOutlet weak var crosswindLabel: UILabel!
    @IBOutlet weak var crosswind: UILabel!
    @IBOutlet weak var parallelLabel: UILabel!
    @IBOutlet weak var parallel: UILabel!
    
    @IBAction func calculate(_ sender: Any) {
        view.endEditing(false)  // Dismiss the keyboard
        resetOutputUI()
        
        guard isRunwayValid && isWindDirectionValid else { return }
        guard let windSpeedText = windSpeedTextField.text, let windSpeed = Double(windSpeedText) else { return }
        guard let windDirectionText = windDirectionTextField.text, let windDirection = Double(windDirectionText) else { return }
        guard let heading = heading else { return }
        
        let crosswindValue = WindCalculations.crosswind(windSpeed: windSpeed, windDirection: windDirection, heading: Double(heading))
        crosswindLabel.text = Strings.General.crosswind.rawValue
        crosswind.text = String(format: "%.2f", crosswindValue)
        
        let parallelwindValue = WindCalculations.parallelWind(windSpeed: windSpeed, windDirection: windDirection, heading: Double(heading))
        parallelLabel.text = parallelwindValue.isTailwind ? Strings.General.tailwind.rawValue : Strings.General.headwind.rawValue
        parallel.text = String(format: "%.2f", abs(parallelwindValue.speed))
    }
    
    // MARK: - Properties
    var isRunwayValid: Bool {
        guard let text = runwayNumberTextField.text, let runway = Int(text) else { return false }
        return runway >= 1 && runway <= 36 ? true : false
    }
    
    var isWindDirectionValid: Bool {
        guard let text = windDirectionTextField.text, let direction = Int(text) else { return false }
        return direction >= 0 && direction <= 360 ? true : false
    }
    
    var heading: Int? {
        guard let text = runwayNumberTextField.text, let runway = Int(text) else { return nil }
        return runway * 10
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        
        runwayNumberTextField.restorationIdentifier = Strings.RestorationIdentifier.runway.rawValue
        windSpeedTextField.restorationIdentifier = Strings.RestorationIdentifier.speed.rawValue
        windDirectionTextField.restorationIdentifier = Strings.RestorationIdentifier.direction.rawValue
        
        runwayNumberTextField.delegate = self
        windSpeedTextField.delegate = self
        windDirectionTextField.delegate = self
        
        resetUI()
    }

    // MARK: - Helper Functions
    func resetUI() {
        resetInputUI()
        resetOutputUI()
    }
    
    func resetInputUI() {
        runwayNumberTextField.text = nil
        windSpeedTextField.text = nil
        windDirectionTextField.text = nil
    }
    func resetOutputUI() {
        crosswindLabel.text = nil
        crosswind.text = nil
        parallelLabel.text = nil
        parallel.text = nil
    }
    
    func setErrorState(_ isError: Bool, forField field: UITextField, errorText text: String? = nil) {
        if isError { field.text = nil }
        field.backgroundColor = isError ? Color.lightRed.value : nil
        field.placeholder = text
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setErrorState(false, forField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.restorationIdentifier {
        case Strings.RestorationIdentifier.runway.rawValue:
            if !isRunwayValid {
                setErrorState(true, forField: runwayNumberTextField, errorText: Strings.Error.runwayError.rawValue)
            }
        case Strings.RestorationIdentifier.direction.rawValue:
            if !isWindDirectionValid {
                setErrorState(true, forField: windDirectionTextField, errorText: Strings.Error.windDirectionError.rawValue)
            }
        default: break
        }
    }
}
