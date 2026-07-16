import SwiftUI

struct FirstOrderFrequencyResponseView: View {
    @State private var gainInput = "2"
    @State private var timeInput = "4"
    @State private var frequencyInput = "0.25"
    @State private var result: FirstOrderFrequencyResponseResult?
    @State private var errorMessage = ""

    private let engine = FirstOrderFrequencyResponseEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path",
                    title: "First-Order Frequency Response",
                    subtitle: "Evaluate magnitude, phase and cutoff behavior at one frequency",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("At ωτ = 1, a positive-gain first-order process has −3.01 dB magnitude attenuation and −45° phase.")
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
                            placeholder: "2",
                            text: $gainInput
                        )

                        EngineeringInputField(
                            title: "Time Constant",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "4",
                            text: $timeInput
                        )

                        EngineeringInputField(
                            title: "Angular Frequency",
                            symbol: "ω",
                            unit: "rad/time",
                            placeholder: "0.25",
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
                            systemImage: "waveform.path",
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
                                        label: "Real Part",
                                        value: numberFormatter.format(result.realPart),
                                        unit: "—"
                                    ),
.init(
                                        label: "Imaginary Part",
                                        value: numberFormatter.format(result.imaginaryPart),
                                        unit: "—"
                                    ),
.init(
                                        label: "Cutoff Frequency",
                                        value: numberFormatter.format(result.cutoffAngularFrequency),
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
        .navigationTitle("First-Order Frequency Response")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    processGain: try InputValidator.parseNumber(gainInput, fieldName: "process gain"),
                    timeConstant: try InputValidator.parseNumber(timeInput, fieldName: "time constant"),
                    angularFrequency: try InputValidator.parseNumber(frequencyInput, fieldName: "angular frequency")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        gainInput = "2"
        timeInput = "4"
        frequencyInput = "0.25"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        gainInput = ""
        timeInput = ""
        frequencyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { FirstOrderFrequencyResponseView() } }
