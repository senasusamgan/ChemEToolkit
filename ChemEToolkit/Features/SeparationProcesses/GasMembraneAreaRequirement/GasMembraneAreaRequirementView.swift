import SwiftUI

struct GasMembraneAreaRequirementView: View {

    @State private var flowInput = "50"

    @State private var permeanceInput = "2"

    @State private var feedPressureInput = "5"

    @State private var permeatePressureInput = "1"

    @State private var utilizationInput = "0.80"

    @State private var result: GasMembraneAreaRequirementResult?
    @State private var errorMessage = ""

    private let engine = GasMembraneAreaRequirementEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.resize.up",
                    title: "Gas-Membrane Area Requirement",
                    subtitle: "Size area from permeance and pressure difference",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Use consistent permeance, pressure and component-flow units.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Permeate Component Flow",
                        symbol: "np",
                        unit: "flow units",
                        placeholder: "50",
                        text: $flowInput
                    )

                    EngineeringInputField(
                        title: "Component Permeance",
                        symbol: "Pi",
                        unit: "flow/area·pressure",
                        placeholder: "2",
                        text: $permeanceInput
                    )

                    EngineeringInputField(
                        title: "Feed Partial Pressure",
                        symbol: "pf",
                        unit: "pressure",
                        placeholder: "5",
                        text: $feedPressureInput
                    )

                    EngineeringInputField(
                        title: "Permeate Partial Pressure",
                        symbol: "pp",
                        unit: "pressure",
                        placeholder: "1",
                        text: $permeatePressureInput
                    )

                    EngineeringInputField(
                        title: "Module Utilization",
                        symbol: "U",
                        unit: "—",
                        placeholder: "0.80",
                        text: $utilizationInput
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
                            systemImage: "square.resize.up",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                label: "Required Membrane Area",
                                value: numberFormatter.format(result.requiredMembraneArea),
                                unit: "area units"
                            ),
.init(
                                label: "Driving Pressure",
                                value: numberFormatter.format(result.effectiveDrivingPressure),
                                unit: "pressure"
                            ),
.init(
                                label: "Ideal Component Flux",
                                value: numberFormatter.format(result.idealComponentFlux),
                                unit: "flow/area"
                            ),
.init(
                                label: "Utilized Component Flux",
                                value: numberFormatter.format(result.utilizedComponentFlux),
                                unit: "flow/area"
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
        .navigationTitle("Gas-Membrane Area Requirement")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                        permeateComponentFlow:
                            try InputValidator.parseNumber(
                                flowInput,
                                fieldName: "permeate component flow"
                            ),
                        componentPermeance:
                            try InputValidator.parseNumber(
                                permeanceInput,
                                fieldName: "component permeance"
                            ),
                        feedSidePartialPressure:
                            try InputValidator.parseNumber(
                                feedPressureInput,
                                fieldName: "feed partial pressure"
                            ),
                        permeateSidePartialPressure:
                            try InputValidator.parseNumber(
                                permeatePressureInput,
                                fieldName: "permeate partial pressure"
                            ),
                        moduleUtilizationFraction:
                            try InputValidator.parseNumber(
                                utilizationInput,
                                fieldName: "module utilization"
                            )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetInputs() {
        flowInput = ""
        permeanceInput = ""
        feedPressureInput = ""
        permeatePressureInput = ""
        utilizationInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { GasMembraneAreaRequirementView() }
}
