import SwiftUI

struct UltrafiltrationResistanceSeriesView: View {

    @State private var pressureInput = "200"

    @State private var viscosityInput = "1"

    @State private var membraneResistanceInput = "100"

    @State private var foulingResistanceInput = "50"

    @State private var flowInput = "100"

    @State private var result: UltrafiltrationResistanceSeriesResult?
    @State private var errorMessage = ""

    private let engine = UltrafiltrationResistanceSeriesEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "line.3.horizontal.decrease.circle.fill",
                    title: "Ultrafiltration Resistance Series",
                    subtitle: "Calculate clean and fouled membrane flux",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Use consistent pressure, viscosity, resistance and flux units.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Transmembrane Pressure",
                        symbol: "TMP",
                        unit: "pressure",
                        placeholder: "200",
                        text: $pressureInput
                    )

                    EngineeringInputField(
                        title: "Fluid Viscosity",
                        symbol: "mu",
                        unit: "viscosity",
                        placeholder: "1",
                        text: $viscosityInput
                    )

                    EngineeringInputField(
                        title: "Membrane Resistance",
                        symbol: "Rm",
                        unit: "resistance",
                        placeholder: "100",
                        text: $membraneResistanceInput
                    )

                    EngineeringInputField(
                        title: "Fouling Resistance",
                        symbol: "Rf",
                        unit: "resistance",
                        placeholder: "50",
                        text: $foulingResistanceInput
                    )

                    EngineeringInputField(
                        title: "Target Permeate Flow",
                        symbol: "Qp",
                        unit: "flow units",
                        placeholder: "100",
                        text: $flowInput
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
                            systemImage: "line.3.horizontal.decrease.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                label: "Fouled Membrane Flux",
                                value: numberFormatter.format(result.fouledMembraneFlux),
                                unit: "flux units"
                            ),
.init(
                                label: "Clean Membrane Flux",
                                value: numberFormatter.format(result.cleanMembraneFlux),
                                unit: "flux units"
                            ),
.init(
                                label: "Flux Decline",
                                value: numberFormatter.format(100 * result.fluxDeclineFraction),
                                unit: "%"
                            ),
.init(
                                label: "Total Resistance",
                                value: numberFormatter.format(result.totalResistance),
                                unit: "resistance"
                            ),
.init(
                                label: "Required Membrane Area",
                                value: numberFormatter.format(result.requiredMembraneArea),
                                unit: "area units"
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
        .navigationTitle("Ultrafiltration Resistance Series")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                        transmembranePressure:
                            try InputValidator.parseNumber(
                                pressureInput,
                                fieldName: "transmembrane pressure"
                            ),
                        fluidViscosity:
                            try InputValidator.parseNumber(
                                viscosityInput,
                                fieldName: "fluid viscosity"
                            ),
                        membraneResistance:
                            try InputValidator.parseNumber(
                                membraneResistanceInput,
                                fieldName: "membrane resistance"
                            ),
                        foulingResistance:
                            try InputValidator.parseNumber(
                                foulingResistanceInput,
                                fieldName: "fouling resistance"
                            ),
                        targetPermeateFlow:
                            try InputValidator.parseNumber(
                                flowInput,
                                fieldName: "target permeate flow"
                            )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetInputs() {
        pressureInput = ""
        viscosityInput = ""
        membraneResistanceInput = ""
        foulingResistanceInput = ""
        flowInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { UltrafiltrationResistanceSeriesView() }
}
