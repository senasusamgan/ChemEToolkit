import SwiftUI

struct GasLeakRateScreeningView:
    View {

    @State private var upstreamPressureInput = "1000000"
    @State private var downstreamPressureInput = "101325"
    @State private var temperatureInput = "300"
    @State private var molecularWeightInput = "28"
    @State private var gammaInput = "1.4"
    @State private var coefficientInput = "0.8"
    @State private var diameterInput = "0.01"

    @State private var result:
        GasLeakRateScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        GasLeakRateScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cloud.fog.fill",
                    title: "Gas Leak Rate Screening",
                    subtitle: "Estimate ideal-gas mass release through an orifice",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The model detects choked or subcritical flow and converts mass flux into a leak rate.")
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
                            title: "Upstream Absolute Pressure",
                            symbol: "P₀",
                            unit: "Pa abs",
                            placeholder: "1000000",
                            text: $upstreamPressureInput
                        )

                        EngineeringInputField(
                            title: "Downstream Absolute Pressure",
                            symbol: "P₂",
                            unit: "Pa abs",
                            placeholder: "101325",
                            text: $downstreamPressureInput
                        )

                        EngineeringInputField(
                            title: "Gas Temperature",
                            symbol: "T",
                            unit: "K",
                            placeholder: "300",
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
                            placeholder: "0.8",
                            text: $coefficientInput
                        )

                        EngineeringInputField(
                            title: "Orifice Diameter",
                            symbol: "d",
                            unit: "m",
                            placeholder: "0.01",
                            text: $diameterInput
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
                            systemImage: "cloud.fog.fill",
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
                                        label: "Orifice Area",
                                        value: numberFormatter.format(result.orificeArea),
                                        unit: "m²"
                                    ),
.init(
                                        label: "Upstream Gas Density",
                                        value: numberFormatter.format(result.upstreamGasDensity),
                                        unit: "kg/m³"
                                    ),
.init(
                                        label: "Mass Flux",
                                        value: numberFormatter.format(result.massFlux),
                                        unit: "kg/(m²·s)"
                                    ),
.init(
                                        label: "Mass Release Rate",
                                        value: numberFormatter.format(result.massReleaseRate),
                                        unit: "kg/s"
                                    ),
.init(
                                        label: "Upstream Volumetric Rate",
                                        value: numberFormatter.format(result.upstreamVolumetricReleaseRate),
                                        unit: "m³/s"
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
        .navigationTitle("Gas Leak Rate Screening")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    upstreamAbsolutePressure:
                        try InputValidator.parseNumber(
                            upstreamPressureInput,
                            fieldName:
                                "upstream absolute pressure"
                        ),
                    downstreamAbsolutePressure:
                        try InputValidator.parseNumber(
                            downstreamPressureInput,
                            fieldName:
                                "downstream absolute pressure"
                        ),
                    gasTemperature:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName:
                                "gas temperature"
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
                            coefficientInput,
                            fieldName:
                                "discharge coefficient"
                        ),
                    orificeDiameter:
                        try InputValidator.parseNumber(
                            diameterInput,
                            fieldName:
                                "orifice diameter"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        upstreamPressureInput = "1000000"
        downstreamPressureInput = "101325"
        temperatureInput = "300"
        molecularWeightInput = "28"
        gammaInput = "1.4"
        coefficientInput = "0.8"
        diameterInput = "0.01"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        upstreamPressureInput = ""
        downstreamPressureInput = ""
        temperatureInput = ""
        molecularWeightInput = ""
        gammaInput = ""
        coefficientInput = ""
        diameterInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        GasLeakRateScreeningView()
    }
}
