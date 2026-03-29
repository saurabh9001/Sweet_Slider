import SwiftUI

struct DonutSlide: View {
    let donut: Donut
    let isSelected: Bool
    let rotation: Double
    let swipeRotation: Double
    let swipeProgress: Double
    let swipeScale: Double

    var body: some View {
        ZStack {
            Circle()
                .fill(donut.color.opacity(0.28))
                .frame(width: 210, height: 210)
                .blur(radius: 24)
                .scaleEffect(isSelected ? 1.08 : 0.7)
                .animation(
                    .easeInOut(duration: 2.2).repeatForever(autoreverses: true),
                    value: isSelected
                )

            Text(donut.title)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white.opacity(0.18))
                .scaleEffect(isSelected ? (1.0 - abs(swipeProgress) * 0.08) : 0.82)
                .animation(.spring(response: 0.85, dampingFraction: 0.80), value: isSelected)

            Image(donut.imageName)
                .resizable()
                .frame(width: 230, height: 230)
                .rotationEffect(.degrees(
                    rotation + swipeRotation + (isSelected ? 0 : Double(donut.id) * 3)
                ))
                .scaleEffect((isSelected ? 1.0 : 0.90) * (isSelected ? swipeScale : (1.0 - abs(swipeProgress) * 0.03)))
                .offset(x: isSelected ? swipeProgress * 6 : -swipeProgress * 8)
                .offset(y: isSelected ? (swipeProgress > 0 ? swipeProgress * 20 : swipeProgress * 18) : 0)
                .opacity(isSelected ? 1.0 : 0.62)
                .shadow(color: donut.color.opacity(0.45), radius: 22, x: 0, y: 12)
                .animation(.spring(response: 1.1, dampingFraction: 0.82), value: rotation)
        }
    }
}

struct QuantityStepper: View {
    @Binding var quantity: Int

    var body: some View {
        HStack(spacing: 0) {
            Button(action: decrement) {
                Image(systemName: "minus")
                    .frame(width: 40, height: 44)
                    .foregroundColor(.black.opacity(0.60))
                    .background(Color.clear)
            }
            .contentShape(Rectangle())

            Text("\(quantity)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.80))
                .frame(width: 36, height: 44)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.85, dampingFraction: 0.80), value: quantity)

            Button(action: increment) {
                Image(systemName: "plus")
                    .frame(width: 40, height: 44)
                    .foregroundColor(.black.opacity(0.60))
                    .background(Color.clear)
            }
            .contentShape(Rectangle())
        }
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.42), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func decrement() {
        if quantity > 1 {
            withAnimation(.spring(response: 0.85, dampingFraction: 0.80)) { quantity -= 1 }
        }
    }

    private func increment() {
        withAnimation(.spring(response: 0.85, dampingFraction: 0.80)) { quantity += 1 }
    }
}

struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(
                .spring(response: 0.55, dampingFraction: 0.75),
                value: configuration.isPressed
            )
    }
}

struct LiquidGlassPanel: View {
    let tint: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(.white.opacity(0.24))

                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.22),
                                    tint.opacity(0.10),
                                    .white.opacity(0.14)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .strokeBorder(.white.opacity(0.52), lineWidth: 1)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .strokeBorder(.white.opacity(0.20), lineWidth: 2)
                    .blur(radius: 1.5)
                    .padding(1)
            }
    }
}
