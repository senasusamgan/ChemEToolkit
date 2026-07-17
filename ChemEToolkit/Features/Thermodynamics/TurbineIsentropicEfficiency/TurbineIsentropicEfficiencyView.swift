import SwiftUI

struct TurbineIsentropicEfficiencyView: View {
    @State private var massFlowInput = "5"
    @State private var inletInput = "3200"
    @State private var isentropicInput = "2400"
    @State private var actualInput = "2520"
    @State private var result: TurbineIsentropicEfficiencyResult?
    @State private var errorMessage = ""

    private let engine = TurbineIsentropicEfficiencyEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "fanblades.fill",
                    title: "Turbine Isentropic Efficiency",
                    subtitle: "Calculate turbine efficiency and power output",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Actual outlet enthalpy must be between the isentropic outlet and inlet values.")
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
                            placeholder: "5",
                            text: $massFlowInput
                        )

                        EngineeringInputField(
                            title: "Inlet Enthalpy",
                            symbol: "h₁",
                            unit: "kJ/kg",
                            placeholder: "3200",
                            text: $inletInput
                        )

                        EngineeringInputField(
                            title: "Isentropic Outlet Enthalpy",
                            symbol: "h₂s",
                            unit: "kJ/kg",
                            placeholder: "2400",
                            text: $isentropicInput
                        )

                        EngineeringInputField(
                            title: "Actual Outlet Enthalpy",
                            symbol: "h₂a",
                            unit: "kJ/kg",
                            placeholder: "2520",
                            text: $actualInput
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
                            systemImage: "fanblades.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Isentropic Efficiency",
                                        value: numberFormatter.format(result.isentropicEfficiency),
                                        unit: "—"
                                    ),
.init(
                                        label: "Ideal Specific Work",
                                        value: numberFormatter.format(result.idealSpecificWork),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Actual Specific Work",
                                        value: numberFormatter.format(result.actualSpecificWork),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Ideal Power",
                                        value: numberFormatter.format(result.idealPower),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Actual Power",
                                        value: numberFormatter.format(result.actualPower),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Lost Power Potential",
                                        value: numberFormatter.format(result.lostPowerPotential),
                                        unit: "kW"
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
        .navigationTitle("Turbine Isentropic Efficiency")
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
                    inletEnthalpy:
                        try InputValidator.parseNumber(
                            inletInput,
                            fieldName: "inlet enthalpy"
                        ),
                    isentropicOutletEnthalpy:
                        try InputValidator.parseNumber(
                            isentropicInput,
                            fieldName: "isentropic outlet enthalpy"
                        ),
                    actualOutletEnthalpy:
                        try InputValidator.parseNumber(
                            actualInput,
                            fieldName: "actual outlet enthalpy"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        massFlowInput = "5"
        inletInput = "3200"
        isentropicInput = "2400"
        actualInput = "2520"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massFlowInput = ""
        inletInput = ""
        isentropicInput = ""
        actualInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { TurbineIsentropicEfficiencyView() } }
