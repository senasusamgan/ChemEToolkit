import SwiftUI

struct ReverseOsmosisPerformanceView:
    View {

    @State private var feedFlowInput = "10"
    @State private var membraneAreaInput = "100"
    @State private var waterPermeabilityInput = "1.5"
    @State private var appliedPressureInput = "15"
    @State private var osmoticPressureInput = "5"
    @State private var solutePermeabilityInput = "0.001"
    @State private var feedConcentrationInput = "2"

    @State private var result:
        ReverseOsmosisPerformanceResult?

    @State private var errorMessage = ""

    private let engine =
        ReverseOsmosisPerformanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.triangle.fill",
                    title: "Reverse Osmosis Performance",
                    subtitle:
                        "Calculate net driving pressure, water flux, rejection and recovery",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Solution–Diffusion Model")
                            .font(.headline)

                        Text("Jw = Aw(ΔP − Δπ)")
                            .font(.system(size: 20, weight: .semibold))

                        Text("Cp = B Cf / (Jw + B)")
                            .font(.system(size: 18, weight: .semibold))

                        Text(
                            "Aw is entered in LMH/bar, B in m/h, pressure in bar and concentration in consistent mass/volume units."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        Text("Feed and Membrane")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Feed Flow",
                            symbol: "Qf",
                            unit: "m³/h",
                            placeholder: "Example: 10",
                            text: $feedFlowInput
                        )

                        EngineeringInputField(
                            title: "Membrane Area",
                            symbol: "A",
                            unit: "m²",
                            placeholder: "Example: 100",
                            text: $membraneAreaInput
                        )

                        EngineeringInputField(
                            title: "Water Permeability",
                            symbol: "Aw",
                            unit: "LMH/bar",
                            placeholder: "Example: 1.5",
                            text: $waterPermeabilityInput
                        )

                        Divider()

                        Text("Driving Force")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Applied Pressure Difference",
                            symbol: "ΔP",
                            unit: "bar",
                            placeholder: "Example: 15",
                            text: $appliedPressureInput
                        )

                        EngineeringInputField(
                            title: "Osmotic Pressure Difference",
                            symbol: "Δπ",
                            unit: "bar",
                            placeholder: "Example: 5",
                            text: $osmoticPressureInput
                        )

                        Divider()

                        Text("Solute Transport")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Solute Permeability",
                            symbol: "B",
                            unit: "m/h",
                            placeholder: "Example: 0.001",
                            text: $solutePermeabilityInput
                        )

                        EngineeringInputField(
                            title: "Feed Solute Concentration",
                            symbol: "Cf",
                            unit: "kg/m³",
                            placeholder: "Example: 2",
                            text: $feedConcentrationInput
                        )

                        MassTransferActionButtons(
                            loadExample: loadExample,
                            clear: resetInputs
                        )

                        PrimaryActionButton(
                            title: "Calculate RO Performance",
                            systemImage: "drop.triangle.fill",
                            action: calculate
                        )

                        if let result {
                            resultSection(result)
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Reverse Osmosis")
    }

    private func resultSection(
        _ result: ReverseOsmosisPerformanceResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label: "Net Driving Pressure",
                        value: numberFormatter.format(
                            result.netDrivingPressureBar
                        ),
                        unit: "bar"
                    ),
                    .init(
                        label: "Water Flux",
                        value: numberFormatter.format(
                            result.waterFluxLMH
                        ),
                        unit: "LMH"
                    ),
                    .init(
                        label: "Permeate Flow",
                        value: numberFormatter.format(
                            result.permeateFlowRate
                        ),
                        unit: "m³/h"
                    ),
                    .init(
                        label: "Concentrate Flow",
                        value: numberFormatter.format(
                            result.concentrateFlowRate
                        ),
                        unit: "m³/h"
                    ),
                    .init(
                        label: "Water Recovery",
                        value: numberFormatter.format(
                            100 * result.waterRecoveryFraction
                        ),
                        unit: "%"
                    ),
                    .init(
                        label: "Permeate Concentration",
                        value: numberFormatter.format(
                            result.permeateSoluteConcentration
                        ),
                        unit: "kg/m³"
                    ),
                    .init(
                        label: "Concentrate Concentration",
                        value: numberFormatter.format(
                            result.concentrateSoluteConcentration
                        ),
                        unit: "kg/m³"
                    ),
                    .init(
                        label: "Observed Rejection",
                        value: numberFormatter.format(
                            100 * result.observedSoluteRejection
                        ),
                        unit: "%"
                    ),
                    .init(
                        label: "Concentration Factor",
                        value: numberFormatter.format(
                            result.concentrationFactor
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "Solute Balance Residual",
                        value: numberFormatter.format(
                            result.soluteBalanceResidual
                        ),
                        unit: "kg/h"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Text(result.modelName)
                        .font(.headline)

                    Divider()

                    Text(result.limitationDescription)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> ReverseOsmosisPerformanceInput {

        .init(
            feedVolumetricFlowRate:
                try InputValidator.parseNumber(
                    feedFlowInput,
                    fieldName: "feed flow"
                ),
            membraneArea:
                try InputValidator.parseNumber(
                    membraneAreaInput,
                    fieldName: "membrane area"
                ),
            waterPermeabilityLMHPerBar:
                try InputValidator.parseNumber(
                    waterPermeabilityInput,
                    fieldName: "water permeability"
                ),
            appliedPressureDifferenceBar:
                try InputValidator.parseNumber(
                    appliedPressureInput,
                    fieldName: "applied pressure difference"
                ),
            osmoticPressureDifferenceBar:
                try InputValidator.parseNumber(
                    osmoticPressureInput,
                    fieldName: "osmotic pressure difference"
                ),
            solutePermeabilityMetersPerHour:
                try InputValidator.parseNumber(
                    solutePermeabilityInput,
                    fieldName: "solute permeability"
                ),
            feedSoluteConcentration:
                try InputValidator.parseNumber(
                    feedConcentrationInput,
                    fieldName: "feed solute concentration"
                )
        )
    }

    private func loadExample() {
        feedFlowInput = "10"
        membraneAreaInput = "100"
        waterPermeabilityInput = "1.5"
        appliedPressureInput = "15"
        osmoticPressureInput = "5"
        solutePermeabilityInput = "0.001"
        feedConcentrationInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedFlowInput = ""
        membraneAreaInput = ""
        waterPermeabilityInput = ""
        appliedPressureInput = ""
        osmoticPressureInput = ""
        solutePermeabilityInput = ""
        feedConcentrationInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReverseOsmosisPerformanceView()
    }
}
