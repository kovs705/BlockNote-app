//
//  CircularView.swift
//  BlockNote app
//
//  Created by user on 06.09.2023.
//

import SwiftUI

struct CircularView: View {
    
    var startDate: Date
    var endDate: Date
    
    @State private var value: CGFloat = 0.25
    @State private var appear = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: appear ? value : 0)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .fill(.angularGradient(colors: [.purple, .pink, .pink], center: .center, startAngle: .degrees(0), endAngle: .degrees(360)))
            .rotationEffect(.degrees(270))
        
            .onAppear {
                value = calculateForCircle(returnTimeToEnd(start: startDate, end: endDate))
                
                withAnimation(.spring().delay(0.5)) {
                    appear = true
                }
            }
            .onDisappear {
                appear = false
            }
    }
    
    
    func calculateForCircle(_ timeToEnd: Double) -> Double {
        // let end = 1
        var value: Double = 0.1
        if timeToEnd <= 9 {
            print("Time to end is \(timeToEnd)")
            value = (Double(timeToEnd) / 10)
            print(value)
            return value
        } else if timeToEnd <= 99 {
            value = (Double(timeToEnd) / 100)
            print(value)
            return value
        } else if timeToEnd <= 999 {
            value = (Double(timeToEnd) / 1000)
            print(value)
            return value
        } else {
            print("damn, that's too much...")
            return value
        }
    }
    
    func returnTimeToEnd(start: Date, end: Date) -> Double {
        return Double(DateInterval(start: start, end: end).description)!
        
    }
}

struct CircularView_Previews: PreviewProvider {
    
    static var previews: some View {
        CircularView(startDate: Date(), endDate: Date())
    }
}
