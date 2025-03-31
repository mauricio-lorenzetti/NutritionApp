//
//  StreaksView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 27/03/25.
//

import SwiftUI

// MARK: - Main StreaksView
struct StreaksView: View {
    @Binding var selectedTab: TabItem
    @State private var currentStreak = 5
    
    let milestones = [
        (days: 7, achieved: true, color: Color(hex: "A8A8A8")),
        (days: 10, achieved: false, color: Color(hex: "E5A667")),
        (days: 20, achieved: false, color: Color(hex: "69B8E1")),
        (days: 30, achieved: false, color: Color(hex: "9077E1"))
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                StreaksHeaderView(selectedTab: $selectedTab, streak: currentStreak)
                
                // Flame icon with streak number
                StreakCounterView(streak: currentStreak)
                
                // Streak text
                StreakTextView(streak: currentStreak)
                
                // Calendar
                StreakCalendarView(currentStreak: currentStreak)
                
                // Current achievement badge
                CurrentMilestoneBadgeView(days: 10, color: Color(hex: "E5A667"))
                
                // Milestones section
                MilestonesListView(milestones: milestones)
            }
            .padding(.top, 20)
        }
        .background(Color.background)
    }
}

// MARK: - Header View Component
struct StreaksHeaderView: View {
    @Binding var selectedTab: TabItem
    let streak: Int
    @State private var showShareSheet = false
    
    var body: some View {
        HStack {
            Button(action: {
                selectedTab = .home
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Streaks")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                // Show share sheet
                showShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: ["\(streak) day streak"])
            }
        }
        .padding(.horizontal)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Streak Counter Component
struct StreakCounterView: View {
    let streak: Int
    
    var body: some View {
        ZStack {
            Image("flex_flame")
                .font(.system(size: 120))
                .foregroundColor(Color.primary)
            
            Text("\(streak)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 40)
        }
        .padding(.top, 20)
    }
}

// MARK: - Streak Text Component
struct StreakTextView: View {
    let streak: Int
    
    var body: some View {
        VStack(spacing: 5) {
            Text("You're on a")
                .font(.title3)
                .foregroundColor(.black)
            
            Text("\(streak) days Streak!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Keep it up!")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Current Milestone Badge Component
struct CurrentMilestoneBadgeView: View {
    let days: Int
    let color: Color
    
    var body: some View {
        HStack {
            Spacer()
            MilestoneBadge(days: days, achieved: false, color: color)
            Spacer()
        }
    }
}

// MARK: - Milestones List Component
struct MilestonesListView: View {
    let milestones: [(days: Int, achieved: Bool, color: Color)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Milestones")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(milestones, id: \.days) { milestone in
                    MilestoneRow(
                        days: milestone.days,
                        achieved: milestone.achieved,
                        color: milestone.color
                    )
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 80)
    }
}

// MARK: - Milestone Badge Component
struct MilestoneBadge: View {
    let days: Int
    let achieved: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .clipShape(Circle())
            
            Text("\(days)-day streak achiever")
                .font(.system(size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(color.opacity(0.2))
        .cornerRadius(20)
    }
}

// MARK: - Milestone Row Component
struct MilestoneRow: View {
    let days: Int
    let achieved: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .clipShape(Circle())
            
            Text("\(days)-day streak achiever")
                .font(.system(size: 15))
                .foregroundColor(.black)
            
            Spacer()
            
            if achieved {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.accent)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    StreaksView(selectedTab: .constant(.streaks))
}
