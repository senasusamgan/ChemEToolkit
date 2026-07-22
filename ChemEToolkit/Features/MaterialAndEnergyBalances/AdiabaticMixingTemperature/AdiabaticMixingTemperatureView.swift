import SwiftUI

struct AdiabaticMixingTemperatureView:
    View {

    @State private var flow1Input = "2"
    @State private var cp1Input = "4"
    @State private var temperature1Input = "80"
    @State private var flow2Input = "3"
    @State private var cp2Input = "2"
    @State private var temperature2Input = "20"

    @State private var result:
        AdiabaticMixingTemperatureResult?

    @State private var errorMessage = ""

    private let engine =
        AdiabaticMixingTemperatureEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.merge",
                    title: "Adiabatic Mixing Temperature",
                    subtitle: "Calculate the outlet temperature of two mixed streams",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The mixed temperature is weighted by each stream's heat-capacity rate.")
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
                            title: "Stream 1 Mass Flow",
                            symbol: "ṁ₁",
                            unit: "kg/s",
                            placeholder: "2",
                            text: $flow1Input
                        )

                        EngineeringInputField(
                            title: "Stream 1 Heat Capacity",
                            symbol: "Cp₁",
                            unit: "kJ/(kg·K)",
                            placeholder: "4",
                            text: $cp1Input
                        )

                        EngineeringInputField(
                            title: "Stream 1 Temperature",
                            symbol: "T₁",
                            unit: "°C or K",
                            placeholder: "80",
                            text: $temperature1Input
                        )

                        EngineeringInputField(
                            title: "Stream 2 Mass Flow",
                            symbol: "ṁ₂",
                            unit: "kg/s",
                            placeholder: "3",
                            text: $flow2Input
                        )

                        EngineeringInputField(
                            title: "Stream 2 Heat Capacity",
                            symbol: "Cp₂",
                            unit: "kJ/(kg·K)",
                            placeholder: "2",
                            text: $cp2Input
                        )

                        EngineeringInputField(
                            title: "Stream 2 Temperature",
                            symbol: "T₂",
                            unit: "same scale",
                            placeholder: "20",
                            text: $temperature2Input
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
                            systemImage: "arrow.triangle.merge",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Mixed Temperature",
                                        value: numberFormatter.format(result.mixedTemperature),
                                        unit: "input temperature scale"
                                    ),
.init(
                                        label: "Total Mass Flow",
                                        value: numberFormatter.format(result.totalMassFlow),
                                        unit: "kg/s"
                                    ),
.init(
                                        label: "Stream 1 Capacity Rate",
                                        value: numberFormatter.format(result.stream1HeatCapacityRate),
                                        unit: "kW/K"
                                    ),
.init(
                                        label: "Stream 2 Capacity Rate",
                                        value: numberFormatter.format(result.stream2HeatCapacityRate),
                                        unit: "kW/K"
                                    ),
.init(
                                        label: "Total Capacity Rate",
                                        value: numberFormatter.format(result.totalHeatCapacityRate),
                                        unit: "kW/K"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Adiabatic Mixing Temperature")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    stream1MassFlow:
                        try InputValidator.parseNumber(
                            flow1Input,
                            fieldName:
                                "stream 1 mass flow"
                        ),
                    stream1HeatCapacity:
                        try InputValidator.parseNumber(
                            cp1Input,
                            fieldName:
                                "stream 1 heat capacity"
                        ),
                    stream1Temperature:
                        try InputValidator.parseNumber(
                            temperature1Input,
                            fieldName:
                                "stream 1 temperature"
                        ),
                    stream2MassFlow:
                        try InputValidator.parseNumber(
                            flow2Input,
                            fieldName:
                                "stream 2 mass flow"
                        ),
                    stream2HeatCapacity:
                        try InputValidator.parseNumber(
                            cp2Input,
                            fieldName:
                                "stream 2 heat capacity"
                        ),
                    stream2Temperature:
                        try InputValidator.parseNumber(
                            temperature2Input,
                            fieldName:
                                "stream 2 temperature"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flow1Input = "2"
        cp1Input = "4"
        temperature1Input = "80"
        flow2Input = "3"
        cp2Input = "2"
        temperature2Input = "20"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flow1Input = ""
        cp1Input = ""
        temperature1Input = ""
        flow2Input = ""
        cp2Input = ""
        temperature2Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AdiabaticMixingTemperatureView()
    }
}
