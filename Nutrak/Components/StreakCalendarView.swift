//
//  StreakCalendarView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 30/03/25.
//

import SwiftUI

struct StreakCalendarView: View {
    let currentStreak: Int
    
    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    
    let columnWidth: CGFloat = 40
    
    private var today: Date {
        return Date()
    }
    
    private var currentWeekDates: [Date] {
        return getWeekDates(for: today)
    }
    
    private var nextWeekDates: [Date] {
        let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: today)!
        return getWeekDates(for: nextWeekDate)
    }
    
    private func getWeekDates(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        
        let mondayOffset = dayOfWeek == 1 ? -6 : 2 - dayOfWeek
        
        guard let monday = calendar.date(byAdding: .day, value: mondayOffset, to: date) else {
            return []
        }
        
        return (0...6).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }
    
    private func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: today)
    }
    
    private func isCompletedDay(_ date: Date) -> Bool {
        let calendar = Calendar.current
        
        if calendar.compare(date, to: today, toGranularity: .day) == .orderedAscending {
            let daysAgo = calendar.dateComponents([.day], from: date, to: today).day ?? 0
            
            return daysAgo < currentStreak
        }
        
        return false
    }
    
    private func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 25) {
            HStack(spacing: 0) {
                ForEach(weekDays.indices, id: \.self) { index in
                    Text(weekDays[index])
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(index < currentStreak % 7 ? Color.accent : .black)
                        .frame(width: columnWidth, height: 20)
                }
            }
            
            HStack(spacing: 0) {
                ForEach(currentWeekDates, id: \.timeIntervalSince1970) { date in
                    if isCompletedDay(date) {
                        // Completed day with flame icon
                        ZStack {
                            Circle()
                                .fill(Color.accent)
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "flame.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        .frame(width: columnWidth, height: columnWidth)
                    } else if isToday(date) {
                        ZStack {
                            Circle()
                                .stroke(Color.disabled, lineWidth: 1)
                                .frame(width: 36, height: 36)
                            
                            Text(dayNumber(from: date))
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(width: columnWidth, height: columnWidth)
                    } else {
                        Text(dayNumber(from: date))
                            .font(.system(size: 16))
                            .foregroundColor(
                                Calendar.current.compare(date, to: today, toGranularity: .day) == .orderedAscending 
                                ? .gray : .black
                            )
                            .frame(width: columnWidth, height: columnWidth)
                    }
                }
            }
            
            HStack(spacing: 0) {
                ForEach(nextWeekDates, id: \.timeIntervalSince1970) { date in
                    Text(dayNumber(from: date))
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(width: columnWidth, height: columnWidth)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
