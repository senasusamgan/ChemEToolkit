import SwiftUI

struct AnnualOperatingCostEstimateView:
    View {

    @State private var rawMaterialInput = "4000000"
    @State private var utilityInput = "1200000"
    @State private var laborInput = "1000000"
    @State private var maintenanceInput = "600000"
    @State private var wasteInput = "300000"
    @State private var laboratoryInput = "200000"
    @State private var overheadInput = "0.6"
    @State private var insuranceInput = "0.02"
    @State private var fixedCapitalInput = "20000000"
    @State private var productionInput = "50000"

    @State private var result:
        AnnualOperatingCostEstimateResult?

    @State private var errorMessage = ""

    private let engine =
        AnnualOperatingCostEstimateEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "dollarsign.circle.fill",
                    title: "Annual Operating Cost",
                    subtitle: "Combine annual material, utility, labor and plant expenses",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("The estimate separates direct cash costs from plant overhead and fixed-capital-related charges.")
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
                            title: "Raw Materials",
                            symbol: "C_raw",
                            unit: "currency/year",
                            placeholder: "4000000",
                            text: $rawMaterialInput
                        )

                        EngineeringInputField(
                            title: "Utilities",
                            symbol: "C_util",
                            unit: "currency/year",
                            placeholder: "1200000",
                            text: $utilityInput
                        )

                        EngineeringInputField(
                            title: "Operating Labor",
                            symbol: "C_labor",
                            unit: "currency/year",
                            placeholder: "1000000",
                            text: $laborInput
                        )

                        EngineeringInputField(
                            title: "Maintenance",
                            symbol: "C_maint",
                            unit: "currency/year",
                            placeholder: "600000",
                            text: $maintenanceInput
                        )

                        EngineeringInputField(
                            title: "Waste Treatment",
                            symbol: "C_waste",
                            unit: "currency/year",
                            placeholder: "300000",
                            text: $wasteInput
                        )

                        EngineeringInputField(
                            title: "Laboratory and Quality",
                            symbol: "C_lab",
                            unit: "currency/year",
                            placeholder: "200000",
                            text: $laboratoryInput
                        )

                        EngineeringInputField(
                            title: "Plant Overhead Fraction",
                            symbol: "f_OH",
                            unit: "of labor + maintenance",
                            placeholder: "0.6",
                            text: $overheadInput
                        )

                        EngineeringInputField(
                            title: "Insurance and Tax Fraction",
                            symbol: "f_IT",
                            unit: "of fixed capital",
                            placeholder: "0.02",
                            text: $insuranceInput
                        )

                        EngineeringInputField(
                            title: "Fixed Capital Investment",
                            symbol: "FCI",
                            unit: "currency",
                            placeholder: "20000000",
                            text: $fixedCapitalInput
                        )

                        EngineeringInputField(
                            title: "Annual Production",
                            symbol: "P",
                            unit: "product units/year",
                            placeholder: "50000",
                            text: $productionInput
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
                            systemImage: "dollarsign.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Direct Cash Operating Cost",
                                        value: numberFormatter.format(result.directCashOperatingCost),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Plant Overhead",
                                        value: numberFormatter.format(result.plantOverheadCost),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Insurance and Property Tax",
                                        value: numberFormatter.format(result.insuranceAndTaxCost),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Total Annual Operating Cost",
                                        value: numberFormatter.format(result.totalAnnualOperatingCost),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Unit Production Cost",
                                        value: numberFormatter.format(result.unitProductionCost),
                                        unit: "currency/product unit"
                                    ),
.init(
                                        label: "Largest Cost Category",
                                        value: result.largestCostCategory,
                                        unit: "—"
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
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("Annual Operating Cost")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    rawMaterialCost:
                        try InputValidator.parseNumber(
                            rawMaterialInput,
                            fieldName:
                                "raw material cost"
                        ),
                    utilityCost:
                        try InputValidator.parseNumber(
                            utilityInput,
                            fieldName:
                                "utility cost"
                        ),
                    operatingLaborCost:
                        try InputValidator.parseNumber(
                            laborInput,
                            fieldName:
                                "operating labor cost"
                        ),
                    maintenanceCost:
                        try InputValidator.parseNumber(
                            maintenanceInput,
                            fieldName:
                                "maintenance cost"
                        ),
                    wasteTreatmentCost:
                        try InputValidator.parseNumber(
                            wasteInput,
                            fieldName:
                                "waste treatment cost"
                        ),
                    laboratoryAndQualityCost:
                        try InputValidator.parseNumber(
                            laboratoryInput,
                            fieldName:
                                "laboratory and quality cost"
                        ),
                    plantOverheadFractionOfLaborAndMaintenance:
                        try InputValidator.parseNumber(
                            overheadInput,
                            fieldName:
                                "plant overhead fraction"
                        ),
                    insuranceAndTaxFractionOfFixedCapital:
                        try InputValidator.parseNumber(
                            insuranceInput,
                            fieldName:
                                "insurance and tax fraction"
                        ),
                    fixedCapitalInvestment:
                        try InputValidator.parseNumber(
                            fixedCapitalInput,
                            fieldName:
                                "fixed capital investment"
                        ),
                    annualProduction:
                        try InputValidator.parseNumber(
                            productionInput,
                            fieldName:
                                "annual production"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        rawMaterialInput = "4000000"
        utilityInput = "1200000"
        laborInput = "1000000"
        maintenanceInput = "600000"
        wasteInput = "300000"
        laboratoryInput = "200000"
        overheadInput = "0.6"
        insuranceInput = "0.02"
        fixedCapitalInput = "20000000"
        productionInput = "50000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        rawMaterialInput = ""
        utilityInput = ""
        laborInput = ""
        maintenanceInput = ""
        wasteInput = ""
        laboratoryInput = ""
        overheadInput = ""
        insuranceInput = ""
        fixedCapitalInput = ""
        productionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AnnualOperatingCostEstimateView()
    }
}
