import SwiftUI

struct EmergencyVentilationDilutionView:
    View {

    @State private var volumeInput = "1000"
    @State private var flowInput = "2"
    @State private var initialConcentrationInput = "10000"
    @State private var targetConcentrationInput = "1000"
    @State private var elapsedTimeInput = "600"

    @State private var result:
        EmergencyVentilationDilutionResult?

    @State private var errorMessage = ""

    private let engine =
        EmergencyVentilationDilutionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "fan.fill",
                    title: "Emergency Ventilation Dilution",
                    subtitle: "Estimate well-mixed contaminant decay after a release stops",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The exponential dilution model calculates air changes, concentration decay and time to a selected target.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Enclosure Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "1000",
                            text: $volumeInput
                        )

                        EngineeringInputField(
                            title: "Ventilation Flow Rate",
                            symbol: "Q",
                            unit: "m³/s",
                            placeholder: "2",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Initial Concentration",
                            symbol: "C₀",
                            unit: "ppm or consistent units",
                            placeholder: "10000",
                            text: $initialConcentrationInput
                        )

                        EngineeringInputField(
                            title: "Target Concentration",
                            symbol: "C_t",
                            unit: "same units",
                            placeholder: "1000",
                            text: $targetConcentrationInput
                        )

                        EngineeringInputField(
                            title: "Elapsed Time",
                            symbol: "t",
                            unit: "s",
                            placeholder: "600",
                            text: $elapsedTimeInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "fan.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Air Changes per Hour",
                                        value: numberFormatter.format(result.airChangesPerHour),
                                        unit: "1/hour"
                                    ),
.init(
                                        label: "Dilution Time Constant",
                                        value: numberFormatter.format(result.dilutionTimeConstant),
                                        unit: "s"
                                    ),
.init(
                                        label: "Concentration after Time",
                                        value: numberFormatter.format(result.concentrationAfterElapsedTime),
                                        unit: "input concentration units"
                                    ),
.init(
                                        label: "Time to Target",
                                        value: numberFormatter.format(result.timeToTargetConcentration),
                                        unit: "s"
                                    ),
.init(
                                        label: "Removal after Time",
                                        value: numberFormatter.format(100 * result.removalFractionAfterElapsedTime),
                                        unit: "%"
                                    ),
.init(
                                        label: "Target Reached",
                                        value: result.targetReachedWithinElapsedTime ? "Yes" : "No",
                                        unit: "—"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.small
                                ) {
                                    Text(result.modelName)
                                        .font(.headline)

                                    Divider()

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message: errorMessage
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(
                .horizontal,
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("Emergency Ventilation Dilution")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    enclosureVolume:
                        try InputValidator.parseNumber(
                            volumeInput,
                            fieldName:
                                "enclosure volume"
                        ),
                    ventilationFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "ventilation flow rate"
                        ),
                    initialConcentration:
                        try InputValidator.parseNumber(
                            initialConcentrationInput,
                            fieldName:
                                "initial concentration"
                        ),
                    targetConcentration:
                        try InputValidator.parseNumber(
                            targetConcentrationInput,
                            fieldName:
                                "target concentration"
                        ),
                    elapsedTime:
                        try InputValidator.parseNumber(
                            elapsedTimeInput,
                            fieldName:
                                "elapsed time"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        volumeInput = "1000"
        flowInput = "2"
        initialConcentrationInput = "10000"
        targetConcentrationInput = "1000"
        elapsedTimeInput = "600"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        volumeInput = ""
        flowInput = ""
        initialConcentrationInput = ""
        targetConcentrationInput = ""
        elapsedTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EmergencyVentilationDilutionView()
    }
}
