import SwiftUI

struct GasReliefValveSizingView:
    View {

    @State private var massFlowInput = "2"
    @State private var upstreamPressureInput = "1000000"
    @State private var backPressureInput = "101325"
    @State private var temperatureInput = "400"
    @State private var molecularWeightInput = "28"
    @State private var gammaInput = "1.4"
    @State private var dischargeCoefficientInput = "0.9"

    @State private var result:
        GasReliefValveSizingResult?

    @State private var errorMessage = ""

    private let engine =
        GasReliefValveSizingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title: "Gas Relief Valve Sizing",
                    subtitle: "Estimate ideal-gas relief-orifice area for choked or subcritical flow",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The engine determines the ideal-gas pressure regime and solves the required effective orifice area.")
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
                            title: "Required Mass Flow Rate",
                            symbol: "ṁ",
                            unit: "kg/s",
                            placeholder: "2",
                            text: $massFlowInput
                        )

                        EngineeringInputField(
                            title: "Upstream Absolute Pressure",
                            symbol: "P₀",
                            unit: "Pa abs",
                            placeholder: "1000000",
                            text: $upstreamPressureInput
                        )

                        EngineeringInputField(
                            title: "Back Absolute Pressure",
                            symbol: "P₂",
                            unit: "Pa abs",
                            placeholder: "101325",
                            text: $backPressureInput
                        )

                        EngineeringInputField(
                            title: "Relieving Temperature",
                            symbol: "T",
                            unit: "K",
                            placeholder: "400",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title: "Molecular Weight",
                            symbol: "MW",
                            unit: "kg/kmol",
                            placeholder: "28",
                            text: $molecularWeightInput
                        )

                        EngineeringInputField(
                            title: "Heat-Capacity Ratio",
                            symbol: "γ",
                            unit: "—",
                            placeholder: "1.4",
                            text: $gammaInput
                        )

                        EngineeringInputField(
                            title: "Discharge Coefficient",
                            symbol: "C_d",
                            unit: "—",
                            placeholder: "0.9",
                            text: $dischargeCoefficientInput
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
                            systemImage: "wind",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Flow Regime",
                                        value: result.flowIsChoked ? "Choked" : "Subcritical",
                                        unit: "—"
                                    ),
.init(
                                        label: "Pressure Ratio",
                                        value: numberFormatter.format(result.pressureRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Critical Pressure Ratio",
                                        value: numberFormatter.format(result.criticalPressureRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Mass Flux",
                                        value: numberFormatter.format(result.massFlux),
                                        unit: "kg/(m²·s)"
                                    ),
.init(
                                        label: "Required Flow Area",
                                        value: numberFormatter.format(result.requiredFlowArea),
                                        unit: "m²"
                                    ),
.init(
                                        label: "Equivalent Diameter",
                                        value: numberFormatter.format(1000 * result.equivalentOrificeDiameter),
                                        unit: "mm"
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
        .navigationTitle("Gas Relief Valve Sizing")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    requiredMassFlowRate:
                        try InputValidator.parseNumber(
                            massFlowInput,
                            fieldName:
                                "required mass flow rate"
                        ),
                    upstreamAbsolutePressure:
                        try InputValidator.parseNumber(
                            upstreamPressureInput,
                            fieldName:
                                "upstream absolute pressure"
                        ),
                    backAbsolutePressure:
                        try InputValidator.parseNumber(
                            backPressureInput,
                            fieldName:
                                "back absolute pressure"
                        ),
                    relievingTemperature:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName:
                                "relieving temperature"
                        ),
                    molecularWeight:
                        try InputValidator.parseNumber(
                            molecularWeightInput,
                            fieldName:
                                "molecular weight"
                        ),
                    heatCapacityRatio:
                        try InputValidator.parseNumber(
                            gammaInput,
                            fieldName:
                                "heat-capacity ratio"
                        ),
                    dischargeCoefficient:
                        try InputValidator.parseNumber(
                            dischargeCoefficientInput,
                            fieldName:
                                "discharge coefficient"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massFlowInput = "2"
        upstreamPressureInput = "1000000"
        backPressureInput = "101325"
        temperatureInput = "400"
        molecularWeightInput = "28"
        gammaInput = "1.4"
        dischargeCoefficientInput = "0.9"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massFlowInput = ""
        upstreamPressureInput = ""
        backPressureInput = ""
        temperatureInput = ""
        molecularWeightInput = ""
        gammaInput = ""
        dischargeCoefficientInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        GasReliefValveSizingView()
    }
}
