import SwiftUI

struct LiquidReliefValveSizingView:
    View {

    @State private var massFlowInput = "10"
    @State private var densityInput = "1000"
    @State private var inletPressureInput = "800000"
    @State private var backPressureInput = "101325"
    @State private var dischargeCoefficientInput = "0.62"

    @State private var result:
        LiquidReliefValveSizingResult?

    @State private var errorMessage = ""

    private let engine =
        LiquidReliefValveSizingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.triangle.fill",
                    title: "Liquid Relief Valve Sizing",
                    subtitle: "Estimate incompressible liquid relief-orifice area",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The screening model combines mass continuity with an incompressible Bernoulli orifice relation.")
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
                            placeholder: "10",
                            text: $massFlowInput
                        )

                        EngineeringInputField(
                            title: "Liquid Density",
                            symbol: "ρ",
                            unit: "kg/m³",
                            placeholder: "1000",
                            text: $densityInput
                        )

                        EngineeringInputField(
                            title: "Inlet Absolute Pressure",
                            symbol: "P₁",
                            unit: "Pa abs",
                            placeholder: "800000",
                            text: $inletPressureInput
                        )

                        EngineeringInputField(
                            title: "Back Absolute Pressure",
                            symbol: "P₂",
                            unit: "Pa abs",
                            placeholder: "101325",
                            text: $backPressureInput
                        )

                        EngineeringInputField(
                            title: "Discharge Coefficient",
                            symbol: "C_d",
                            unit: "—",
                            placeholder: "0.62",
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
                            systemImage: "drop.triangle.fill",
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
                                        label: "Required Volumetric Flow",
                                        value: numberFormatter.format(result.requiredVolumetricFlowRate),
                                        unit: "m³/s"
                                    ),
.init(
                                        label: "Ideal Jet Velocity",
                                        value: numberFormatter.format(result.idealJetVelocity),
                                        unit: "m/s"
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
                                    ),
.init(
                                        label: "Area per Mass Flow",
                                        value: numberFormatter.format(result.areaPerMassFlowRate),
                                        unit: "m²/(kg/s)"
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
        .navigationTitle("Liquid Relief Valve Sizing")
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
                    liquidDensity:
                        try InputValidator.parseNumber(
                            densityInput,
                            fieldName:
                                "liquid density"
                        ),
                    inletAbsolutePressure:
                        try InputValidator.parseNumber(
                            inletPressureInput,
                            fieldName:
                                "inlet absolute pressure"
                        ),
                    backAbsolutePressure:
                        try InputValidator.parseNumber(
                            backPressureInput,
                            fieldName:
                                "back absolute pressure"
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
        massFlowInput = "10"
        densityInput = "1000"
        inletPressureInput = "800000"
        backPressureInput = "101325"
        dischargeCoefficientInput = "0.62"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massFlowInput = ""
        densityInput = ""
        inletPressureInput = ""
        backPressureInput = ""
        dischargeCoefficientInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LiquidReliefValveSizingView()
    }
}
