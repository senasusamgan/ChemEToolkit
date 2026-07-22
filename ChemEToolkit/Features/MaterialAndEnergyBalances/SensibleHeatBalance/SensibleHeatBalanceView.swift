import SwiftUI

struct SensibleHeatBalanceView:
    View {

    @State private var flowInput = "2"
    @State private var cpInput = "4.18"
    @State private var inletInput = "20"
    @State private var outletInput = "80"

    @State private var result:
        SensibleHeatBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        SensibleHeatBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "thermometer.medium",
                    title: "Sensible Heat Balance",
                    subtitle: "Calculate heating or cooling duty from Cp and ΔT",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Temperature differences are identical in kelvin and degrees Celsius.")
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
                            title: "Mass Flow Rate",
                            symbol: "ṁ",
                            unit: "kg/s",
                            placeholder: "2",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Specific Heat Capacity",
                            symbol: "Cp",
                            unit: "kJ/(kg·K)",
                            placeholder: "4.18",
                            text: $cpInput
                        )

                        EngineeringInputField(
                            title: "Inlet Temperature",
                            symbol: "T_in",
                            unit: "°C or K",
                            placeholder: "20",
                            text: $inletInput
                        )

                        EngineeringInputField(
                            title: "Outlet Temperature",
                            symbol: "T_out",
                            unit: "same scale",
                            placeholder: "80",
                            text: $outletInput
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
                            systemImage: "thermometer.medium",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Temperature Change",
                                        value: numberFormatter.format(result.temperatureChange),
                                        unit: "K"
                                    ),
.init(
                                        label: "Signed Heat Duty",
                                        value: numberFormatter.format(result.signedHeatDuty),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Absolute Heat Duty",
                                        value: numberFormatter.format(result.absoluteHeatDuty),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Specific Duty",
                                        value: numberFormatter.format(result.heatDutyPerUnitMass),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Process Direction",
                                        value: result.processDirection,
                                        unit: "—"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Sensible Heat Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    massFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "mass flow rate"
                        ),
                    specificHeatCapacity:
                        try InputValidator.parseNumber(
                            cpInput,
                            fieldName:
                                "specific heat capacity"
                        ),
                    inletTemperature:
                        try InputValidator.parseNumber(
                            inletInput,
                            fieldName:
                                "inlet temperature"
                        ),
                    outletTemperature:
                        try InputValidator.parseNumber(
                            outletInput,
                            fieldName:
                                "outlet temperature"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "2"
        cpInput = "4.18"
        inletInput = "20"
        outletInput = "80"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        cpInput = ""
        inletInput = ""
        outletInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SensibleHeatBalanceView()
    }
}
