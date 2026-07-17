import SwiftUI

struct TotalCapitalInvestmentEstimateView:
    View {

    @State private var equipmentInput = "5000000"
    @State private var installationInput = "1500000"
    @State private var pipingInput = "1000000"
    @State private var instrumentationInput = "600000"
    @State private var electricalInput = "500000"
    @State private var buildingsInput = "800000"
    @State private var utilitiesInput = "900000"
    @State private var engineeringInput = "1400000"
    @State private var contingencyInput = "0.15"
    @State private var workingCapitalInput = "0.15"

    @State private var result:
        TotalCapitalInvestmentEstimateResult?

    @State private var errorMessage = ""

    private let engine =
        TotalCapitalInvestmentEstimateEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "dollarsign.circle.fill",
                    title: "Total Capital Investment",
                    subtitle: "Combine direct, indirect, contingency and working-capital costs",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("This component summary builds fixed capital first, then adds working capital to obtain total capital investment.")
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
                            title: "Purchased Equipment Cost",
                            symbol: "C_PE",
                            unit: "currency",
                            placeholder: "5000000",
                            text: $equipmentInput
                        )

                        EngineeringInputField(
                            title: "Equipment Installation",
                            symbol: "C_inst",
                            unit: "currency",
                            placeholder: "1500000",
                            text: $installationInput
                        )

                        EngineeringInputField(
                            title: "Piping",
                            symbol: "C_pipe",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $pipingInput
                        )

                        EngineeringInputField(
                            title: "Instrumentation",
                            symbol: "C_instr",
                            unit: "currency",
                            placeholder: "600000",
                            text: $instrumentationInput
                        )

                        EngineeringInputField(
                            title: "Electrical",
                            symbol: "C_elec",
                            unit: "currency",
                            placeholder: "500000",
                            text: $electricalInput
                        )

                        EngineeringInputField(
                            title: "Buildings and Yard",
                            symbol: "C_build",
                            unit: "currency",
                            placeholder: "800000",
                            text: $buildingsInput
                        )

                        EngineeringInputField(
                            title: "Utilities and Services",
                            symbol: "C_util",
                            unit: "currency",
                            placeholder: "900000",
                            text: $utilitiesInput
                        )

                        EngineeringInputField(
                            title: "Engineering and Construction",
                            symbol: "C_ind",
                            unit: "currency",
                            placeholder: "1400000",
                            text: $engineeringInput
                        )

                        EngineeringInputField(
                            title: "Contingency Fraction",
                            symbol: "f_cont",
                            unit: "of subtotal",
                            placeholder: "0.15",
                            text: $contingencyInput
                        )

                        EngineeringInputField(
                            title: "Working Capital Fraction",
                            symbol: "f_WC",
                            unit: "of fixed capital",
                            placeholder: "0.15",
                            text: $workingCapitalInput
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
                                        label: "Direct Plant Cost",
                                        value: numberFormatter.format(result.directPlantCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Indirect Plant Cost",
                                        value: numberFormatter.format(result.indirectPlantCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Contingency",
                                        value: numberFormatter.format(result.contingencyCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Fixed Capital Investment",
                                        value: numberFormatter.format(result.fixedCapitalInvestment),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Working Capital",
                                        value: numberFormatter.format(result.workingCapital),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Total Capital Investment",
                                        value: numberFormatter.format(result.totalCapitalInvestment),
                                        unit: "currency"
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
        .navigationTitle("Total Capital Investment")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    purchasedEquipmentCost:
                        try InputValidator.parseNumber(
                            equipmentInput,
                            fieldName:
                                "purchased equipment cost"
                        ),
                    equipmentInstallationCost:
                        try InputValidator.parseNumber(
                            installationInput,
                            fieldName:
                                "equipment installation cost"
                        ),
                    pipingCost:
                        try InputValidator.parseNumber(
                            pipingInput,
                            fieldName:
                                "piping cost"
                        ),
                    instrumentationCost:
                        try InputValidator.parseNumber(
                            instrumentationInput,
                            fieldName:
                                "instrumentation cost"
                        ),
                    electricalCost:
                        try InputValidator.parseNumber(
                            electricalInput,
                            fieldName:
                                "electrical cost"
                        ),
                    buildingsAndYardCost:
                        try InputValidator.parseNumber(
                            buildingsInput,
                            fieldName:
                                "buildings and yard cost"
                        ),
                    utilitiesAndServiceFacilitiesCost:
                        try InputValidator.parseNumber(
                            utilitiesInput,
                            fieldName:
                                "utilities and services cost"
                        ),
                    engineeringAndConstructionCost:
                        try InputValidator.parseNumber(
                            engineeringInput,
                            fieldName:
                                "engineering and construction cost"
                        ),
                    contingencyFractionOfSubtotal:
                        try InputValidator.parseNumber(
                            contingencyInput,
                            fieldName:
                                "contingency fraction"
                        ),
                    workingCapitalFractionOfFixedCapital:
                        try InputValidator.parseNumber(
                            workingCapitalInput,
                            fieldName:
                                "working capital fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        equipmentInput = "5000000"
        installationInput = "1500000"
        pipingInput = "1000000"
        instrumentationInput = "600000"
        electricalInput = "500000"
        buildingsInput = "800000"
        utilitiesInput = "900000"
        engineeringInput = "1400000"
        contingencyInput = "0.15"
        workingCapitalInput = "0.15"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        equipmentInput = ""
        installationInput = ""
        pipingInput = ""
        instrumentationInput = ""
        electricalInput = ""
        buildingsInput = ""
        utilitiesInput = ""
        engineeringInput = ""
        contingencyInput = ""
        workingCapitalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        TotalCapitalInvestmentEstimateView()
    }
}
