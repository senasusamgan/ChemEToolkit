import SwiftUI

struct SecondOrderFrequencyResponseView: View {
    @State private var gainInput = "1"
    @State private var naturalInput = "2"
    @State private var dampingInput = "0.4"
    @State private var frequencyInput = "2"
    @State private var result: SecondOrderFrequencyResponseResult?
    @State private var errorMessage = ""

    private let engine = SecondOrderFrequencyResponseEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path.ecg",
                    title: "Second-Order Frequency Response",
                    subtitle: "Evaluate magnitude, phase and resonance at one frequency",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("A resonant peak exists only when the damping ratio is below 1/√2.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Process Gain",
                            symbol: "K",
                            unit: "output/input",
                            placeholder: "1",
                            text: $gainInput
                        )

                        EngineeringInputField(
                            title: "Natural Frequency",
                            symbol: "ωₙ",
                            unit: "rad/time",
                            placeholder: "2",
                            text: $naturalInput
                        )

                        EngineeringInputField(
                            title: "Damping Ratio",
                            symbol: "ζ",
                            unit: "—",
                            placeholder: "0.4",
                            text: $dampingInput
                        )

                        EngineeringInputField(
                            title: "Angular Frequency",
                            symbol: "ω",
                            unit: "rad/time",
                            placeholder: "2",
                            text: $frequencyInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "waveform.path.ecg",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Magnitude",
                                        value: numberFormatter.format(result.magnitude),
                                        unit: "—"
                                    ),
.init(
                                        label: "Magnitude",
                                        value: numberFormatter.format(result.magnitudeDecibels),
                                        unit: "dB"
                                    ),
.init(
                                        label: "Phase",
                                        value: numberFormatter.format(result.phaseDegrees),
                                        unit: "degrees"
                                    ),
.init(
                                        label: "Normalized Frequency",
                                        value: numberFormatter.format(result.normalizedFrequency),
                                        unit: "ω/ωₙ"
                                    ),
.init(
                                        label: "Resonance",
                                        value: result.resonanceExists ? "Yes" : "No",
                                        unit: "—"
                                    ),
.init(
                                        label: "Resonance Frequency",
                                        value: result.resonanceAngularFrequency.map { numberFormatter.format($0) } ?? "No resonance",
                                        unit: "rad/time"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Second-Order Frequency Response")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    processGain: try InputValidator.parseNumber(gainInput, fieldName: "process gain"),
                    naturalFrequency: try InputValidator.parseNumber(naturalInput, fieldName: "natural frequency"),
                    dampingRatio: try InputValidator.parseNumber(dampingInput, fieldName: "damping ratio"),
                    angularFrequency: try InputValidator.parseNumber(frequencyInput, fieldName: "angular frequency")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        gainInput = "1"
        naturalInput = "2"
        dampingInput = "0.4"
        frequencyInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        gainInput = ""
        naturalInput = ""
        dampingInput = ""
        frequencyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { SecondOrderFrequencyResponseView() } }
