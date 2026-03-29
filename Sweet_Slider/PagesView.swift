import SwiftUI

// MARK: - Cart Page View

struct CartPageView: View {
    let cartStore: CartStore
    @Binding var currentPage: AppPage
    let donuts: [Donut]
    let themeColor: Color

    var selectedDonutColor: Color {
        guard let firstID = cartStore.items.keys.first else { return themeColor }
        return donuts[firstID].color
    }

    var body: some View {
        ZStack {
            // Gradient background matching main theme
            LinearGradient(
                colors: [
                    selectedDonutColor.opacity(0.60),
                    selectedDonutColor.opacity(0.34)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [.white.opacity(0.15), .clear],
                center: .init(x: 0.5, y: 0.25),
                startRadius: 50,
                endRadius: 300
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [.clear, .black.opacity(0.14)],
                center: .bottom,
                startRadius: 110,
                endRadius: 520
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // Header
                HStack(spacing: 12) {
                    Button(action: { 
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage = .home
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.white.opacity(0.16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .strokeBorder(.white.opacity(0.32), lineWidth: 1)
                                )
                        )
                    }

                    Spacer()

                    Text("Cart")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.20), radius: 4, x: 0, y: 2)

                    Spacer()

                    Image(systemName: "cart.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(.white.opacity(0.16))
                                .overlay(Circle().stroke(.white.opacity(0.32), lineWidth: 1))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                if cartStore.items.isEmpty {
                    VStack {
                        Spacer()

                        VStack(spacing: 18) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.white.opacity(0.30), .white.opacity(0.12)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        Circle()
                                            .strokeBorder(.white.opacity(0.35), lineWidth: 1)
                                    )

                                Image(systemName: "cart.fill.badge.plus")
                                    .font(.system(size: 34, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 92, height: 92)
                            .shadow(color: selectedDonutColor.opacity(0.45), radius: 16, x: 0, y: 8)

                            VStack(spacing: 8) {
                                Text("Your cart is waiting")
                                    .font(.system(size: 24, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.26), radius: 3, x: 0, y: 1)

                                Text("Pick your favorite donuts and build your sweet box.")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.92))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 10)
                                    .shadow(color: .black.opacity(0.22), radius: 2, x: 0, y: 1)
                            }

                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage = .home
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("Browse Flavors")
                                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [selectedDonutColor.opacity(0.82), selectedDonutColor.opacity(0.62)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                                        )
                                )
                                .shadow(color: selectedDonutColor.opacity(0.34), radius: 10, x: 0, y: 6)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                                )
                                .overlay(
                                    LinearGradient(
                                        colors: [.white.opacity(0.20), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .center
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                )
                        )
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(cartStore.items.keys.sorted(), id: \.self) { donutID in
                                CartItemRow(
                                    donut: donuts[donutID],
                                    quantity: cartStore.items[donutID] ?? 0,
                                    onDecrement: {
                                        cartStore.decrement(donutID: donutID)
                                    }
                                )
                            }
                        }
                        .padding(16)
                    }

