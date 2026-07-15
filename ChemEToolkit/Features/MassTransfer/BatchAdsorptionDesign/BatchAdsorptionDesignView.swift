import SwiftUI

struct BatchAdsorptionDesignView:
    View {

    @State
    private var model:
        BatchAdsorptionEquilibriumModel =
            .langmuir

    @State
    private var solutionVolumeInput =
        "10"

    @State
    private var initialConcentrationInput =
        "5"

    @State
    private var targetConcentrationInput =
        "1"

    @State
    private var maximumCapacityInput =
        "2"

    @State
    private var langmuirConstantInput =
        "0.5"

    @State
    private var freundlichConstantInput =
        "1.5"

    @State
    private var freundlichExponentInput =
        "2"

    @State
    private var linearConstantInput =
        "1"

    @State
    private var result:
        BatchAdsorptionDesignResult?

    @State
    private var errorMessage = ""

    private let engine =
        BatchAdsorptionDesignEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "shippingbox.fill",
                    title:
                        "Batch Adsorption Design",
                    subtitle:
                        "Calculate equilibrium loading and required adsorbent mass",
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
            "Batch Adsorption Design"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Equilibrium Batch Balance"
                )
                .font(.headline)

                Text(
                    "Mads = V(C0 − Ce) / qe"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)

                Text(selectedEquation)
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )
                    .minimumScaleFactor(0.5)

                Text(
                    """
                    Concentration and isotherm parameter units must be \
                    mutually consistent. The calculation sizes equilibrium \
                    adsorbent demand rather than contact time.
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

    private var selectedEquation: String {
        switch model {
        case .langmuir:
            return "qe = qmax bCe / (1 + bCe)"

        case .freundlich:
            return "qe = KF Ce^(1/n)"

        case .linear:
            return "qe = K Ce"
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Equilibrium Model")
                .font(.headline)

            Picker(
                "Equilibrium Model",
                selection: $model
            ) {
                ForEach(
                    BatchAdsorptionEquilibriumModel
                        .allCases
                ) { option in
                    Text(option.title)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            Divider()

            Text("Batch Specifications")
                .font(.headline)

            EngineeringInputField(
                title: "Solution Volume",
                symbol: "V",
                unit: "m³",
                placeholder: "Example: 10",
                text: $solutionVolumeInput
            )

            EngineeringInputField(
                title:
                    "Initial Concentration",
                symbol: "C0",
                unit: "kg/m³",
                placeholder: "Example: 5",
                text:
                    $initialConcentrationInput
            )

            EngineeringInputField(
                title:
                    "Target Equilibrium Concentration",
                symbol: "Ce",
                unit: "kg/m³",
                placeholder: "Example: 1",
                text:
                    $targetConcentrationInput
            )

            modelParameterFields

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Adsorbent Requirement",
                systemImage:
                    "shippingbox.fill",
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

    @ViewBuilder
    private var modelParameterFields:
        some View {

        Divider()

        switch model {
        case .langmuir:
            Text("Langmuir Parameters")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Maximum Capacity",
                symbol: "qmax",
                unit: "kg/kg",
                placeholder: "Example: 2",
                text: $maximumCapacityInput
            )

            EngineeringInputField(
                title:
                    "Langmuir Constant",
                symbol: "b",
                unit: "m³/kg",
                placeholder: "Example: 0.5",
                text:
                    $langmuirConstantInput
            )

        case .freundlich:
            Text("Freundlich Parameters")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Freundlich Constant",
                symbol: "KF",
                unit: "model units",
                placeholder: "Example: 1.5",
                text:
                    $freundlichConstantInput
            )

            EngineeringInputField(
                title:
                    "Freundlich Exponent",
                symbol: "n",
                unit: "—",
                placeholder: "Example: 2",
                text:
                    $freundlichExponentInput
            )

        case .linear:
            Text("Linear Parameter")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Distribution Constant",
                symbol: "K",
                unit: "m³/kg",
                placeholder: "Example: 1",
                text: $linearConstantInput
            )
        }
    }

    private func resultSection(
        _ result:
            BatchAdsorptionDesignResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Target Equilibrium Loading",
                        value:
                            numberFormatter.format(
                                result
                                    .targetEquilibriumLoading
                            ),
                        unit: "kg/kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute Removed",
                        value:
                            numberFormatter.format(
                                result
                                    .soluteRemovedMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Required Adsorbent Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .requiredAdsorbentMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label: "Removal",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .removalFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Adsorbent / Solution Volume",
                        value:
                            numberFormatter.format(
                                result
                                    .adsorbentToSolutionVolumeRatio
                            ),
                        unit: "kg/m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute Remaining in Liquid",
                        value:
                            numberFormatter.format(
                                result
                                    .equilibriumLiquidSoluteMass
                            ),
                        unit: "kg"
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
                        result.model.title,
                        systemImage:
                            "shippingbox.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.activeEquation)
                        .fontWeight(.semibold)

                    Text(result.modelName)
                        .foregroundStyle(.secondary)

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
        -> BatchAdsorptionDesignInput {

        let maximumCapacity: Double
        let langmuirConstant: Double
        let freundlichConstant: Double
        let freundlichExponent: Double
        let linearConstant: Double

        switch model {
        case .langmuir:
            maximumCapacity =
                try InputValidator.parseNumber(
                    maximumCapacityInput,
                    fieldName:
                        "maximum adsorption capacity"
                )

            langmuirConstant =
                try InputValidator.parseNumber(
                    langmuirConstantInput,
                    fieldName:
                        "Langmuir constant"
                )

            freundlichConstant = 1
            freundlichExponent = 2
            linearConstant = 1

        case .freundlich:
            maximumCapacity = 1
            langmuirConstant = 1

            freundlichConstant =
                try InputValidator.parseNumber(
                    freundlichConstantInput,
                    fieldName:
                        "Freundlich constant"
                )

            freundlichExponent =
                try InputValidator.parseNumber(
                    freundlichExponentInput,
                    fieldName:
                        "Freundlich exponent"
                )

            linearConstant = 1

        case .linear:
            maximumCapacity = 1
            langmuirConstant = 1
            freundlichConstant = 1
            freundlichExponent = 2

            linearConstant =
                try InputValidator.parseNumber(
                    linearConstantInput,
                    fieldName:
                        "linear distribution constant"
                )
        }

        return BatchAdsorptionDesignInput(
            model: model,
            solutionVolume:
                try InputValidator.parseNumber(
                    solutionVolumeInput,
                    fieldName:
                        "solution volume"
                ),
            initialConcentration:
                try InputValidator.parseNumber(
                    initialConcentrationInput,
                    fieldName:
                        "initial concentration"
                ),
            targetEquilibriumConcentration:
                try InputValidator.parseNumber(
                    targetConcentrationInput,
                    fieldName:
                        "target equilibrium concentration"
                ),
            maximumAdsorptionCapacity:
                maximumCapacity,
            langmuirConstant:
                langmuirConstant,
            freundlichConstant:
                freundlichConstant,
            freundlichExponent:
                freundlichExponent,
            linearDistributionConstant:
                linearConstant
        )
    }

    private func loadExample() {
        solutionVolumeInput = "10"
        initialConcentrationInput = "5"

        switch model {
        case .langmuir:
            targetConcentrationInput = "1"
            maximumCapacityInput = "2"
            langmuirConstantInput = "0.5"

        case .freundlich:
            targetConcentrationInput = "1"
            freundlichConstantInput = "1.5"
            freundlichExponentInput = "2"

        case .linear:
            targetConcentrationInput = "1"
            linearConstantInput = "1"
        }

        clearResult()
    }

    private func resetInputs() {
        solutionVolumeInput = ""
        initialConcentrationInput = ""
        targetConcentrationInput = ""
        maximumCapacityInput = ""
        langmuirConstantInput = ""
        freundlichConstantInput = ""
        freundlichExponentInput = ""
        linearConstantInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BatchAdsorptionDesignView()
    }
}
