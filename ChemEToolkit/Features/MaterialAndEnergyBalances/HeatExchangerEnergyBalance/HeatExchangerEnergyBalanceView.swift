import SwiftUI

struct HeatExchangerEnergyBalanceView:
    View {

    @State private var hotFlowInput = "2"
    @State private var hotCpInput = "4"
    @State private var hotInInput = "150"
    @State private var hotOutInput = "90"
    @State private var coldFlowInput = "3"
    @State private var coldCpInput = "4"
    @State private var coldInInput = "20"

    @State private var result:
        HeatExchangerEnergyBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        HeatExchangerEnergyBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.left.arrow.right.square.fill",
                    title: "Heat Exchanger Energy Balance",
                    subtitle: "Solve cold outlet temperature from hot-side duty",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The hot-side temperature drop defines duty; the cold-side outlet follows from energy conservation.")
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
                            title: "Hot Mass Flow",
                            symbol: "ṁ_h",
                            unit: "kg/s",
                            placeholder: "2",
                            text: $hotFlowInput
                        )

                        EngineeringInputField(
                            title: "Hot Heat Capacity",
                            symbol: "Cp_h",
                            unit: "kJ/(kg·K)",
                            placeholder: "4",
                            text: $hotCpInput
                        )

                        EngineeringInputField(
                            title: "Hot Inlet Temperature",
                            symbol: "T_h,in",
                            unit: "°C or K",
                            placeholder: "150",
                            text: $hotInInput
                        )

                        EngineeringInputField(
                            title: "Hot Outlet Temperature",
                            symbol: "T_h,out",
                            unit: "same scale",
                            placeholder: "90",
                            text: $hotOutInput
                        )

                        EngineeringInputField(
                            title: "Cold Mass Flow",
                            symbol: "ṁ_c",
                            unit: "kg/s",
                            placeholder: "3",
                            text: $coldFlowInput
                        )

                        EngineeringInputField(
                            title: "Cold Heat Capacity",
                            symbol: "Cp_c",
                            unit: "kJ/(kg·K)",
                            placeholder: "4",
                            text: $coldCpInput
                        )

                        EngineeringInputField(
                            title: "Cold Inlet Temperature",
                            symbol: "T_c,in",
                            unit: "same scale",
                            placeholder: "20",
                            text: $coldInInput
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
                            systemImage: "arrow.left.arrow.right.square.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Heat Duty",
                                        value: numberFormatter.format(result.heatDuty),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Cold Outlet Temperature",
                                        value: numberFormatter.format(result.coldOutletTemperature),
                                        unit: "input temperature scale"
                                    ),
.init(
                                        label: "Hot Capacity Rate",
                                        value: numberFormatter.format(result.hotCapacityRate),
                                        unit: "kW/K"
                                    ),
.init(
                                        label: "Cold Capacity Rate",
                                        value: numberFormatter.format(result.coldCapacityRate),
                                        unit: "kW/K"
                                    ),
.init(
                                        label: "Maximum Possible Duty",
                                        value: numberFormatter.format(result.maximumPossibleDuty),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Effectiveness",
                                        value: numberFormatter.format(result.effectiveness),
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
        .navigationTitle("Heat Exchanger Energy Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    hotMassFlow:
                        try InputValidator.parseNumber(
                            hotFlowInput,
                            fieldName:
                                "hot mass flow"
                        ),
                    hotHeatCapacity:
                        try InputValidator.parseNumber(
                            hotCpInput,
                            fieldName:
                                "hot heat capacity"
                        ),
                    hotInletTemperature:
                        try InputValidator.parseNumber(
                            hotInInput,
                            fieldName:
                                "hot inlet temperature"
                        ),
                    hotOutletTemperature:
                        try InputValidator.parseNumber(
                            hotOutInput,
                            fieldName:
                                "hot outlet temperature"
                        ),
                    coldMassFlow:
                        try InputValidator.parseNumber(
                            coldFlowInput,
                            fieldName:
                                "cold mass flow"
                        ),
                    coldHeatCapacity:
                        try InputValidator.parseNumber(
                            coldCpInput,
                            fieldName:
                                "cold heat capacity"
                        ),
                    coldInletTemperature:
                        try InputValidator.parseNumber(
                            coldInInput,
                            fieldName:
                                "cold inlet temperature"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        hotFlowInput = "2"
        hotCpInput = "4"
        hotInInput = "150"
        hotOutInput = "90"
        coldFlowInput = "3"
        coldCpInput = "4"
        coldInInput = "20"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        hotFlowInput = ""
        hotCpInput = ""
        hotInInput = ""
        hotOutInput = ""
        coldFlowInput = ""
        coldCpInput = ""
        coldInInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        HeatExchangerEnergyBalanceView()
    }
}
