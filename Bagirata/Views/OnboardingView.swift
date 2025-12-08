//
//  OnboardingView.swift
//  Bagirata
//
//  Created by Wahyu K on 8/12/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showLogin = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "doc.text.fill",
            title: "Add Your Bills",
            description: "Enter items from your receipt. Quick and easy!",
            color: .blue
        ),
        OnboardingPage(
            icon: "person.2.fill",
            title: "Add Your Friends",
            description: "Select who's splitting the bill. Everyone gets their fair share.",
            color: .green
        ),
        OnboardingPage(
            icon: "checkmark.circle.fill",
            title: "Assign Items",
            description: "Tap to assign who ordered what. Items can be split between multiple people!",
            color: .orange
        ),
        OnboardingPage(
            icon: "chart.pie.fill",
            title: "Get Your Split",
            description: "See exactly how much everyone owes. Share the breakdown instantly!",
            color: .purple
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedGradientBackground(currentPage: currentPage, pages: pages)
                .ignoresSafeArea()
            
            if showLogin {
                LoginView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                VStack(spacing: 0) {
                    // Skip button
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showLogin = true
                                markOnboardingComplete()
                            }
                        } label: {
                            Text("Skip")
                                .font(.body)
                                .foregroundStyle(.white)
                                .padding()
                        }
                    }
                    
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            AnimatedOnboardingPageView(
                                page: pages[index],
                                isVisible: currentPage == index
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    VStack(spacing: 16) {
                        if currentPage == pages.count - 1 {
                            Button {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    showLogin = true
                                    markOnboardingComplete()
                                }
                            } label: {
                                HStack {
                                    Text("Get Started")
                                        .font(.headline)
                                    Image(systemName: "arrow.right")
                                        .font(.headline)
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, 40)
                            .buttonStyle(ScaleButtonStyle())
                        } else {
                            // Next button
                            Button {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    currentPage += 1
                                }
                            } label: {
                                HStack {
                                    Text("Next")
                                        .font(.headline)
                                    Image(systemName: "arrow.right")
                                        .font(.headline)
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, 40)
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding(.bottom, 40)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func markOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

struct AnimatedOnboardingPageView: View {
    let page: OnboardingPage
    let isVisible: Bool
    
    @State private var iconScale: CGFloat = 0.5
    @State private var iconRotation: Double = -180
    @State private var titleOffset: CGFloat = 50
    @State private var titleOpacity: Double = 0
    @State private var descriptionOffset: CGFloat = 50
    @State private var descriptionOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(page.color.opacity(0.3), lineWidth: 2)
                        .frame(width: 120 + CGFloat(index * 30), height: 120 + CGFloat(index * 30))
                        .scaleEffect(isVisible ? 1.2 : 0.8)
                        .opacity(isVisible ? 0 : 0.5)
                        .animation(
                            .easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                            value: isVisible
                        )
                }
                
                Image(systemName: page.icon)
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [page.color, page.color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(iconScale)
                    .rotationEffect(.degrees(iconRotation))
                    .shadow(color: page.color.opacity(0.5), radius: 20, x: 0, y: 10)
            }
            
            // Title with slide-in animation
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .offset(y: titleOffset)
                .opacity(titleOpacity)
            
            // Description with slide-in animation
            Text(page.description)
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .offset(y: descriptionOffset)
                .opacity(descriptionOpacity)
            
            Spacer()
        }
        .padding()
        .onChange(of: isVisible) { _, newValue in
            if newValue {
                animateIn()
            } else {
                animateOut()
            }
        }
        .onAppear {
            if isVisible {
                animateIn()
            }
        }
    }
    
    private func animateIn() {
        // Icon animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            iconScale = 1.0
            iconRotation = 0
        }
        
        // Title animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
            titleOffset = 0
            titleOpacity = 1
        }
        
        // Description animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
            descriptionOffset = 0
            descriptionOpacity = 1
        }
    }
    
    private func animateOut() {
        iconScale = 0.5
        iconRotation = 180
        titleOffset = -50
        titleOpacity = 0
        descriptionOffset = -50
        descriptionOpacity = 0
    }
}

// MARK: - Animated Gradient Background
struct AnimatedGradientBackground: View {
    let currentPage: Int
    let pages: [OnboardingPage]
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    pages[currentPage].color,
                    pages[currentPage].color.opacity(0.7),
                    .black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .animation(.easeInOut(duration: 0.8), value: currentPage)
            
            // Floating circles
            GeometryReader { geometry in
                ForEach(0..<5) { index in
                    Circle()
                        .fill(
                            pages[currentPage].color.opacity(0.1)
                        )
                        .frame(
                            width: CGFloat.random(in: 100...200),
                            height: CGFloat.random(in: 100...200)
                        )
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .blur(radius: 20)
                        .animation(
                            .easeInOut(duration: Double.random(in: 3...5))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                            value: currentPage
                        )
                }
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// Scale button animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
        .environment(AuthenticationManager())
}
