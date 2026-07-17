import SwiftUI

struct CompressorIsentropicEfficiencyView: View {
    @State private var massFlowInput = "3"
    @State private var inletInput = "300"
    @State private var isentropicInput = "450"
    @State private var actualInput = "500"
    @State private var result: CompressorIsentropicEfficiencyResult?
    @State private var errorMessage = ""

    private let engine = CompressorIsentropicEfficiencyEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.forward.circle.fill",
                    title: "Compressor Isentropic Efficiency",
                    subtitle: "Calculate compressor efficiency and power input",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Actual outlet enthalpy must not be lower than the isentropic outlet value.")
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
                            placeholder: "3",
                            text: $massFlowInput
                        )

                        EngineeringInputField(
                            title: "Inlet Enthalpy",
                            symbol: "h₁",
                            unit: "kJ/kg",
                            placeholder: "300",
                            text: $inletInput
                        )

                        EngineeringInputField(
                            title: "Isentropic Outlet Enthalpy",
                            symbol: "h₂s",
                            unit: "kJ/kg",
                            placeholder: "450",
                            text: $isentropicInput
                        )

                        EngineeringInputField(
                            title: "Actual Outlet Enthalpy",
                            symbol: "h₂a",
                            unit: "kJ/kg",
                            placeholder: "500",
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
                            systemImage: "arrow.up.forward.circle.fill",
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
                                        label: "Ideal Specific Work Input",
                                        value: numberFormatter.format(result.idealSpecificWorkInput),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Actual Specific Work Input",
                                        value: numberFormatter.format(result.actualSpecificWorkInput),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Ideal Power Input",
                                        value: numberFormatter.format(result.idealPowerInput),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Actual Power Input",
                                        value: numberFormatter.format(result.actualPowerInput),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Excess Power Input",
                                        value: numberFormatter.format(result.excessPowerInput),
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
        .navigationTitle("Compressor Isentropic Efficiency")
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
        massFlowInput = "3"
        inletInput = "300"
        isentropicInput = "450"
        actualInput = "500"
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

#Preview { NavigationStack { CompressorIsentropicEfficiencyView() } }
