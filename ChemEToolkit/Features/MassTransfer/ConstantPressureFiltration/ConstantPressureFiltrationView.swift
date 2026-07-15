import SwiftUI

struct ConstantPressureFiltrationView:
    View {

    @State
    private var viscosityInput = "0.001"

    @State
    private var pressureDropInput = "200000"

    @State
    private var filterAreaInput = "0.5"

    @State
    private var cakeResistanceInput =
        "50000000000"

    @State
    private var solidsConcentrationInput =
        "20"

    @State
    private var mediumResistanceInput =
        "10000000000"

    @State
    private var filtrateVolumeInput = "0.2"

    @State
    private var result:
        ConstantPressureFiltrationResult?

    @State
    private var errorMessage = ""

    private let engine =
        ConstantPressureFiltrationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "line.3.horizontal.decrease.circle.fill",
                    title:
                        "Constant-Pressure Filtration",
                    subtitle:
                        "Calculate filtration time, cake resistance and changing filtrate rate",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text(
                            "Ruth Filtration Equation"
                        )
                        .font(.headline)

                        Text(
                            "t = μ/ΔP [αcV²/(2A²) + RmV/A]"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .minimumScaleFactor(0.42)
                        .multilineTextAlignment(.center)

                        Text(
                            """
                            c is deposited dry solids per filtrate volume. \
                            The linear filtration plot uses t/V = slope·V + intercept.
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
            "Constant-Pressure Filtration"
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Operating Conditions")
                .font(.headline)

            EngineeringInputField(
                title: "Filtrate Viscosity",
                symbol: "μ",
                unit: "Pa·s",
                placeholder: "Example: 0.001",
                text: $viscosityInput
            )

            EngineeringInputField(
                title: "Pressure Drop",
                symbol: "ΔP",
                unit: "Pa",
                placeholder: "Example: 200000",
                text: $pressureDropInput
            )

            EngineeringInputField(
                title: "Filter Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 0.5",
                text: $filterAreaInput
            )

            Divider()

            Text("Cake and Medium")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Specific Cake Resistance",
                symbol: "α",
                unit: "m/kg",
                placeholder: "Example: 5e10",
                text: $cakeResistanceInput
            )

            EngineeringInputField(
                title:
                    "Solids per Filtrate Volume",
                symbol: "c",
                unit: "kg/m³",
                placeholder: "Example: 20",
                text:
                    $solidsConcentrationInput
            )

            EngineeringInputField(
                title:
                    "Filter-Medium Resistance",
                symbol: "Rm",
                unit: "1/m",
                placeholder: "Example: 1e10",
                text: $mediumResistanceInput
            )

            EngineeringInputField(
                title:
                    "Target Filtrate Volume",
                symbol: "V",
                unit: "m³",
                placeholder: "Example: 0.2",
                text: $filtrateVolumeInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Filtration",
                systemImage:
                    "line.3.horizontal.decrease.circle.fill",
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
            ConstantPressureFiltrationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label: "Filtration Time",
                        value:
                            numberFormatter.format(
                                result.filtrationTime
                            ),
                        unit: "s"
                    ),
                    .init(
                        label:
                            "Average Filtrate Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .averageFiltrateFlowRate
                            ),
                        unit: "m³/s"
                    ),
                    .init(
                        label:
                            "Initial Filtrate Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .initialFiltrateFlowRate
                            ),
                        unit: "m³/s"
                    ),
                    .init(
                        label:
                            "Final Filtrate Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .finalFiltrateFlowRate
                            ),
                        unit: "m³/s"
                    ),
                    .init(
                        label:
                            "Deposited Cake Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .depositedCakeMass
                            ),
                        unit: "kg"
                    ),
                    .init(
                        label:
                            "Final Cake Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .finalCakeResistance
                            ),
                        unit: "1/m"
                    ),
                    .init(
                        label:
                            "Final Total Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .finalTotalResistance
                            ),
                        unit: "1/m"
                    ),
                    .init(
                        label:
                            "Cake Resistance Share",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .cakeResistanceFraction
                            ),
                        unit: "%"
                    ),
                    .init(
                        label:
                            "Filtration Plot Slope",
                        value:
                            numberFormatter.format(
                                result
                                    .filtrationPlotSlope
                            ),
                        unit: "s/m⁶"
                    ),
                    .init(
                        label:
                            "Filtration Plot Intercept",
                        value:
                            numberFormatter.format(
                                result
                                    .filtrationPlotIntercept
                            ),
                        unit: "s/m³"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
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
    }

    private func calculate() {
        result = nil
        errorMessage = ""

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
        -> ConstantPressureFiltrationInput {

        .init(
            filtrateViscosity:
                try InputValidator.parseNumber(
                    viscosityInput,
                    fieldName:
                        "filtrate viscosity"
                ),
            pressureDrop:
                try InputValidator.parseNumber(
                    pressureDropInput,
                    fieldName:
                        "pressure drop"
                ),
            filterArea:
                try InputValidator.parseNumber(
                    filterAreaInput,
                    fieldName:
                        "filter area"
                ),
            specificCakeResistance:
                try InputValidator.parseNumber(
                    cakeResistanceInput,
                    fieldName:
                        "specific cake resistance"
                ),
            slurrySolidsPerFiltrateVolume:
                try InputValidator.parseNumber(
                    solidsConcentrationInput,
                    fieldName:
                        "solids per filtrate volume"
                ),
            filterMediumResistance:
                try InputValidator.parseNumber(
                    mediumResistanceInput,
                    fieldName:
                        "filter-medium resistance"
                ),
            targetFiltrateVolume:
                try InputValidator.parseNumber(
                    filtrateVolumeInput,
                    fieldName:
                        "target filtrate volume"
                )
        )
    }

    private func loadExample() {
        viscosityInput = "0.001"
        pressureDropInput = "200000"
        filterAreaInput = "0.5"
        cakeResistanceInput =
            "50000000000"
        solidsConcentrationInput = "20"
        mediumResistanceInput =
            "10000000000"
        filtrateVolumeInput = "0.2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        viscosityInput = ""
        pressureDropInput = ""
        filterAreaInput = ""
        cakeResistanceInput = ""
        solidsConcentrationInput = ""
        mediumResistanceInput = ""
        filtrateVolumeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ConstantPressureFiltrationView()
    }
}
