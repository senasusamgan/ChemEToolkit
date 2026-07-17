import SwiftUI

struct LiquidLeakRateScreeningView:
    View {

    @State private var densityInput = "1000"
    @State private var upstreamPressureInput = "500000"
    @State private var downstreamPressureInput = "101325"
    @State private var coefficientInput = "0.62"
    @State private var diameterInput = "0.01"
    @State private var inventoryInput = "5"

    @State private var result:
        LiquidLeakRateScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        LiquidLeakRateScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.fill",
                    title: "Liquid Leak Rate Screening",
                    subtitle: "Estimate incompressible leak rate and inventory release time",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The module applies an orifice relation to liquid pressure drop and estimates a nominal inventory release duration.")
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
                            title: "Liquid Density",
                            symbol: "ρ",
                            unit: "kg/m³",
                            placeholder: "1000",
                            text: $densityInput
                        )

                        EngineeringInputField(
                            title: "Upstream Absolute Pressure",
                            symbol: "P₁",
                            unit: "Pa abs",
                            placeholder: "500000",
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
                            title: "Discharge Coefficient",
                            symbol: "C_d",
                            unit: "—",
                            placeholder: "0.62",
                            text: $coefficientInput
                        )

                        EngineeringInputField(
                            title: "Orifice Diameter",
                            symbol: "d",
                            unit: "m",
                            placeholder: "0.01",
                            text: $diameterInput
                        )

                        EngineeringInputField(
                            title: "Liquid Inventory Volume",
                            symbol: "V_inv",
                            unit: "m³",
                            placeholder: "5",
                            text: $inventoryInput
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
                            systemImage: "drop.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Pressure Difference",
                                        value: numberFormatter.format(result.pressureDifference),
                                        unit: "Pa"
                                    ),
.init(
                                        label: "Orifice Area",
                                        value: numberFormatter.format(result.orificeArea),
                                        unit: "m²"
                                    ),
.init(
                                        label: "Ideal Jet Velocity",
                                        value: numberFormatter.format(result.idealJetVelocity),
                                        unit: "m/s"
                                    ),
.init(
                                        label: "Volumetric Release Rate",
                                        value: numberFormatter.format(result.volumetricReleaseRate),
                                        unit: "m³/s"
                                    ),
.init(
                                        label: "Mass Release Rate",
                                        value: numberFormatter.format(result.massReleaseRate),
                                        unit: "kg/s"
                                    ),
.init(
                                        label: "Nominal Release Time",
                                        value: numberFormatter.format(result.releaseTimeMinutes),
                                        unit: "min"
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
        .navigationTitle("Liquid Leak Rate Screening")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    liquidDensity:
                        try InputValidator.parseNumber(
                            densityInput,
                            fieldName:
                                "liquid density"
                        ),
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
                        ),
                    liquidInventoryVolume:
                        try InputValidator.parseNumber(
                            inventoryInput,
                            fieldName:
                                "liquid inventory volume"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        densityInput = "1000"
        upstreamPressureInput = "500000"
        downstreamPressureInput = "101325"
        coefficientInput = "0.62"
        diameterInput = "0.01"
        inventoryInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        densityInput = ""
        upstreamPressureInput = ""
        downstreamPressureInput = ""
        coefficientInput = ""
        diameterInput = ""
        inventoryInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LiquidLeakRateScreeningView()
    }
}
