import SwiftUI

struct NozzleDiffuserEnergyBalanceView: View {
    @State private var inletInput = "300"
    @State private var outletInput = "250"
    @State private var velocityInput = "50"
    @State private var heatInput = "0"
    @State private var workInput = "0"
    @State private var result: NozzleDiffuserEnergyBalanceResult?
    @State private var errorMessage = ""

    private let engine = NozzleDiffuserEnergyBalanceEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind.circle.fill",
                    title: "Nozzle–Diffuser Energy Balance",
                    subtitle: "Calculate outlet velocity from enthalpy change",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The model neglects elevation change and supports optional heat and shaft-work terms.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Inlet Enthalpy",
                            symbol: "h₁",
                            unit: "kJ/kg",
                            placeholder: "300",
                            text: $inletInput
                        )

                        EngineeringInputField(
                            title: "Outlet Enthalpy",
                            symbol: "h₂",
                            unit: "kJ/kg",
                            placeholder: "250",
                            text: $outletInput
                        )

                        EngineeringInputField(
                            title: "Inlet Velocity",
                            symbol: "V₁",
                            unit: "m/s",
                            placeholder: "50",
                            text: $velocityInput
                        )

                        EngineeringInputField(
                            title: "Heat Transfer per Mass",
                            symbol: "q",
                            unit: "kJ/kg",
                            placeholder: "0",
                            text: $heatInput
                        )

                        EngineeringInputField(
                            title: "Work by Device per Mass",
                            symbol: "w",
                            unit: "kJ/kg",
                            placeholder: "0",
                            text: $workInput
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
                            systemImage: "wind.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Outlet Velocity",
                                        value: numberFormatter.format(result.outletVelocity),
                                        unit: "m/s"
                                    ),
.init(
                                        label: "Velocity Change",
                                        value: numberFormatter.format(result.velocityChange),
                                        unit: "m/s"
                                    ),
.init(
                                        label: "Specific Kinetic-Energy Change",
                                        value: numberFormatter.format(result.specificKineticEnergyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Enthalpy Change",
                                        value: numberFormatter.format(result.enthalpyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Behavior",
                                        value: result.deviceDescription,
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
        .navigationTitle("Nozzle–Diffuser Energy Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    inletEnthalpy:
                        try InputValidator.parseNumber(
                            inletInput,
                            fieldName: "inlet enthalpy"
                        ),
                    outletEnthalpy:
                        try InputValidator.parseNumber(
                            outletInput,
                            fieldName: "outlet enthalpy"
                        ),
                    inletVelocity:
                        try InputValidator.parseNumber(
                            velocityInput,
                            fieldName: "inlet velocity"
                        ),
                    heatTransferPerUnitMass:
                        try InputValidator.parseNumber(
                            heatInput,
                            fieldName: "heat transfer per mass"
                        ),
                    workByControlVolumePerUnitMass:
                        try InputValidator.parseNumber(
                            workInput,
                            fieldName: "work by device per mass"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        inletInput = "300"
        outletInput = "250"
        velocityInput = "50"
        heatInput = "0"
        workInput = "0"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        inletInput = ""
        outletInput = ""
        velocityInput = ""
        heatInput = ""
        workInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { NozzleDiffuserEnergyBalanceView() } }
