//
//  ViewController.swift
//  Calculator
//
//  Created by Jordi Estapé Canal on 23/01/17.
//  Copyright © 2017 Jordi Estapé Canal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var displayNumber: UILabel!
    @IBOutlet weak var displayDescription: UILabel!
    
    // Variables of class
    
    private var userIsTyping = false
    private var comaIntroduced = false
    
    private var opLast = ""
    private var canOp = true
    private var lastNum = 0.0
    
    private var calculator = Calculator()
    
    private var displayValue: Double {

        get { return Double(displayNumber.text!)! }
        set { displayNumber.text = String(newValue) }
        
    }
    
    // Functions 
    
    @IBAction private func pressDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if (userIsTyping) {
            
            if (digit == "." && !comaIntroduced) || digit != "." { displayNumber.text = displayNumber.text! + digit }
            if digit == "." {comaIntroduced = true}
            
        } else if (digit != "0" && digit != ".") {
            
            displayNumber.text = digit
            userIsTyping = true
            
        } else if (digit != "0" && digit == ".") {
            
            displayNumber.text = "0" + digit
            userIsTyping = true
            comaIntroduced = true
            
        }
        
        canOp = true


    }

    @IBAction private func resetDisplay(_ sender: UIButton) {
        
        displayNumber.text = "0"
        displayDescription.text = ""
        userIsTyping = false; comaIntroduced = false; canOp = true; opLast = ""
        calculator.resetCalculation()

        
    }
    
    @IBAction private func operate(_ sender: UIButton) {

            
        if let mathematicalSymbol = sender.currentTitle {
           
            if (!canOp && mathematicalSymbol != "=") {
                
                calculator.resetCalculation();
                calculator.setOperand(operand: displayValue); lastNum = displayValue
                calculator.performOperation(symbol: mathematicalSymbol)
                userIsTyping = false; comaIntroduced = false; opLast = mathematicalSymbol
                
            } else if (!canOp && mathematicalSymbol == "=") {
          
                calculator.resetCalculation();
                
                calculator.setOperand(operand: displayValue)
                calculator.performOperation(symbol: opLast)
                
                calculator.setOperand(operand: lastNum)
                calculator.performOperation(symbol: "=")
            
                userIsTyping = false; comaIntroduced = false
                    
            } else if (canOp) {
                    
                calculator.setOperand(operand: displayValue); lastNum = displayValue
                calculator.performOperation(symbol: mathematicalSymbol)
                userIsTyping = false; comaIntroduced = false
                
                if(mathematicalSymbol != "=") {opLast = mathematicalSymbol}
            
            }
        
        displayValue = calculator.result
        displayDescription.text = calculator.descriptive

        canOp = false
    
        }
    }
    
}
