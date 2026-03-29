import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Content View

struct ContentView: View {

    let donuts = Donut.all
    private var loopingDonuts: [Donut] {
        guard let first = donuts.first, let last = donuts.last else { return donuts }
        return [last] + donuts + [first]
    }

    @State private var selectedIndex   = 0
    @State private var carouselIndex   = 1
    @State private var quantities      = Array(repeating: 1, count: Donut.all.count)
    @State private var cartStore       = CartStore()
    @State private var showCartBanner  = false
    @State private var currentPage: AppPage = .home

    // Animation states
    @State private var donutRotation   = 0.0
    @State private var donutScale      = 1.0
    @State private var swipeRotation   = 0.0
    @State private var swipeProgress   = 0.0
    @State private var cardOffset      = 0.0
    @State private var cardOpacity     = 1.0
    @State private var leavesRotation  = 0.0
    @State private var leavesScale     = 1.0
    @State private var priceScale      = 1.0
    @State private var priceOffset     = 0.0
    @State private var priceOpacity    = 1.0
    @State private var glowOpacity     = 0.25
    @State private var isRotatingDonut = false

    // MARK: Body

    var body: some View {
        ZStack {
            if currentPage == .home {
                homeView
            } else if currentPage == .cart {
                CartPageView(cartStore: cartStore, currentPage: $currentPage, donuts: donuts, themeColor: currentColor)
            } else if currentPage == .profile {
                ProfilePageView(currentPage: $currentPage, themeColor: currentColor)
            }
        }
    }

    private var homeView: some View {
        GeometryReader { geo in
            ZStack {
                backgroundLayer
                leavesLayer(geo: geo)

                VStack(spacing: 0) {
                    cartButton
                    Spacer(minLength: 6)
                    donutCarousel
                    carouselDots
                    Spacer(minLength: 12)
                    productCard
                }

                cartBannerOverlay
            }
        }
        .onAppear {
            syncSelectionState()
            startGlowPulse()
        }
    }

    // MARK: - Subviews

