import SwiftUI

struct ReverseOsmosisWaterFluxView: View {

    @State private var hydraulicInput = "60"

    @State private var osmoticInput = "25"

    @State private var permeabilityInput = "1.5"

    @State private var permeateFlowInput = "100"

    @State private var recoveryInput = "0.40"

    @State private var result: ReverseOsmosisWaterFluxResult?
    @State private var errorMessage = ""

    private let engine = ReverseOsmosisWaterFluxEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.triangle.fill",
                    title: "Reverse-Osmosis Water Flux",
                    subtitle: "Calculate RO flux, area and concentrate flow",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Pressure, permeability and flux units must be consistent.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Hydraulic Pressure Difference",
                        symbol: "deltaP",
                        unit: "pressure",
                        placeholder: "60",
                        text: $hydraulicInput
                    )

                    EngineeringInputField(
                        title: "Osmotic Pressure Difference",
                        symbol: "deltaPi",
                        unit: "pressure",
                        placeholder: "25",
                        text: $osmoticInput
                    )

                    EngineeringInputField(
                        title: "Water Permeability",
                        symbol: "A",
                        unit: "flux/pressure",
                        placeholder: "1.5",
                        text: $permeabilityInput
                    )

                    EngineeringInputField(
                        title: "Target Permeate Flow",
                        symbol: "Qp",
                        unit: "flow units",
                        placeholder: "100",
                        text: $permeateFlowInput
                    )

                    EngineeringInputField(
                        title: "Recovery Fraction",
                        symbol: "R",
                        unit: "—",
                        placeholder: "0.40",
                        text: $recoveryInput
                    )

                        HStack {
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
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
                                label: "Water Flux",
                                value: numberFormatter.format(result.waterFlux),
                                unit: "flux units"
                            ),
.init(
                                label: "Required Membrane Area",
                                value: numberFormatter.format(result.requiredMembraneArea),
                                unit: "area units"
                            ),
.init(
                                label: "Net Driving Pressure",
                                value: numberFormatter.format(result.netDrivingPressure),
                                unit: "pressure"
                            ),
.init(
                                label: "Required Feed Flow",
                                value: numberFormatter.format(result.requiredFeedFlow),
                                unit: "flow units"
                            ),
.init(
                                label: "Concentrate Flow",
                                value: numberFormatter.format(result.concentrateFlow),
                                unit: "flow units"
                            )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Reverse-Osmosis Water Flux")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                        hydraulicPressureDifference:
                            try InputValidator.parseNumber(
                                hydraulicInput,
                                fieldName: "hydraulic pressure difference"
                            ),
                        osmoticPressureDifference:
                            try InputValidator.parseNumber(
                                osmoticInput,
                                fieldName: "osmotic pressure difference"
                            ),
                        waterPermeability:
                            try InputValidator.parseNumber(
                                permeabilityInput,
                                fieldName: "water permeability"
                            ),
                        targetPermeateFlow:
                            try InputValidator.parseNumber(
                                permeateFlowInput,
                                fieldName: "target permeate flow"
                            ),
                        recoveryFraction:
                            try InputValidator.parseNumber(
                                recoveryInput,
                                fieldName: "recovery fraction"
                            )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetInputs() {
        hydraulicInput = ""
        osmoticInput = ""
        permeabilityInput = ""
        permeateFlowInput = ""
        recoveryInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { ReverseOsmosisWaterFluxView() }
}
