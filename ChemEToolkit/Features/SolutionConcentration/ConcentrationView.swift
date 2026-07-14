import SwiftUI

struct ConcentrationView: View {
    @State
    private var selectedMode:
        ConcentrationMode = .molarity

    @State
    private var unknownVariable:
        ConcentrationUnknown = .concentration

    @State private var concentrationInput = ""
    @State private var molesInput = ""
    @State private var denominatorInput = ""

    @State
    private var calculationResult:
        ConcentrationResult?

    @State private var errorMessage = ""

    private let engine = ConcentrationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: selectedMode.icon,
                    title: "Solution Concentration",
                    subtitle:
                        "Molarity and Molality Calculator",
                    tint: .blue
                )

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Solution Concentration")
        .onChange(
            of: selectedMode
        ) { _, _ in
            clearAll()
        }
        .onChange(
            of: unknownVariable
        ) { _, _ in
            clearResult()
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Calculation Type")
                .font(.headline)

            Picker(
                "Calculation Type",
                selection: $selectedMode
            ) {
                ForEach(
                    ConcentrationMode.allCases
                ) { mode in
                    Text(mode.title)
                        .tag(mode)
                }
            }
            .pickerStyle(.segmented)

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    spacing: AppSpacing.xSmall
                ) {
                    Text(selectedMode.formula)
                        .font(
                            .system(
                                size: 26,
                                weight: .semibold
                            )
                        )

                    Text(selectedMode.explanation)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }

            Text("Select the unknown variable")
                .font(.headline)

            Picker(
                "Unknown Variable",
                selection: $unknownVariable
            ) {
                ForEach(
                    ConcentrationUnknown.allCases
                ) { variable in
                    Text(
                        variable.symbol(
                            for: selectedMode
                        )
                    )
                    .tag(variable)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            CalculatorInputField(
                title: selectedMode.title,
                symbol: selectedMode.symbol,
                unit:
                    selectedMode.concentrationUnit,
                placeholder:
                    "Enter \(selectedMode.title.lowercased())",
                text: $concentrationInput,
                isCalculated:
                    unknownVariable == .concentration
            )

            CalculatorInputField(
                title: "Amount of Solute",
                symbol: "n",
                unit: "mol",
                placeholder:
                    "Enter amount of solute",
                text: $molesInput,
                isCalculated:
                    unknownVariable == .moles
            )

            CalculatorInputField(
                title:
                    selectedMode.denominatorName,
                symbol:
                    selectedMode.denominatorSymbol,
                unit:
                    selectedMode.denominatorUnit,
                placeholder:
                    "Enter \(selectedMode.denominatorName.lowercased())",
                text: $denominatorInput,
                isCalculated:
                    unknownVariable == .denominator
            )

            PrimaryActionButton(
                title: "Calculate",
                systemImage: "equal.circle.fill",
                action: calculate
            )

            if let calculationResult {
                CalculationResultCard(
                    items: [
                        CalculationResultDisplayItem(
                            label:
                                calculationResult.label,
                            value:
                                numberFormatter.format(
                                    calculationResult.value
                                ),
                            unit:
                                calculationResult.unit
                        )
                    ]
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func calculate() {
        clearResult()

        do {
            let input = try makeInput()

            calculationResult =
                try engine.solve(
                    mode: selectedMode,
                    unknownVariable:
                        unknownVariable,
                    input: input
                )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func makeInput() throws
        -> ConcentrationInput {
        ConcentrationInput(
            concentration: try parsedValue(
                concentrationInput,
                variable: .concentration,
                fieldName: selectedMode.title
            ),
            moles: try parsedValue(
                molesInput,
                variable: .moles,
                fieldName: "Amount of Solute"
            ),
            denominator: try parsedValue(
                denominatorInput,
                variable: .denominator,
                fieldName:
                    selectedMode.denominatorName
            )
        )
    }

    private func parsedValue(
        _ text: String,
        variable: ConcentrationUnknown,
        fieldName: String
    ) throws -> Double? {
        guard unknownVariable != variable else {
            return nil
        }

        return try InputValidator.parseNumber(
            text,
            fieldName: fieldName
        )
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The calculation could not be completed."

        if let suggestion = error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        calculationResult = nil
        errorMessage = ""
    }

    private func clearAll() {
        concentrationInput = ""
        molesInput = ""
        denominatorInput = ""

        clearResult()
    }
}

#Preview {
    NavigationStack {
        ConcentrationView()
    }
}
