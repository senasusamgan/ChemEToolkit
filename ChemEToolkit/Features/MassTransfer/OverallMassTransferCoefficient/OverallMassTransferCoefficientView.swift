import SwiftUI

struct OverallMassTransferCoefficientView:
    View {

    @State
    private var gasCoefficientInput =
        "0.01"

    @State
    private var liquidCoefficientInput =
        "0.02"

    @State
    private var equilibriumSlopeInput =
        "1.5"

    @State
    private var gasBulkMoleFractionInput =
        "0.3"

    @State
    private var liquidBulkMoleFractionInput =
        "0.05"

    @State
    private var areaInput = "2"

    @State
    private var result:
        OverallMassTransferCoefficientResult?

    @State
    private var errorMessage = ""

    private let engine =
        OverallMassTransferCoefficientEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "rectangle.2.swap",
                    title:
                        "Overall Mass-Transfer Coefficient",
                    subtitle:
                        "Combine gas-film and liquid-film resistances on either phase basis",
                    tint: .blue
                )

                formulaCard

                CalculatorCard {
                    calculatorContent
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
        .navigationTitle(
            "Overall Mass Transfer"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Series Film Resistances"
                )
                .font(.headline)

                Text(
                    "1/KG = 1/kG + m/kL"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )

                Text(
                    "1/KL = 1/(mkG) + 1/kL"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    Individual coefficients must use compatible \
                    mole-fraction driving-force bases. Signed flux \
                    preserves absorption and stripping directions.
                    """
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth:
                AppTheme.Layout
                    .calculatorMaxWidth
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Individual Coefficients")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Gas-Film Coefficient",
                symbol: "kG",
                unit: "mol/(m²·s)",
                placeholder: "Example: 0.01",
                text: $gasCoefficientInput
            )

            EngineeringInputField(
                title:
                    "Liquid-Film Coefficient",
                symbol: "kL",
                unit: "mol/(m²·s)",
                placeholder: "Example: 0.02",
                text: $liquidCoefficientInput
            )

            EngineeringInputField(
                title:
                    "Equilibrium-Line Slope",
                symbol: "m",
                unit: "—",
                placeholder: "Example: 1.5",
                text: $equilibriumSlopeInput
            )

            Divider()

            Text("Bulk Compositions and Area")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Bulk Gas Mole Fraction",
                symbol: "yG",
                unit: "—",
                placeholder: "Example: 0.3",
                text:
                    $gasBulkMoleFractionInput
            )

            EngineeringInputField(
                title:
                    "Bulk Liquid Mole Fraction",
                symbol: "xL",
                unit: "—",
                placeholder:
                    "Example: 0.05",
                text:
                    $liquidBulkMoleFractionInput
            )

            EngineeringInputField(
                title: "Interfacial Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 2",
                text: $areaInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Overall Coefficients",
                systemImage:
                    "rectangle.2.swap",
                action: calculate
            )

            if let result {
                resultSection(result)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func resultSection(
        _ result:
            OverallMassTransferCoefficientResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Overall Gas-Side Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .overallGasCoefficient
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overall Liquid-Side Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .overallLiquidCoefficient
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overall Gas Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .overallGasDrivingForce
                            ),
                        unit: "Δy"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overall Liquid Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .overallLiquidDrivingForce
                            ),
                        unit: "Δx"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Gas-Basis Molar Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .gasBasisMolarFlux
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Liquid-Basis Molar Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .liquidBasisMolarFlux
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label: "Molar Rate",
                        value:
                            numberFormatter.format(
                                result.molarRate
                            ),
                        unit: "mol/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Gas Resistance Share",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .gasResistanceFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Liquid Resistance Share",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .liquidResistanceFraction
                            ),
                        unit: "%"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "Resistance Interpretation",
                        systemImage:
                            "rectangle.2.swap"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .directionDescription
                    )
                    .fontWeight(.semibold)

                    Text(
                        result
                            .controllingResistance
                    )
                    .foregroundStyle(.secondary)

                    Text(result.modelName)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> OverallMassTransferCoefficientInput {

        OverallMassTransferCoefficientInput(
            gasFilmCoefficient:
                try InputValidator.parseNumber(
                    gasCoefficientInput,
                    fieldName:
                        "gas-film coefficient"
                ),
            liquidFilmCoefficient:
                try InputValidator.parseNumber(
                    liquidCoefficientInput,
                    fieldName:
                        "liquid-film coefficient"
                ),
            equilibriumSlope:
                try InputValidator.parseNumber(
                    equilibriumSlopeInput,
                    fieldName:
                        "equilibrium-line slope"
                ),
            gasBulkMoleFraction:
                try InputValidator.parseNumber(
                    gasBulkMoleFractionInput,
                    fieldName:
                        "bulk gas mole fraction"
                ),
            liquidBulkMoleFraction:
                try InputValidator.parseNumber(
                    liquidBulkMoleFractionInput,
                    fieldName:
                        "bulk liquid mole fraction"
                ),
            interfacialArea:
                try InputValidator.parseNumber(
                    areaInput,
                    fieldName:
                        "interfacial area"
                )
        )
    }

    private func loadExample() {
        gasCoefficientInput = "0.01"
        liquidCoefficientInput = "0.02"
        equilibriumSlopeInput = "1.5"
        gasBulkMoleFractionInput = "0.3"
        liquidBulkMoleFractionInput =
            "0.05"
        areaInput = "2"
        clearResult()
    }

    private func resetInputs() {
        gasCoefficientInput = ""
        liquidCoefficientInput = ""
        equilibriumSlopeInput = ""
        gasBulkMoleFractionInput = ""
        liquidBulkMoleFractionInput = ""
        areaInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        OverallMassTransferCoefficientView()
    }
}
