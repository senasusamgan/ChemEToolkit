import SwiftUI

struct SteadyFlowEnergyEquationView: View {
    @State private var massFlowInput = "2"
    @State private var workInput = "100"
    @State private var inletEnthalpyInput = "300"
    @State private var outletEnthalpyInput = "250"
    @State private var inletVelocityInput = "20"
    @State private var outletVelocityInput = "80"
    @State private var inletElevationInput = "0"
    @State private var outletElevationInput = "10"
    @State private var result: SteadyFlowEnergyEquationResult?
    @State private var errorMessage = ""

    private let engine = SteadyFlowEnergyEquationEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.right.circle.fill",
                    title: "Steady-Flow Energy Equation",
                    subtitle: "Solve heat transfer including enthalpy, velocity and elevation",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Positive shaft work is work produced by the control volume.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Mass Flow Rate",
                            symbol: "ṁ",
                            unit: "kg/s",
                            placeholder: "2",
                            text: $massFlowInput
                        )

                        EngineeringInputField(
                            title: "Shaft Work by Control Volume",
                            symbol: "Ẇ",
                            unit: "kW",
                            placeholder: "100",
                            text: $workInput
                        )

                        EngineeringInputField(
                            title: "Inlet Enthalpy",
                            symbol: "h₁",
                            unit: "kJ/kg",
                            placeholder: "300",
                            text: $inletEnthalpyInput
                        )

                        EngineeringInputField(
                            title: "Outlet Enthalpy",
                            symbol: "h₂",
                            unit: "kJ/kg",
                            placeholder: "250",
                            text: $outletEnthalpyInput
                        )

                        EngineeringInputField(
                            title: "Inlet Velocity",
                            symbol: "V₁",
                            unit: "m/s",
                            placeholder: "20",
                            text: $inletVelocityInput
                        )

                        EngineeringInputField(
                            title: "Outlet Velocity",
                            symbol: "V₂",
                            unit: "m/s",
                            placeholder: "80",
                            text: $outletVelocityInput
                        )

                        EngineeringInputField(
                            title: "Inlet Elevation",
                            symbol: "z₁",
                            unit: "m",
                            placeholder: "0",
                            text: $inletElevationInput
                        )

                        EngineeringInputField(
                            title: "Outlet Elevation",
                            symbol: "z₂",
                            unit: "m",
                            placeholder: "10",
                            text: $outletElevationInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "arrow.right.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Specific Enthalpy Change",
                                        value: numberFormatter.format(result.specificEnthalpyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Specific Kinetic-Energy Change",
                                        value: numberFormatter.format(result.specificKineticEnergyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Specific Potential-Energy Change",
                                        value: numberFormatter.format(result.specificPotentialEnergyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Total Specific Energy Change",
                                        value: numberFormatter.format(result.totalSpecificEnergyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Required Heat-Transfer Rate",
                                        value: numberFormatter.format(result.requiredHeatTransferRate),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Direction",
                                        value: result.directionDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Steady-Flow Energy Equation")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    massFlowRate:
                        try InputValidator.parseNumber(
                            massFlowInput,
                            fieldName: "mass flow rate"
                        ),
                    shaftWorkRateByControlVolume:
                        try InputValidator.parseNumber(
                            workInput,
                            fieldName: "shaft work by control volume"
                        ),
                    inletEnthalpy:
                        try InputValidator.parseNumber(
                            inletEnthalpyInput,
                            fieldName: "inlet enthalpy"
                        ),
                    outletEnthalpy:
                        try InputValidator.parseNumber(
                            outletEnthalpyInput,
                            fieldName: "outlet enthalpy"
                        ),
                    inletVelocity:
                        try InputValidator.parseNumber(
                            inletVelocityInput,
                            fieldName: "inlet velocity"
                        ),
                    outletVelocity:
                        try InputValidator.parseNumber(
                            outletVelocityInput,
                            fieldName: "outlet velocity"
                        ),
                    inletElevation:
                        try InputValidator.parseNumber(
                            inletElevationInput,
                            fieldName: "inlet elevation"
                        ),
                    outletElevation:
                        try InputValidator.parseNumber(
                            outletElevationInput,
                            fieldName: "outlet elevation"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        massFlowInput = "2"
        workInput = "100"
        inletEnthalpyInput = "300"
        outletEnthalpyInput = "250"
        inletVelocityInput = "20"
        outletVelocityInput = "80"
        inletElevationInput = "0"
        outletElevationInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massFlowInput = ""
        workInput = ""
        inletEnthalpyInput = ""
        outletEnthalpyInput = ""
        inletVelocityInput = ""
        outletVelocityInput = ""
        inletElevationInput = ""
        outletElevationInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { SteadyFlowEnergyEquationView() } }
