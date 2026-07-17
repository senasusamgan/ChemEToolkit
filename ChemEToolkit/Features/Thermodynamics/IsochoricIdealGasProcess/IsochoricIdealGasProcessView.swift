import SwiftUI

struct IsochoricIdealGasProcessView:
    View {

    @State private var massInput = "1"
    @State private var cvInput = "0.718"
    @State private var initialTemperatureInput = "300"
    @State private var finalTemperatureInput = "500"

    @State private var result:
        IsochoricIdealGasProcessResult?

    @State private var errorMessage = ""

    private let engine =
        IsochoricIdealGasProcessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "shippingbox.fill",
                    title: "Isochoric Ideal-Gas Process",
                    subtitle: "Calculate rigid-vessel heat and pressure change",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("At constant volume, boundary work is zero and pressure varies directly with absolute temperature.")
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
                            title: "Specific Heat, Cv",
                            symbol: "Cv",
                            unit: "kJ/(kg·K)",
                            placeholder: "0.718",
                            text: $cvInput
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
                            systemImage: "shippingbox.fill",
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
                                        label: "Internal-Energy Change",
                                        value: numberFormatter.format(result.internalEnergyChange),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Work by System",
                                        value: numberFormatter.format(result.workBySystem),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Pressure Ratio, P₂/P₁",
                                        value: numberFormatter.format(result.pressureRatio),
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
        .navigationTitle("Isochoric Ideal-Gas Process")
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
                    specificHeatAtConstantVolume:
                        try InputValidator.parseNumber(
                            cvInput,
                            fieldName:
                                "specific heat Cv"
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
        cvInput = "0.718"
        initialTemperatureInput = "300"
        finalTemperatureInput = "500"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        cvInput = ""
        initialTemperatureInput = ""
        finalTemperatureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IsochoricIdealGasProcessView()
    }
}
