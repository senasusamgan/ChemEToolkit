import SwiftUI

struct LifecycleCostAnalysisView:
    View {

    @State private var capitalInput = "2000000"
    @State private var operatingInput = "300000"
    @State private var maintenanceInput = "50000"
    @State private var replacementInput = "400000"
    @State private var intervalInput = "5"
    @State private var salvageInput = "200000"
    @State private var lifeInput = "15"
    @State private var discountInput = "0.08"

    @State private var result:
        LifecycleCostAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        LifecycleCostAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "calendar.badge.clock",
                    title: "Lifecycle Cost Analysis",
                    subtitle: "Discount capital, operating, maintenance and replacement costs",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("The model includes periodic replacements before project end and credits a terminal salvage value.")
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
                            title: "Initial Capital Cost",
                            symbol: "CAPEX",
                            unit: "currency",
                            placeholder: "2000000",
                            text: $capitalInput
                        )

                        EngineeringInputField(
                            title: "Annual Operating Cost",
                            symbol: "OPEX",
                            unit: "currency/year",
                            placeholder: "300000",
                            text: $operatingInput
                        )

                        EngineeringInputField(
                            title: "Annual Maintenance Cost",
                            symbol: "M",
                            unit: "currency/year",
                            placeholder: "50000",
                            text: $maintenanceInput
                        )

                        EngineeringInputField(
                            title: "Periodic Replacement Cost",
                            symbol: "C_rep",
                            unit: "currency",
                            placeholder: "400000",
                            text: $replacementInput
                        )

                        EngineeringInputField(
                            title: "Replacement Interval",
                            symbol: "n_rep",
                            unit: "years",
                            placeholder: "5",
                            text: $intervalInput
                        )

                        EngineeringInputField(
                            title: "Terminal Salvage Value",
                            symbol: "S",
                            unit: "currency",
                            placeholder: "200000",
                            text: $salvageInput
                        )

                        EngineeringInputField(
                            title: "Project Life",
                            symbol: "n",
                            unit: "years",
                            placeholder: "15",
                            text: $lifeInput
                        )

                        EngineeringInputField(
                            title: "Discount Rate",
                            symbol: "i",
                            unit: "fraction/year",
                            placeholder: "0.08",
                            text: $discountInput
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
                            systemImage: "calendar.badge.clock",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "PV of Operating Cost",
                                        value: numberFormatter.format(result.presentValueOfOperatingCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "PV of Maintenance Cost",
                                        value: numberFormatter.format(result.presentValueOfMaintenanceCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "PV of Replacement Cost",
                                        value: numberFormatter.format(result.presentValueOfReplacementCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "PV of Salvage Value",
                                        value: numberFormatter.format(result.presentValueOfSalvageValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Total Lifecycle Cost",
                                        value: numberFormatter.format(result.totalLifecycleCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Equivalent Annual Cost",
                                        value: numberFormatter.format(result.equivalentAnnualCost),
                                        unit: "currency/year"
                                    )
                                ],
                                tint: .green
                            )

                            CalculatorInfoCard(tint: .green) {
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Lifecycle Cost Analysis")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialCapitalCost:
                        try InputValidator.parseNumber(
                            capitalInput,
                            fieldName:
                                "initial capital cost"
                        ),
                    annualOperatingCost:
                        try InputValidator.parseNumber(
                            operatingInput,
                            fieldName:
                                "annual operating cost"
                        ),
                    annualMaintenanceCost:
                        try InputValidator.parseNumber(
                            maintenanceInput,
                            fieldName:
                                "annual maintenance cost"
                        ),
                    periodicReplacementCost:
                        try InputValidator.parseNumber(
                            replacementInput,
                            fieldName:
                                "periodic replacement cost"
                        ),
                    replacementIntervalYears:
                        try InputValidator.parseNumber(
                            intervalInput,
                            fieldName:
                                "replacement interval"
                        ),
                    terminalSalvageValue:
                        try InputValidator.parseNumber(
                            salvageInput,
                            fieldName:
                                "terminal salvage value"
                        ),
                    projectLifeYears:
                        try InputValidator.parseNumber(
                            lifeInput,
                            fieldName:
                                "project life"
                        ),
                    discountRateFraction:
                        try InputValidator.parseNumber(
                            discountInput,
                            fieldName:
                                "discount rate"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        capitalInput = "2000000"
        operatingInput = "300000"
        maintenanceInput = "50000"
        replacementInput = "400000"
        intervalInput = "5"
        salvageInput = "200000"
        lifeInput = "15"
        discountInput = "0.08"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        capitalInput = ""
        operatingInput = ""
        maintenanceInput = ""
        replacementInput = ""
        intervalInput = ""
        salvageInput = ""
        lifeInput = ""
        discountInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LifecycleCostAnalysisView()
    }
}
