import SwiftUI

struct CascadeControlView: View {
    @State private var primaryProcessInput = "2"
    @State private var secondaryProcessInput = "3"
    @State private var primaryControllerInput = "1.5"
    @State private var secondaryControllerInput = "2"
    @State private var referenceInput = "10"
    @State private var disturbanceInput = "4"

    @State private var result: CascadeControlResult?
    @State private var errorMessage = ""

    private let engine = CascadeControlEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "point.3.connected.trianglepath.dotted",
                    title: "Cascade Control",
                    subtitle: "Analyze nested inner and outer feedback loops",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("A well-designed inner loop rejects secondary disturbances before they strongly affect the primary controlled variable.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Primary Process Gain",
                            symbol: "G₁",
                            unit: "—",
                            placeholder: "2",
                            text: $primaryProcessInput
                        )

                        EngineeringInputField(
                            title: "Secondary Process Gain",
                            symbol: "G₂",
                            unit: "—",
                            placeholder: "3",
                            text: $secondaryProcessInput
                        )

                        EngineeringInputField(
                            title: "Primary Controller Gain",
                            symbol: "Kc₁",
                            unit: "—",
                            placeholder: "1.5",
                            text: $primaryControllerInput
                        )

                        EngineeringInputField(
                            title: "Secondary Controller Gain",
                            symbol: "Kc₂",
                            unit: "—",
                            placeholder: "2",
                            text: $secondaryControllerInput
                        )

                        EngineeringInputField(
                            title: "Primary Reference Input",
                            symbol: "r₁",
                            unit: "units",
                            placeholder: "10",
                            text: $referenceInput
                        )

                        EngineeringInputField(
                            title: "Secondary-Loop Disturbance",
                            symbol: "d₂",
                            unit: "units",
                            placeholder: "4",
                            text: $disturbanceInput
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
                            systemImage: "point.3.connected.trianglepath.dotted",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Inner Closed-Loop Gain",
                                        value: numberFormatter.format(result.innerClosedLoopGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Inner Sensitivity",
                                        value: numberFormatter.format(result.innerSensitivity),
                                        unit: "—"
                                    ),
.init(
                                        label: "Outer Loop Gain",
                                        value: numberFormatter.format(result.outerLoopGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Outer Closed-Loop Gain",
                                        value: numberFormatter.format(result.outerClosedLoopGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Reference Contribution",
                                        value: numberFormatter.format(result.outputFromReference),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Disturbance Contribution",
                                        value: numberFormatter.format(result.outputFromSecondaryDisturbance),
                                        unit: "output units"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName)
                                        .font(.headline)

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
        .navigationTitle("Cascade Control")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    primaryProcessGain: try InputValidator.parseNumber(
                        primaryProcessInput,
                        fieldName: "primary process gain"
                    ),
                    secondaryProcessGain: try InputValidator.parseNumber(
                        secondaryProcessInput,
                        fieldName: "secondary process gain"
                    ),
                    primaryControllerGain: try InputValidator.parseNumber(
                        primaryControllerInput,
                        fieldName: "primary controller gain"
                    ),
                    secondaryControllerGain: try InputValidator.parseNumber(
                        secondaryControllerInput,
                        fieldName: "secondary controller gain"
                    ),
                    primaryReferenceInput: try InputValidator.parseNumber(
                        referenceInput,
                        fieldName: "primary reference input"
                    ),
                    secondaryLoopDisturbance: try InputValidator.parseNumber(
                        disturbanceInput,
                        fieldName: "secondary-loop disturbance"
                    )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        primaryProcessInput = "2"
        secondaryProcessInput = "3"
        primaryControllerInput = "1.5"
        secondaryControllerInput = "2"
        referenceInput = "10"
        disturbanceInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        primaryProcessInput = ""
        secondaryProcessInput = ""
        primaryControllerInput = ""
        secondaryControllerInput = ""
        referenceInput = ""
        disturbanceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CascadeControlView()
    }
}
