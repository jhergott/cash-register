/*
 HELLO CHANGE
 
 At Rocketmiles, our team loves travelling. However, many places we travel don’t accept our credit cards, and we have to remember to bring dollar bills with us. We’ve had to correct a few vendors about giving us the correct change from their cash registers, sometimes we get too much and sometimes we get too little. Create a cash register that should be able to accept only $20, $10, $5, $2 and $1 bills. Given the charge and amount of money received return the change in each denomination that should be given from the cash register. Sometimes when the vendors couldn’t make exact change they would tell us they couldn’t make exact change.
 */

import Foundation

// For the sake of this exercise, all cash will be assumed to be integer values
// because we will not be able to make change for any non-integer value.
typealias CashValue = Int

enum Bill: CashValue {
    case one    = 1
    case two    = 2
    case five   = 5
    case ten    = 10
    case twenty = 20
}

struct CashRegister {
    let ones: Int
    let twos: Int
    let fives: Int
    let tens: Int
    let twenties: Int
    
    // billsInRegister returns the bills in the CashRegister sorted lowest to highest.
    var billsInRegister: [Bill] {
        var bills = [Bill]()
        
        for _ in 0 ..< ones {
            bills.append(Bill.one)
        }
        for _ in 0 ..< twos {
            bills.append(Bill.two)
        }
        for _ in 0 ..< fives {
            bills.append(Bill.five)
        }
        for _ in 0 ..< tens {
            bills.append(Bill.ten)
        }
        for _ in 0 ..< twenties {
            bills.append(Bill.twenty)
        }
        
        return bills
    }
    
    func getChange(changeValue: CashValue) -> [Bill]? {
        // makeChangeTable will hold the change solution for each CashValue up to the changeValue we're looking for.
        // A nil solution (or empty) means we cannot make change for that CashValue.
        var makeChangeTable: [CashValue : [Bill]?] = [0 : []]
        
        var bills = billsInRegister
        
        while !bills.isEmpty {
            guard let currentBill = bills.popLast() else {
                continue
            }
            
            for currentChangeValue in (0...changeValue).reversed() {
                // If we already know we can make change for the currentChangeValue, continue.
                if let _ = makeChangeTable[currentChangeValue] {
                    continue
                }
                
                let subProblemChangeValue = currentChangeValue - currentBill.rawValue
                if let solution = makeChangeTable[subProblemChangeValue],
                    let subProblemSolution = solution,
                    subProblemChangeValue >= 0 {
                    let currentSolution: [Bill] = [currentBill] + subProblemSolution
                    makeChangeTable[currentChangeValue] = currentSolution
                    
                    // If we have a change solution for the changeValue we're looking for, return it.
                    if currentChangeValue == changeValue {
                        return currentSolution
                    }
                }
            }
        }
        
        return nil
    }
}


// MARK: - Tests -
let register1 = CashRegister(ones: 0, twos: 4, fives: 1, tens: 0, twenties: 0)
let changeBills1 = register1.getChange(changeValue: 11)
assert(changeBills1! == [Bill.two, Bill.two, Bill.two, Bill.five])

let register2 = CashRegister(ones: 2, twos: 2, fives: 2, tens: 0, twenties: 0)
let changeBills2 = register2.getChange(changeValue: 5)
assert(changeBills2! == [Bill.five])

let register3 = CashRegister(ones: 2, twos: 2, fives: 2, tens: 2, twenties: 2)
let changeBills3 = register3.getChange(changeValue: 28)
assert(changeBills3! == [Bill.one, Bill.two, Bill.five, Bill.twenty])

let register4 = CashRegister(ones: 0, twos: 0, fives: 10, tens: 10, twenties: 10)
let changeBills4 = register4.getChange(changeValue: 38)
assert(changeBills4 == nil)

let register5 = CashRegister(ones: 5, twos: 1, fives: 0, tens: 0, twenties: 0)
let changeBills5 = register5.getChange(changeValue: 5)
assert(changeBills5! == [Bill.one, Bill.one, Bill.one, Bill.two])

let register6 = CashRegister(ones: 0, twos: 5, fives: 2, tens: 0, twenties: 2)
let changeBills6 = register6.getChange(changeValue: 28)
assert(changeBills6! == [Bill.two, Bill.two, Bill.two, Bill.two, Bill.twenty])

let register7 = CashRegister(ones: 0, twos: 5, fives: 2, tens: 0, twenties: 2)
let changeBills7 = register7.getChange(changeValue: 31)
assert(changeBills7! == [Bill.two, Bill.two, Bill.two, Bill.five, Bill.twenty])
