import SwiftUI

struct TwoFilmTheoryView: View {
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
        TwoFilmTheoryResult?

    @State
    private var errorMessage = ""

    private let engine =
        TwoFilmTheoryEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.3.layers.3d",
                    title: "Two-Film Theory",
                    subtitle:
                        "Solve interface compositions, flux and film-resistance contributions",
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
            "Two-Film Theory"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Steady Interphase Transfer"
                )
                .font(.headline)

                Text(
                    "Nₐ = kG(yG − yᵢ) = kL(xᵢ − xL)"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)
                .multilineTextAlignment(.center)

                Text("yᵢ = mxᵢ")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Each bulk phase is separated from the equilibrium \
                    interface by a stagnant film. The same steady \
                    molar flux passes through both films.
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
            Text("Individual Film Coefficients")
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
                    "Solve Two-Film Transfer",
                systemImage:
                    "square.3.layers.3d",
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
        _ result: TwoFilmTheoryResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Interface Gas Mole Fraction",
                        value:
                            numberFormatter.format(
                                result
                                    .interfaceGasMoleFraction
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Interface Liquid Mole Fraction",
                        value:
                            numberFormatter.format(
                                result
                                    .interfaceLiquidMoleFraction
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Gas-Film Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .gasFilmDrivingForce
                            ),
                        unit: "Δy"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Liquid-Film Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .liquidFilmDrivingForce
                            ),
                        unit: "Δx"
                    ),
                    CalculationResultDisplayItem(
                        label: "Molar Flux",
                        value:
                            numberFormatter.format(
                                result.molarFlux
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
                        "Physical Interpretation",
                        systemImage:
                            "square.3.layers.3d"
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
        -> TwoFilmTheoryInput {

        TwoFilmTheoryInput(
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
        TwoFilmTheoryView()
    }
}
