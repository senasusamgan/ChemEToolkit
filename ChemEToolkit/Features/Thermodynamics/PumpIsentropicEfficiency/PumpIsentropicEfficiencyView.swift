import SwiftUI

struct PumpIsentropicEfficiencyView: View {
    @State private var massFlowInput = "10"
    @State private var inletPressureInput = "100"
    @State private var outletPressureInput = "1000"
    @State private var specificVolumeInput = "0.001"
    @State private var efficiencyInput = "0.80"
    @State private var result: PumpIsentropicEfficiencyResult?
    @State private var errorMessage = ""

    private let engine = PumpIsentropicEfficiencyEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.triangle.fill",
                    title: "Pump Isentropic Efficiency",
                    subtitle: "Calculate incompressible pump work and power",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Specific volume is treated as constant through the pump.")
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
                            placeholder: "10",
                            text: $massFlowInput
                        )

                        EngineeringInputField(
                            title: "Inlet Absolute Pressure",
                            symbol: "P₁",
                            unit: "kPa abs",
                            placeholder: "100",
                            text: $inletPressureInput
                        )

                        EngineeringInputField(
                            title: "Outlet Absolute Pressure",
                            symbol: "P₂",
                            unit: "kPa abs",
                            placeholder: "1000",
                            text: $outletPressureInput
                        )

                        EngineeringInputField(
                            title: "Specific Volume",
                            symbol: "v",
                            unit: "m³/kg",
                            placeholder: "0.001",
                            text: $specificVolumeInput
                        )

                        EngineeringInputField(
                            title: "Isentropic Efficiency",
                            symbol: "ηp",
                            unit: "—",
                            placeholder: "0.80",
                            text: $efficiencyInput
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
                            systemImage: "drop.triangle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Pressure Rise",
                                        value: numberFormatter.format(result.pressureRise),
                                        unit: "kPa"
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
                                        label: "Inefficiency Penalty",
                                        value: numberFormatter.format(result.inefficiencyPenalty),
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
        .navigationTitle("Pump Isentropic Efficiency")
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
                    inletAbsolutePressure:
                        try InputValidator.parseNumber(
                            inletPressureInput,
                            fieldName: "inlet absolute pressure"
                        ),
                    outletAbsolutePressure:
                        try InputValidator.parseNumber(
                            outletPressureInput,
                            fieldName: "outlet absolute pressure"
                        ),
                    specificVolume:
                        try InputValidator.parseNumber(
                            specificVolumeInput,
                            fieldName: "specific volume"
                        ),
                    isentropicEfficiency:
                        try InputValidator.parseNumber(
                            efficiencyInput,
                            fieldName: "isentropic efficiency"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        massFlowInput = "10"
        inletPressureInput = "100"
        outletPressureInput = "1000"
        specificVolumeInput = "0.001"
        efficiencyInput = "0.80"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massFlowInput = ""
        inletPressureInput = ""
        outletPressureInput = ""
        specificVolumeInput = ""
        efficiencyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { PumpIsentropicEfficiencyView() } }
