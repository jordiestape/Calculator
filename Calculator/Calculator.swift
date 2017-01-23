//
//  File.swift
//  Calculator
//
//  Created by Jordi Estapé Canal on 23/01/17.
//  Copyright © 2017 Jordi Estapé Canal. All rights reserved.
//

import Foundation

func randomize () -> Double {
    
    let aux = arc4random()
    let aux_decimal = arc4random()
    return Double(aux) + Double(arc4random())/1000.0
    
}

class Calculator {
    
    // Variables of the class
    
    private var accumulator = 0.0
    private var description = ""
    
    private enum Operation {
        
        case Constant(Double)
        case Random(() -> Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
        
    }
    
    private var operations: Dictionary<String, Operation> = [
        
        //Constant type operations
        
        "π" : Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        
        //Random type operations
        
        "Rnd": Operation.Random(randomize),
        
        //Unary type operations
        
        "√" : Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),

        //Binary type operations
        
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        
        // Equals
        
        "=" : Operation.Equals
    
    ]
    
    struct infoBinaryOperation {
        
        var binaryMethod: (Double, Double) -> Double
        var firstOperand: Double
        var opSymbol: String
        
    }
    
    private var auxBinaryOperation: infoBinaryOperation?
    
    
    // Functions
    
    
    func setOperand(operand: Double) { accumulator = operand; }
    
    func performOperation (symbol:String) {
        
        if let operation = operations[symbol] {
            
            switch operation {
                
            case .Constant(let associatedConstantValue):
                
                accumulator = associatedConstantValue
                description = symbol
                
            case .Random(let randomMethod):
                
                accumulator = randomMethod()
                description = symbol
                
            case .UnaryOperation(let unaryMethod):
                
                description = symbol + "(" + String(accumulator) + ")"
                accumulator = unaryMethod(accumulator)
                
            case .BinaryOperation(let binaryMethod):
                
                if (auxBinaryOperation != nil) {
                    
                    description = String(auxBinaryOperation!.firstOperand) + " " + auxBinaryOperation!.opSymbol + " " + String(accumulator)
                    accumulator = auxBinaryOperation!.binaryMethod(auxBinaryOperation!.firstOperand, accumulator)
                    auxBinaryOperation = nil;
                    
                } else { description = String(accumulator) + " " + symbol }
                
                auxBinaryOperation = infoBinaryOperation(binaryMethod: binaryMethod, firstOperand: accumulator, opSymbol: symbol)
                
                
            case .Equals:
                
                if auxBinaryOperation != nil {
                    
                    description = String(auxBinaryOperation!.firstOperand) + " " + auxBinaryOperation!.opSymbol + " " + String(accumulator)
                    accumulator = auxBinaryOperation!.binaryMethod(auxBinaryOperation!.firstOperand, accumulator)
                    auxBinaryOperation = nil;
                    
                }
                
                
            }
            
        }
        
    }
    
    func resetCalculation() {accumulator = 0; description = ""; auxBinaryOperation = nil}
    
    var result : Double {
        
        get { return accumulator }
        
    }
    
    var descriptive : String {
        
        get { return description }
        
    }

    
    
    
    
}
