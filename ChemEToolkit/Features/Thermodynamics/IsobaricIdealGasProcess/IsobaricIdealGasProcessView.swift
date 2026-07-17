import SwiftUI

struct IsobaricIdealGasProcessView:
    View {

    @State private var massInput = "1"
    @State private var cpInput = "1.005"
    @State private var gasConstantInput = "0.287"
    @State private var initialTemperatureInput = "300"
    @State private var finalTemperatureInput = "500"

    @State private var result:
        IsobaricIdealGasProcessResult?

    @State private var errorMessage = ""

    private let engine =
        IsobaricIdealGasProcessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.and.down.and.arrow.left.and.right",
                    title: "Isobaric Ideal-Gas Process",
                    subtitle: "Calculate constant-pressure heat, work and ΔU",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Cp and R must use the same energy, mass and temperature units.")
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
                            title: "Mass",
                            symbol: "m",
                            unit: "kg",
                            placeholder: "1",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Specific Heat, Cp",
                            symbol: "Cp",
                            unit: "kJ/(kg·K)",
                            placeholder: "1.005",
                            text: $cpInput
                        )

                        EngineeringInputField(
                            title: "Specific Gas Constant",
                            symbol: "R",
                            unit: "kJ/(kg·K)",
                            placeholder: "0.287",
                            text: $gasConstantInput
                        )

                        EngineeringInputField(
                            title: "Initial Temperature",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "300",
                            text: $initialTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Final Temperature",
                            symbol: "T₂",
                            unit: "K",
                            placeholder: "500",
                            text: $finalTemperatureInput
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
                            systemImage: "arrow.up.and.down.and.arrow.left.and.right",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Temperature Change",
                                        value: numberFormatter.format(result.temperatureChange),
                                        unit: "K"
                                    ),
.init(
                                        label: "Heat to System",
                                        value: numberFormatter.format(result.heatToSystem),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Work by System",
                                        value: numberFormatter.format(result.workBySystem),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Internal-Energy Change",
                                        value: numberFormatter.format(result.internalEnergyChange),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Volume Ratio, V₂/V₁",
                                        value: numberFormatter.format(result.volumeRatio),
                                        unit: "—"
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
        .navigationTitle("Isobaric Ideal-Gas Process")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    mass:
                        try InputValidator.parseNumber(
                            massInput,
                            fieldName: "mass"
                        ),
                    specificHeatAtConstantPressure:
                        try InputValidator.parseNumber(
                            cpInput,
                            fieldName:
                                "specific heat Cp"
                        ),
                    specificGasConstant:
                        try InputValidator.parseNumber(
                            gasConstantInput,
                            fieldName:
                                "specific gas constant"
                        ),
                    initialTemperatureKelvin:
                        try InputValidator.parseNumber(
                            initialTemperatureInput,
                            fieldName:
                                "initial temperature"
                        ),
                    finalTemperatureKelvin:
                        try InputValidator.parseNumber(
                            finalTemperatureInput,
                            fieldName:
                                "final temperature"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massInput = "1"
        cpInput = "1.005"
        gasConstantInput = "0.287"
        initialTemperatureInput = "300"
        finalTemperatureInput = "500"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        cpInput = ""
        gasConstantInput = ""
        initialTemperatureInput = ""
        finalTemperatureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IsobaricIdealGasProcessView()
    }
}