    private var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    currentColor.opacity(0.75),
                    currentColor.opacity(0.45)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [.white.opacity(glowOpacity), .clear],
                center: .init(x: 0.5, y: 0.38),
                startRadius: 30,
                endRadius: 340
            )
            RadialGradient(
                colors: [.clear, .black.opacity(0.08)],
                center: .bottom,
                startRadius: 100,
                endRadius: 500
            )
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 1.1), value: selectedIndex)
    }

    private func leavesLayer(geo: GeometryProxy) -> some View {
        Image("leaves")
            .resizable()
            .scaledToFit()
            .frame(width: geo.size.width * 1.30)
            .opacity(0.88)
            .scaleEffect(leavesScale)
            .rotationEffect(.degrees(leavesRotation))
            .position(x: geo.size.width / 2, y: geo.size.height * 0.54)
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
            .animation(Springs.gentle, value: leavesRotation)
        .animation(Springs.gentle, value: leavesScale)
    }

    private var cartButton: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentPage = .profile
                }
            }) {
                Image(systemName: "person.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 38, height: 38)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(.white.opacity(0.16))
                            .overlay(Circle().stroke(.white.opacity(0.40), lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)

            Spacer()

            ZStack(alignment: .topTrailing) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage = .cart
                    }
                }) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 38, height: 38)
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(.white.opacity(0.16))
                                .overlay(Circle().stroke(.white.opacity(0.40), lineWidth: 1))
                        )
                }
                .buttonStyle(.plain)
                if cartStore.totalCount > 0 {
                    ZStack {
                        Circle()
                            .fill(currentColor.opacity(0.90))
                        Text("\(cartStore.totalCount)")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white)
                    }
                    .frame(width: 20, height: 20)
                    .offset(x: 6, y: -6)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .overlay {
            HStack(spacing: 8) {
                Image("donate_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .shadow(color: .black.opacity(0.24), radius: 5, x: 0, y: 2)

                Text("HOUSE")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .tracking(2.6)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.78)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        Text("HOUSE")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .tracking(2.6)
                            .foregroundColor(.white.opacity(0.35))
                            .offset(y: -0.8)
                    }
                    .shadow(color: .black.opacity(0.28), radius: 3, x: 0, y: 1.5)
                    .shadow(color: currentColor.opacity(0.26), radius: 8, x: 0, y: 2)
            }
            .frame(width: 220, height: 50)
            .allowsHitTesting(false)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .padding(.top, 6)
    }

    private var donutCarousel: some View {
        TabView(selection: $carouselIndex) {
            ForEach(Array(loopingDonuts.enumerated()), id: \.offset) { offset, donut in
                DonutSlide(
                    donut: donut,
                    isSelected: selectedIndex == donut.id,
                    rotation: donutRotation,
                    swipeRotation: swipeRotation,
                    swipeProgress: swipeProgress,
                    swipeScale: donutScale
                )
                .tag(offset)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 320)
        .simultaneousGesture(
            DragGesture(minimumDistance: 1)
                .onChanged { value in
                    let progress = max(-1.0, min(1.0, value.translation.width / 220.0))
                    swipeProgress = progress
                    swipeRotation = -progress * 38
                    donutScale = 1.0 + abs(progress) * 0.02
                }
                .onEnded { value in
                    let progress = max(-1.0, min(1.0, value.translation.width / 220.0))
                    donutRotation += -progress * 35
                    donutRotation = donutRotation.truncatingRemainder(dividingBy: 360)

                    withAnimation(.easeOut(duration: Timings.swipeSettle)) {
                        swipeRotation = 0
                        donutScale = 1.0
                        swipeProgress = 0
                    }
                }
        )
        .onChange(of: carouselIndex, perform: handleCarouselIndexChange)
        .onChange(of: selectedIndex, perform: handleSelectionChange)
    }

    private var carouselDots: some View {
        HStack(spacing: 8) {
            ForEach(donuts.indices, id: \.self) { index in
                Capsule()
                    .fill(.white.opacity(selectedIndex == index ? 0.98 : 0.40))
                    .frame(width: selectedIndex == index ? 18 : 7, height: 7)
                    .shadow(color: .black.opacity(selectedIndex == index ? 0.22 : 0.10), radius: 2, x: 0, y: 1)
                    .animation(.spring(response: 0.30, dampingFraction: 0.80), value: selectedIndex)
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 10)
    }

    private var productCard: some View {
        VStack(spacing: 18) {
            productInfoRow
            Divider().background(.white.opacity(0.34))
            quantityAndCartRow
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 20)
        .background(
            ZStack {
                LiquidGlassPanel(tint: currentColor)
            }
        )
        .compositingGroup()
        .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 10)
        .shadow(color: .white.opacity(0.16), radius: 12, x: 0, y: -2)
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .offset(y: cardOffset)
        .opacity(cardOpacity)
        .animation(Springs.slow, value: cardOffset)
        .animation(Springs.slow, value: cardOpacity)
    }

    private var productInfoRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(currentDonut.displayName)
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.30), radius: 2, x: 0, y: 1)
                    .shadow(color: currentColor.opacity(0.45), radius: 10, x: 0, y: 2)
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.72), value: selectedIndex)
                    .id("name-\(selectedIndex)")
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.92).combined(with: .move(edge: .trailing)).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    ))
                HStack(spacing: 6) {
                    Text("\(discountPercent)% OFF")
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Save \(discountAmount.formatted(.currency(code: "INR")))")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.92))
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(
                    Capsule()
                        .fill(currentColor.opacity(0.32))
                        .overlay(
                            Capsule()
                                .strokeBorder(currentColor.opacity(0.56), lineWidth: 1)
                        )
                )
                .transition(.scale.combined(with: .opacity))
            }
            Spacer()
            Text(currentDonut.price.formatted(.currency(code: "INR")))
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: currentColor.opacity(0.36), radius: 8, x: 0, y: 0)
                .scaleEffect(priceScale)
                .offset(y: priceOffset)
                .opacity(priceOpacity)
                .animation(Springs.medium, value: priceScale)
                .animation(.easeInOut(duration: Timings.pricePop), value: priceOffset)
                .animation(.easeInOut(duration: Timings.pricePop), value: priceOpacity)
                .id("price-\(selectedIndex)")
                .transition(.scale.combined(with: .opacity))
        }
    }

    private var quantityAndCartRow: some View {
        HStack(spacing: 12) {
            QuantityStepper(quantity: currentQuantityBinding)
            addToCartButton
        }
    }

    private var addToCartButton: some View {
        Button(action: addToCart) {
            HStack(spacing: 9) {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 16, weight: .bold))
                Text("Add to Cart")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                currentColor.opacity(0.96),
                                currentColor.opacity(0.80)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.white.opacity(0.34), lineWidth: 1)
                    )
            )
            .shadow(color: currentColor.opacity(0.46), radius: 14, x: 0, y: 10)
        }
        .buttonStyle(BouncyButtonStyle())
    }

    @ViewBuilder
    private var cartBannerOverlay: some View {
        if showCartBanner {
            VStack {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Added! Cart total: \(cartStore.totalPrice.formatted(.currency(code: "INR")))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 5)
                .padding(.top, 60)
                Spacer()
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    // MARK: - Helpers

    private var safeSelectedIndex: Int {
        guard !donuts.isEmpty else { return 0 }
        return min(max(selectedIndex, 0), donuts.count - 1)
    }

    private var currentDonut: Donut {
        donuts[safeSelectedIndex]
    }

    private var currentQuantityBinding: Binding<Int> {
        Binding(
            get: {
                guard quantities.indices.contains(safeSelectedIndex) else { return 1 }
                return quantities[safeSelectedIndex]
            },
            set: { newValue in
                guard quantities.indices.contains(safeSelectedIndex) else { return }
                quantities[safeSelectedIndex] = max(1, newValue)
            }
        )
    }

    private var currentColor: Color { currentDonut.color }
    private var discountPercent: Int { 15 }
    private var discountAmount: Double {
        currentDonut.price * Double(discountPercent) / 100.0
    }

    private func syncSelectionState() {
        guard !donuts.isEmpty else { return }
        selectedIndex = safeSelectedIndex

        if quantities.count != donuts.count {
            quantities = Array(repeating: 1, count: donuts.count)
        }

        if carouselIndex < 0 || carouselIndex > donuts.count + 1 {
            carouselIndex = 1
        }
    }

    private func handleCarouselIndexChange(_ newValue: Int) {
        let count = donuts.count
        guard count > 1 else { return }

        if newValue == 0 {
            selectedIndex = count - 1
            triggerSlideHaptic()
            DispatchQueue.main.async {
                withAnimation(.none) {
                    carouselIndex = count
                }
            }
            return
        }

        if newValue == count + 1 {
            selectedIndex = 0
            triggerSlideHaptic()
            DispatchQueue.main.async {
                withAnimation(.none) {
                    carouselIndex = 1
                }
            }
            return
        }

        selectedIndex = newValue - 1
        triggerSlideHaptic()
    }

    private func handleSelectionChange(_ newIndex: Int) {
        withAnimation(Springs.swipe) {
            cardOffset = 10
            cardOpacity = 0.88
            priceScale = 1.06
            leavesRotation += 4
            leavesScale = 1.02
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Timings.selectionBounceBackDelay) {
            withAnimation(Springs.swipe) {
                cardOffset = 0
                cardOpacity = 1
                priceScale = 1.0
                leavesScale = 1.0
            }
        }
    }

    private func addToCart() {
        guard quantities.indices.contains(safeSelectedIndex) else { return }
        let qty = quantities[safeSelectedIndex]
        cartStore.add(donutID: safeSelectedIndex, quantity: qty)
        quantities[safeSelectedIndex] = 1
        triggerAddToCartHaptic()

        rotateDonut(by: 2)
        withAnimation(.easeInOut(duration: Timings.pricePop)) { priceScale = 1.07; priceOffset = -3 }
        withAnimation(Springs.medium) { showCartBanner = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + Timings.pricePop) {
            withAnimation(.easeOut(duration: Timings.pricePop)) { priceScale = 1.0; priceOffset = 0 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Timings.bannerShowDuration) {
            withAnimation(.easeOut(duration: Timings.bannerHideDuration)) { showCartBanner = false }
        }
    }

    private func triggerSlideHaptic() {
        #if canImport(UIKit)
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
        #endif
    }

    private func triggerAddToCartHaptic() {
        #if canImport(UIKit)
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        #endif
    }

    private func rotateDonut(by delta: Double) {
        guard !isRotatingDonut else { return }
        isRotatingDonut = true

        withAnimation(Springs.rotate) { donutRotation += delta }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            donutRotation = donutRotation.truncatingRemainder(dividingBy: 360)
            isRotatingDonut = false
        }
    }

    private func startGlowPulse() {
        withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
            glowOpacity = 0.38
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
