//
//  HelperTimer.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/3/20.
//

import Foundation


import Foundation
//Keep track of time when user makes a call

class HelperTimer {
    private static var startTime : Date = Date();
    private static var connectTime : Date = Date();
    private static var callClock : Timer!
    
    public static func createStartTimer(completion:  (() -> ())? ) {
        if callClock != nil {
            print("CallTimer: already have a startTimer")
            return
        }
        callClock = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (callClock) in
            print("Start timer at \(connectTime)")
            if let completion = completion {
                completion()
            }
        }
    }
    
    public static func destroyTimer() {
        if callClock != nil{
            callClock!.invalidate()
            print("CallTimer: destroy startTimer")
            callClock = nil
        }
    }
    
    public static func setStartTime() {
        startTime = Date();
    }
    
    public static func setConnectTime() {
        connectTime = Date();
    }
    
    //use this to cancel the call passing time limit (unit: minute)
    public static func didWaitTimePass(second limit: Double) -> Bool {
        let now = Date()
        let passedTime = now.timeIntervalSince(startTime)
        print("PassedTime \(passedTime)")
        
        return (passedTime > limit)
    }
    
    //use this to update clock while user are in the call
    public static func updateTimer() -> String{
        //currentTime - connectTime
        let now = Date()
        let passedTime = now.timeIntervalSince(startTime) //milliseconds
        print("passedTime \(passedTime)")
        //convert to second, minute, and hour
        var seconds : Int = Int(passedTime)
        let hour : Int = seconds / 3600
        seconds = seconds - hour * 3600
        let minutes : Int = seconds / 60
        seconds = seconds - minutes * 60
        
        let updatedTime : String = "\(hour):\(minutes):\(seconds)"

        print("call duration: \(updatedTime)")

        return updatedTime
    }
    
    public static func secondsTo(_ format: String = "hh:mm:ss", amount: Int) -> String {
        var seconds : Int = Int(amount)
        let hour : Int = seconds / 3600
        seconds = seconds - hour * 3600
        let minutes : Int = seconds / 60
        seconds = seconds - minutes * 60
        
        return "\(hour):\(minutes):\(seconds)"
    }
}

private extension String.StringInterpolation {
    mutating func appendInterpolation(_ value : Int) {
        var result : String
        if (value >= 0 && value < 10) {
            result = "0\(String(value))"
        } else {
            result = String(value)
        }
        appendLiteral(result)
    }
}

