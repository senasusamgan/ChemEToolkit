import SwiftUI

struct MassBalanceView: View {
    @State
    private var unknownVariable:
        MassBalanceUnknown = .outletFlow

    @State
    private var compositionFormat:
        CompositionFormat = .fraction

    @State private var flow1Input = ""
    @State private var flow2Input = ""

    @State private var composition1Input = ""
    @State private var composition2Input = ""
    @State private var composition3Input = ""

    @State
    private var solution: MassBalanceSolution?

    @State private var errorMessage = ""

    private let engine = MassBalanceEngine()
    private let flowUnit = "kg/h"

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.merge",
                    title: "Mass Balance Calculator",
                    subtitle:
                        "Steady-State Non-Reactive Mixer",
                    tint: .blue
                )

                equationCard

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
        .navigationTitle("Mass Balance")
        .onChange(of: unknownVariable) { _, _ in
            clearResult()
        }
        .onChange(of: compositionFormat) { _, _ in
            composition1Input = ""
            composition2Input = ""
            composition3Input = ""

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
                ForEach(
                    MassBalanceUnknown.allCases
                ) { variable in
                    Text(variable.symbol)
                        .tag(variable)
                }
            }
            .pickerStyle(.segmented)

            Text(
                "\(unknownVariable.title) " +
                "(\(unknownVariable.symbol)) will be calculated."
            )
            .foregroundStyle(.secondary)

            if unknownVariable != .outletFlow {
                Divider()

                Text("Composition Input Format")
                    .font(.headline)

                Picker(
                    "Composition Input Format",
                    selection: $compositionFormat
                ) {
                    ForEach(
                        CompositionFormat.allCases
                    ) { format in
                        Text(format.title)
                            .tag(format)
                    }
                }
                .pickerStyle(.segmented)
            }

            Divider()

            requiredFields

            PrimaryActionButton(
                title: "Calculate",
                systemImage: "equal.circle.fill",
                action: calculate
            )

            if let solution {
                CalculationResultCard(
                    items: resultItems(
                        from: solution
                    )
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var equationCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text("Overall Mass Balance")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text("F₁ + F₂ = F₃")
                    .font(
                        .system(
                            size: 25,
                            weight: .semibold
                        )
                    )

                Divider()

                Text("Component Balance")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text("F₁x₁ + F₂x₂ = F₃x₃")
                    .font(
                        .system(
                            size: 25,
                            weight: .semibold
                        )
                    )

                Text(
                    "F: mass flow rate • x: component mass fraction"
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
        }
        .frame(
            maxWidth:
                AppTheme.Layout.calculatorMaxWidth
        )
    }

    @ViewBuilder
    private var requiredFields: some View {
        switch unknownVariable {
        case .outletFlow:
            flowField(
                title: "Inlet Flow 1",
                symbol: "F₁",
                text: $flow1Input
            )

            flowField(
                title: "Inlet Flow 2",
                symbol: "F₂",
                text: $flow2Input
            )

        case .outletComposition:
            flowField(
                title: "Inlet Flow 1",
                symbol: "F₁",
                text: $flow1Input
            )

            compositionField(
                title: "Inlet Composition 1",
                symbol: "x₁",
                text: $composition1Input
            )

            flowField(
                title: "Inlet Flow 2",
                symbol: "F₂",
                text: $flow2Input
            )

            compositionField(
                title: "Inlet Composition 2",
                symbol: "x₂",
                text: $composition2Input
            )

        case .inletFlow1:
            flowField(
                title: "Inlet Flow 2",
                symbol: "F₂",
                text: $flow2Input
            )

            compositionField(
                title: "Inlet Composition 1",
                symbol: "x₁",
                text: $composition1Input
            )

            compositionField(
                title: "Inlet Composition 2",
                symbol: "x₂",
                text: $composition2Input
            )

            compositionField(
                title: "Outlet Composition",
                symbol: "x₃",
                text: $composition3Input
            )

        case .inletFlow2:
            flowField(
                title: "Inlet Flow 1",
                symbol: "F₁",
                text: $flow1Input
            )

            compositionField(
                title: "Inlet Composition 1",
                symbol: "x₁",
                text: $composition1Input
            )

            compositionField(
                title: "Inlet Composition 2",
                symbol: "x₂",
                text: $composition2Input
            )

            compositionField(
                title: "Outlet Composition",
                symbol: "x₃",
                text: $composition3Input
            )
        }
    }

    private func flowField(
        title: String,
        symbol: String,
        text: Binding<String>
    ) -> some View {
        CalculatorInputField(
            title: title,
            symbol: symbol,
            unit: flowUnit,
            placeholder: "Enter mass flow rate",
            text: text
        )
    }

    private func compositionField(
        title: String,
        symbol: String,
        text: Binding<String>
    ) -> some View {
        CalculatorInputField(
            title: title,
            symbol: symbol,
            unit: compositionFormat.unit,
            placeholder:
                compositionFormat.placeholder,
            text: text
        )
    }

    private func resultItems(
        from solution: MassBalanceSolution
    ) -> [CalculationResultDisplayItem] {
        solution.items.map { item in
            CalculationResultDisplayItem(
                label: item.displayLabel,
                value: formattedValue(
                    for: item
                ),
                unit: unit(for: item)
            )
        }
    }

    private func calculate() {
        clearResult()

        do {
            let input = try makeInput()

            solution = try engine.solve(
                unknownVariable: unknownVariable,
                input: input
            )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> MassBalanceInput {
        switch unknownVariable {
        case .outletFlow:
            return MassBalanceInput(
                flow1: try parseFlow(
                    flow1Input,
                    fieldName: "Inlet Flow 1"
                ),
                flow2: try parseFlow(
                    flow2Input,
                    fieldName: "Inlet Flow 2"
                ),
                composition1: nil,
                composition2: nil,
                outletComposition: nil
            )

        case .outletComposition:
            return MassBalanceInput(
                flow1: try parseFlow(
                    flow1Input,
                    fieldName: "Inlet Flow 1"
                ),
                flow2: try parseFlow(
                    flow2Input,
                    fieldName: "Inlet Flow 2"
                ),
                composition1:
                    try parseComposition(
                        composition1Input,
                        fieldName:
                            "Inlet Composition 1"
                    ),
                composition2:
                    try parseComposition(
                        composition2Input,
                        fieldName:
                            "Inlet Composition 2"
                    ),
                outletComposition: nil
            )

        case .inletFlow1:
            return MassBalanceInput(
                flow1: nil,
                flow2: try parseFlow(
                    flow2Input,
                    fieldName: "Inlet Flow 2"
                ),
                composition1:
                    try parseComposition(
                        composition1Input,
                        fieldName:
                            "Inlet Composition 1"
                    ),
                composition2:
                    try parseComposition(
                        composition2Input,
                        fieldName:
                            "Inlet Composition 2"
                    ),
                outletComposition:
                    try parseComposition(
                        composition3Input,
                        fieldName:
                            "Outlet Composition"
                    )
            )

        case .inletFlow2:
            return MassBalanceInput(
                flow1: try parseFlow(
                    flow1Input,
                    fieldName: "Inlet Flow 1"
                ),
                flow2: nil,
                composition1:
                    try parseComposition(
                        composition1Input,
                        fieldName:
                            "Inlet Composition 1"
                    ),
                composition2:
                    try parseComposition(
                        composition2Input,
                        fieldName:
                            "Inlet Composition 2"
                    ),
                outletComposition:
                    try parseComposition(
                        composition3Input,
                        fieldName:
                            "Outlet Composition"
                    )
            )
        }
    }

    private func parseFlow(
        _ text: String,
        fieldName: String
    ) throws -> Double {
        try InputValidator.parseNumber(
            text,
            fieldName: fieldName
        )
    }

    private func parseComposition(
        _ text: String,
        fieldName: String
    ) throws -> Double {
        let enteredValue =
            try InputValidator.parseNumber(
                text,
                fieldName: fieldName
            )

        switch compositionFormat {
        case .fraction:
            return try InputValidator
                .requireFraction(
                    enteredValue,
                    fieldName: fieldName
                )

        case .percentage:
            let percentage =
                try InputValidator
                    .requirePercentage(
                        enteredValue,
                        fieldName: fieldName
                    )

            return compositionFormat
                .fractionValue(
                    from: percentage
                )
        }
    }

    private func formattedValue(
        for item: MassBalanceResultItem
    ) -> String {
        let displayValue: Double

        if item.variable.isComposition {
            displayValue =
                compositionFormat.displayValue(
                    from: item.value
                )
        } else {
            displayValue = item.value
        }

        return numberFormatter.format(
            displayValue
        )
    }

    private func unit(
        for item: MassBalanceResultItem
    ) -> String {
        guard item.variable.isComposition else {
            return flowUnit
        }

        switch compositionFormat {
        case .fraction:
            return "mass fraction"

        case .percentage:
            return "%"
        }
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The mass balance could not be completed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        solution = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MassBalanceView()
    }
}
