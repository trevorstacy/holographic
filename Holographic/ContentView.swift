import SwiftUI
import CoreMotion
import Noise

enum RelicType: String, CaseIterable, Identifiable {
    case regular = "Regular"
    case rare = "Rare"
    case superRare = "Super Rare"
    
    var id: Self { self }
}

struct ContentView: View {
    @State private var selectedType: RelicType = .regular
    @State private var motionManager: MotionManager = MotionManager()
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.innerBackground, .outerBackground], center: .center, startRadius: 300, endRadius: 600).ignoresSafeArea()

            VStack {
                Picker("Relic Type", selection: $selectedType) {
                    Text("Regular").tag(RelicType.regular)
                    Text("Rare").tag(RelicType.rare)
                    Text("Super Rare").tag(RelicType.superRare)
                }
                .frame(height: 50)
                
                HStack {
                    if selectedType == .regular {
                        Image("Planar")
                            .resizable()
                            .frame(width: 260, height: 280)
                            .aspectRatio(contentMode: .fill)
                            .shadow(radius: 30)
                    } else if selectedType == .rare {
                        Image("PlanarRare")
                            .resizable()
                            .frame(width: 260, height: 300)
                            .aspectRatio(contentMode: .fill)
                            .shadow(radius: 30)
                            .overlay(
                                ZStack {
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    colorWithOpacity(.red, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.orange, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.yellow, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.5, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.green, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.blue, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.purple, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .blendMode(.plusLighter)
                                        .opacity(0.3)
                                }
                            )
                    } else {
                        Image("PlanarSuperRare")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 260, height: 300)
                            .shadow(radius: 30)
                            .overlay(
                                ZStack {
                                    Noise(style: .random)
                                        .brightness(1.25)
                                        .blendMode(.plusLighter)
                                        .opacity(0.2)
                                    
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    colorWithOpacity(.red, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.orange, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.yellow, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.5, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.green, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.blue, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                    colorWithOpacity(.purple, pitch: motionManager.pitch, roll: motionManager.roll, minPitch: 0.4, maxPitch: 1.15, minRoll: -0.5, maxRoll: 0.5),
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .blendMode(.plusLighter)
                                        .opacity(0.4)
                                }
                            )
                    }
                }
                
                VStack {
                    Text("Pitch: \(String(format: "%.2f", motionManager.pitch * 100))")
                    Text("Rotation: \(String(format: "%.2f", motionManager.roll  * 100))")
                }
                .padding()
            }
            .padding()
            .preferredColorScheme(.dark)
        }
    }
    
    func colorWithOpacity(_ color: Color, pitch: Double, roll: Double, minPitch: Double, maxPitch: Double, minRoll: Double, maxRoll: Double) -> Color {
        let opacity = calculateOpacity(pitch: pitch, roll: roll, minPitch: minPitch, maxPitch: maxPitch, minRoll: minRoll, maxRoll: maxRoll, color: color)
        return color.opacity(opacity)
    }
    
    func calculateOpacity(pitch: Double, roll: Double, minPitch: Double, maxPitch: Double, minRoll: Double, maxRoll: Double, color: Color) -> Double {
        // Map pitch and roll to opacity based on color
        let normalizedPitch = pitch.normalized(from: minPitch...maxPitch, to: 0...1)
        let normalizedRoll = roll.normalized(from: minRoll...maxRoll, to: 0...1)
        
        var pitchOpacity: Double
        var rollOpacity: Double
        
        switch color {
        case .red, .orange, .yellow:
            pitchOpacity = normalizedPitch < 0.75 ? normalizedPitch / 0.75 : (1 - normalizedPitch) / 0.25
            rollOpacity = normalizedRoll < 0.75 ? normalizedRoll / 0.75 : (1 - normalizedRoll) / 0.25
        case .green, .blue, .purple:
            pitchOpacity = normalizedPitch < 0.75 ? normalizedPitch / 0.75 : (1 - normalizedPitch) / 0.25
            rollOpacity = normalizedRoll < 0.75 ? normalizedRoll / 0.75 : (1 - normalizedRoll) / 0.25
        default:
            pitchOpacity = 1.0
            rollOpacity = 1.0
        }
        
        // Combine pitch and roll opacities
        return min((pitchOpacity + rollOpacity) / 2, 1.0)
    }
}

extension Double {
    func normalized(from source: ClosedRange<Double>, to destination: ClosedRange<Double>) -> Double {
        let clampedValue = min(max(self, source.lowerBound), source.upperBound)
        return (clampedValue - source.lowerBound) / (source.upperBound - source.lowerBound) * (destination.upperBound - destination.lowerBound) + destination.lowerBound
    }
}

#Preview {
    ContentView()
}
