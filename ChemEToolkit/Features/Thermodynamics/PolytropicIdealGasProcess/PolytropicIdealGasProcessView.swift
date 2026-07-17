import SwiftUI

struct PolytropicIdealGasProcessView:
    View {

    @State private var initialPressureInput = "1000"
    @State private var initialVolumeInput = "1"
    @State private var finalPressureInput = "200"
    @State private var exponentInput = "1.3"

    @State private var result:
        PolytropicIdealGasProcessResult?

    @State private var errorMessage = ""

    private let engine =
        PolytropicIdealGasProcessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.xyaxis.line",
                    title: "Polytropic Ideal-Gas Process",
                    subtitle: "Calculate final volume and boundary work",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The process follows PVⁿ = constant. Use absolute pressures and n different from one.")
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
                            title: "Initial Absolute Pressure",
                            symbol: "P₁",
                            unit: "kPa abs",
                            placeholder: "1000",
                            text: $initialPressureInput
                        )

                        EngineeringInputField(
                            title: "Initial Volume",
                            symbol: "V₁",
                            unit: "m³",
                            placeholder: "1",
                            text: $initialVolumeInput
                        )

                        EngineeringInputField(
                            title: "Final Absolute Pressure",
                            symbol: "P₂",
                            unit: "kPa abs",
                            placeholder: "200",
                            text: $finalPressureInput
                        )

                        EngineeringInputField(
                            title: "Polytropic Exponent",
                            symbol: "n",
                            unit: "—",
                            placeholder: "1.3",
                            text: $exponentInput
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
                            systemImage: "chart.xyaxis.line",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Final Volume",
                                        value: numberFormatter.format(result.finalVolume),
                                        unit: "m³"
                                    ),
.init(
                                        label: "Pressure Ratio, P₂/P₁",
                                        value: numberFormatter.format(result.pressureRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Volume Ratio, V₂/V₁",
                                        value: numberFormatter.format(result.volumeRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Work by System",
                                        value: numberFormatter.format(result.workBySystem),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Initial PV",
                                        value: numberFormatter.format(result.initialPV),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Final PV",
                                        value: numberFormatter.format(result.finalPV),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Process",
                                        value: result.processDirection,
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
        .navigationTitle("Polytropic Ideal-Gas Process")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialAbsolutePressure:
                        try InputValidator.parseNumber(
                            initialPressureInput,
                            fieldName:
                                "initial absolute pressure"
                        ),
                    initialVolume:
                        try InputValidator.parseNumber(
                            initialVolumeInput,
                            fieldName:
                                "initial volume"
                        ),
                    finalAbsolutePressure:
                        try InputValidator.parseNumber(
                            finalPressureInput,
                            fieldName:
                                "final absolute pressure"
                        ),
                    polytropicExponent:
                        try InputValidator.parseNumber(
                            exponentInput,
                            fieldName:
                                "polytropic exponent"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialPressureInput = "1000"
        initialVolumeInput = "1"
        finalPressureInput = "200"
        exponentInput = "1.3"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialPressureInput = ""
        initialVolumeInput = ""
        finalPressureInput = ""
        exponentInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PolytropicIdealGasProcessView()
    }
}
