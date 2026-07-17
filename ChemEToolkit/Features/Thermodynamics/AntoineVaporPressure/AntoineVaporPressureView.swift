import SwiftUI

struct AntoineVaporPressureView:
    View {

    @State private var temperatureInput = "100"
    @State private var coefficientAInput = "8.07131"
    @State private var coefficientBInput = "1730.63"
    @State private var coefficientCInput = "233.426"

    @State private var result:
        AntoineVaporPressureResult?

    @State private var errorMessage = ""

    private let engine =
        AntoineVaporPressureEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "gauge.with.dots.needle.67percent",
                    title: "Antoine Vapor Pressure",
                    subtitle: "Estimate saturation pressure from Antoine coefficients",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use a coefficient set whose temperature and pressure units match the entered values.")
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
                            title: "Temperature",
                            symbol: "T",
                            unit: "°C",
                            placeholder: "100",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title: "Coefficient A",
                            symbol: "A",
                            unit: "—",
                            placeholder: "8.07131",
                            text: $coefficientAInput
                        )

                        EngineeringInputField(
                            title: "Coefficient B",
                            symbol: "B",
                            unit: "°C",
                            placeholder: "1730.63",
                            text: $coefficientBInput
                        )

                        EngineeringInputField(
                            title: "Coefficient C",
                            symbol: "C",
                            unit: "°C",
                            placeholder: "233.426",
                            text: $coefficientCInput
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
                            systemImage: "gauge.with.dots.needle.67percent",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Vapor Pressure",
                                        value: numberFormatter.format(result.vaporPressure),
                                        unit: "coefficient pressure unit"
                                    ),
.init(
                                        label: "log₁₀(P)",
                                        value: numberFormatter.format(result.log10Pressure),
                                        unit: "—"
                                    ),
.init(
                                        label: "ln(P)",
                                        value: numberFormatter.format(result.naturalLogPressure),
                                        unit: "—"
                                    ),
.init(
                                        label: "C + T",
                                        value: numberFormatter.format(result.denominator),
                                        unit: "°C"
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
        .navigationTitle("Antoine Vapor Pressure")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    temperatureCelsius:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName: "temperature"
                        ),
                    coefficientA:
                        try InputValidator.parseNumber(
                            coefficientAInput,
                            fieldName:
                                "coefficient A"
                        ),
                    coefficientB:
                        try InputValidator.parseNumber(
                            coefficientBInput,
                            fieldName:
                                "coefficient B"
                        ),
                    coefficientC:
                        try InputValidator.parseNumber(
                            coefficientCInput,
                            fieldName:
                                "coefficient C"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        temperatureInput = "100"
        coefficientAInput = "8.07131"
        coefficientBInput = "1730.63"
        coefficientCInput = "233.426"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        temperatureInput = ""
        coefficientAInput = ""
        coefficientBInput = ""
        coefficientCInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AntoineVaporPressureView()
    }
}
