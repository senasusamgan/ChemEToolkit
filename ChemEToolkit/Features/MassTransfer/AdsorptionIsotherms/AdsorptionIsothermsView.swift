import SwiftUI

struct AdsorptionIsothermsView: View {
    @State
    private var model:
        AdsorptionIsothermModel =
            .langmuir

    @State
    private var concentrationInput = "2"

    @State
    private var maximumCapacityInput = "5"

    @State
    private var langmuirConstantInput = "0.8"

    @State
    private var freundlichConstantInput = "1.5"

    @State
    private var freundlichExponentInput = "2"

    @State
    private var linearConstantInput = "2"

    @State
    private var result:
        AdsorptionIsothermsResult?

    @State
    private var errorMessage = ""

    private let engine =
        AdsorptionIsothermsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "circle.grid.2x2.fill",
                    title:
                        "Adsorption Isotherms",
                    subtitle:
                        "Calculate equilibrium loading with Langmuir, Freundlich or linear models",
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
            "Adsorption Isotherms"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text("Equilibrium Solid Loading")
                    .font(.headline)

                Text(
                    selectedEquation
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Concentration and loading units must be consistent \
                    with the selected fitted parameters. Isotherm \
                    parameters are system- and temperature-specific.
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
            return "q = qmax bC / (1 + bC)"

        case .freundlich:
            return "q = KF C^(1/n)"

        case .linear:
            return "q = K C"
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Isotherm Model")
                .font(.headline)

            Picker(
                "Isotherm Model",
                selection: $model
            ) {
                ForEach(
                    AdsorptionIsothermModel
                        .allCases
                ) { option in
                    Text(option.title)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .onChange(of: model) {
                loadExample()
            }

            Divider()

            Text("Equilibrium Concentration")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Fluid-Phase Concentration",
                symbol: "C",
                unit: "kg/m³",
                placeholder: "Example: 2",
                text: $concentrationInput
            )

            modelParameterFields

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Equilibrium Loading",
                systemImage:
                    "circle.grid.2x2.fill",
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
                    "Maximum Adsorption Capacity",
                symbol: "qmax",
                unit: "kg/kg",
                placeholder: "Example: 5",
                text: $maximumCapacityInput
            )

            EngineeringInputField(
                title:
                    "Langmuir Constant",
                symbol: "b",
                unit: "m³/kg",
                placeholder: "Example: 0.8",
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
            Text("Linear Isotherm Parameter")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Distribution Constant",
                symbol: "K",
                unit: "m³/kg",
                placeholder: "Example: 2",
                text: $linearConstantInput
            )
        }
    }

    private func resultSection(
        _ result:
            AdsorptionIsothermsResult
    ) -> some View {
        var items = [
            CalculationResultDisplayItem(
                label:
                    "Equilibrium Loading",
                value:
                    numberFormatter.format(
                        result.equilibriumLoading
                    ),
                unit: "kg/kg"
            ),
            CalculationResultDisplayItem(
                label:
                    "Local Isotherm Slope",
                value:
                    result.localIsothermSlope
                        .isFinite
                    ? numberFormatter.format(
                        result.localIsothermSlope
                    )
                    : "∞",
                unit: "loading/concentration"
            )
        ]

        if let saturation =
            result.fractionalSaturation {

            items.append(
                CalculationResultDisplayItem(
                    label:
                        "Fractional Saturation",
                    value:
                        numberFormatter.format(
                            100 * saturation
                        ),
                    unit: "%"
                )
            )
        }

        return VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: items,
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
                            "circle.grid.2x2.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.activeEquation)
                        .fontWeight(.semibold)

                    Text(
                        result
                            .parameterInterpretation
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
        -> AdsorptionIsothermsInput {

        AdsorptionIsothermsInput(
            model: model,
            equilibriumFluidConcentration:
                try InputValidator.parseNumber(
                    concentrationInput,
                    fieldName:
                        "equilibrium fluid concentration"
                ),
            maximumAdsorptionCapacity:
                try InputValidator.parseNumber(
                    maximumCapacityInput,
                    fieldName:
                        "maximum adsorption capacity"
                ),
            langmuirConstant:
                try InputValidator.parseNumber(
                    langmuirConstantInput,
                    fieldName:
                        "Langmuir constant"
                ),
            freundlichConstant:
                try InputValidator.parseNumber(
                    freundlichConstantInput,
                    fieldName:
                        "Freundlich constant"
                ),
            freundlichExponent:
                try InputValidator.parseNumber(
                    freundlichExponentInput,
                    fieldName:
                        "Freundlich exponent"
                ),
            linearDistributionConstant:
                try InputValidator.parseNumber(
                    linearConstantInput,
                    fieldName:
                        "linear distribution constant"
                )
        )
    }

    private func loadExample() {
        switch model {
        case .langmuir:
            concentrationInput = "2"
            maximumCapacityInput = "5"
            langmuirConstantInput = "0.8"

        case .freundlich:
            concentrationInput = "4"
            freundlichConstantInput = "1.5"
            freundlichExponentInput = "2"

        case .linear:
            concentrationInput = "1.2"
            linearConstantInput = "2"
        }

        clearResult()
    }

    private func resetInputs() {
        concentrationInput = ""
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
        AdsorptionIsothermsView()
    }
}