                    VStack(spacing: 14) {
                        HStack {
                            Text("Subtotal:")
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                            Text(cartStore.totalPrice.formatted(.currency(code: "INR")))
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(0.98))

                        Divider().background(.white.opacity(0.25))

                        HStack {
                            Text("Total:")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text(cartStore.totalPrice.formatted(.currency(code: "INR")))
                                .font(.system(size: 20, weight: .black))
                        }
                        .foregroundColor(.white)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(.white.opacity(0.32), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

                    Button(action: {}) {
                        Text("Proceed to Checkout")
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                selectedDonutColor.opacity(0.84),
                                                selectedDonutColor.opacity(0.64)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                                    )
                            )
                            .shadow(color: selectedDonutColor.opacity(0.30), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct CartItemRow: View {
    let donut: Donut
    let quantity: Int
    let onDecrement: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(donut.imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .shadow(color: donut.color.opacity(0.40), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(donut.displayName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 1)
                Text("Qty: \(quantity)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.92))
            }
            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text((donut.price * Double(quantity)).formatted(.currency(code: "INR")))
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.24), radius: 2, x: 0, y: 1)

                Button(action: onDecrement) {
                    HStack(spacing: 4) {
                        Image(systemName: quantity == 1 ? "trash.fill" : "arrow.down.circle.fill")
                            .font(.system(size: 11, weight: .bold))
                        Text(quantity == 1 ? "Remove" : "Reduce")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.20))
                            .overlay(
                                Capsule()
                                    .strokeBorder(.white.opacity(0.34), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                )
        )
    }
}

// MARK: - Profile Page View

struct ProfilePageView: View {
    @Binding var currentPage: AppPage
    let themeColor: Color
    
    private var accentColor: Color { themeColor }
    private var secondaryAccent: Color { themeColor.opacity(0.85) }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    accentColor.opacity(0.60),
                    accentColor.opacity(0.34)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            RadialGradient(
                colors: [.white.opacity(0.15), .clear],
                center: .init(x: 0.5, y: 0.25),
                startRadius: 50,
                endRadius: 300
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [secondaryAccent.opacity(0.18), .clear],
                center: .init(x: 0.18, y: 0.88),
                startRadius: 30,
                endRadius: 240
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [.clear, .black.opacity(0.14)],
                center: .bottom,
                startRadius: 110,
                endRadius: 520
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage = .home
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.white.opacity(0.16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                                )
                        )
                    }

                    Spacer()

                    Text("Profile")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.20), radius: 4, x: 0, y: 2)

                    Spacer()

                    Image(systemName: "person.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(.white.opacity(0.16))
                                .overlay(Circle().stroke(.white.opacity(0.30), lineWidth: 1))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                .white.opacity(0.26),
                                                .white.opacity(0.12)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        Circle()
                                            .strokeBorder(.white.opacity(0.34), lineWidth: 1)
                                    )
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 80, height: 80)
                            .shadow(color: accentColor.opacity(0.42), radius: 12, x: 0, y: 8)

                            Text("Sweet Lover")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.26), radius: 3, x: 0, y: 1)
                            Text("user@sweetslider.com")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.92))
                                .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 1)

                            HStack(spacing: 8) {
                                Label("Gold Member", systemImage: "sparkles")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(accentColor.opacity(0.35))
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                                            )
                                    )

                                Text("12 Orders")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.96))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(.white.opacity(0.12))
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(.white.opacity(0.24), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                                )
                                .overlay(
                                    LinearGradient(
                                        colors: [.white.opacity(0.20), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .center
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                )
                        )

                        HStack(spacing: 10) {
                            profileMetricCard(
                                icon: "gift.fill",
                                title: "Rewards",
                                value: "450 pts",
                                tint: secondaryAccent
                            )
                            profileMetricCard(
                                icon: "clock.fill",
                                title: "Next Perk",
                                value: "2 orders",
                                tint: accentColor
                            )
                        }

                        VStack(spacing: 10) {
                            ProfileMenuRow(icon: "heart.fill", title: "Favorites", value: "8 items", tint: accentColor)
                            ProfileMenuRow(icon: "bag.fill", title: "Orders", value: "12 total", tint: accentColor)
                            ProfileMenuRow(icon: "star.fill", title: "Rewards", value: "450 pts", tint: accentColor)
                            ProfileMenuRow(icon: "bell.fill", title: "Notifications", value: "On", tint: accentColor)
                        }

                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("Sign Out")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.red.opacity(0.52),
                                                Color.red.opacity(0.34)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .red.opacity(0.28), radius: 10, x: 0, y: 6)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                    .padding(.bottom, 20)
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    @ViewBuilder
    private func profileMetricCard(icon: String, title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(tint.opacity(0.55))
                )

            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.94))

            Text(value)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                )
        )
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 32, alignment: .center)
                .foregroundColor(tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.92))
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.70))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(.white.opacity(0.30), lineWidth: 1)
                )
        )
    }
}
