import SwiftUI

struct IdealGasView: View {
    @State private var unknownVariable: GasVariable = .pressure

    @State private var pressureInput = ""
    @State private var volumeInput = ""
    @State private var molesInput = ""
    @State private var temperatureInput = ""

    @State private var resultValue = ""
    @State private var resultName = ""
    @State private var resultUnit = ""
    @State private var errorMessage = ""

    private let engine = IdealGasEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "flask.fill",
                    title: "Ideal Gas Calculator",
                    subtitle: "PV = nRT",
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
        .navigationTitle("Ideal Gas Calculator")
        .onChange(of: unknownVariable) { _, _ in
            clearResult()
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Select the unknown variable")
                .font(.headline)

            Picker(
                "Unknown Variable",
                selection: $unknownVariable
            ) {
                ForEach(GasVariable.allCases) { variable in
                    Text(variable.symbol)
                        .tag(variable)
                }
            }
            .pickerStyle(.segmented)

            CalculatorInfoCard(tint: .blue) {
                HStack(
                    alignment: .top,
                    spacing: AppSpacing.small
                ) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.blue)
                        .accessibilityHidden(true)

                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.xxSmall
                    ) {
                        Text("Units used in this calculator")
                            .font(.headline)

                        Text(
                            "P: kPa • V: L • n: mol • T: K"
                        )
                        .foregroundStyle(.secondary)

                        Text(
                            "R = \(IdealGasEngine.gasConstant) L·kPa/(mol·K)"
                        )
                        .foregroundStyle(.secondary)
                    }
                }
            }

            Divider()

            CalculatorInputField(
                title: GasVariable.pressure.name,
                symbol: GasVariable.pressure.symbol,
                unit: GasVariable.pressure.unit,
                placeholder: "Enter pressure",
                text: $pressureInput,
                isCalculated:
                    unknownVariable == .pressure
            )

            CalculatorInputField(
                title: GasVariable.volume.name,
                symbol: GasVariable.volume.symbol,
                unit: GasVariable.volume.unit,
                placeholder: "Enter volume",
                text: $volumeInput,
                isCalculated:
                    unknownVariable == .volume
            )

            CalculatorInputField(
                title: GasVariable.moles.name,
                symbol: GasVariable.moles.symbol,
                unit: GasVariable.moles.unit,
                placeholder: "Enter amount of substance",
                text: $molesInput,
                isCalculated:
                    unknownVariable == .moles
            )

            CalculatorInputField(
                title: GasVariable.temperature.name,
                symbol: GasVariable.temperature.symbol,
                unit: GasVariable.temperature.unit,
                placeholder: "Enter temperature",
                text: $temperatureInput,
                isCalculated:
                    unknownVariable == .temperature
            )

            PrimaryActionButton(
                title: "Calculate",
                systemImage: "equal.circle.fill",
                action: calculate
            )

            if !resultValue.isEmpty {
                CalculationResultCard(
                    items: [
                        CalculationResultDisplayItem(
                            label: resultName,
                            value: resultValue,
                            unit: resultUnit
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

            let result = try engine.solve(
                unknownVariable: unknownVariable,
                input: input
            )

            showResult(result)
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func makeInput() throws -> IdealGasInput {
        IdealGasInput(
            pressure: try parsedValue(
                pressureInput,
                variable: .pressure
            ),
            volume: try parsedValue(
                volumeInput,
                variable: .volume
            ),
            moles: try parsedValue(
                molesInput,
                variable: .moles
            ),
            temperature: try parsedValue(
                temperatureInput,
                variable: .temperature
            )
        )
    }

    private func parsedValue(
        _ text: String,
        variable: GasVariable
    ) throws -> Double? {
        guard unknownVariable != variable else {
            return nil
        }

        return try InputValidator.parseNumber(
            text,
            fieldName: variable.name
        )
    }

    private func showResult(
        _ result: IdealGasResult
    ) {
        resultValue = numberFormatter.format(
            result.value
        )

        resultName =
            "\(result.variable.name) " +
            "(\(result.variable.symbol))"

        resultUnit = result.variable.unit
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
        resultValue = ""
        resultName = ""
        resultUnit = ""
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IdealGasView()
    }
}
