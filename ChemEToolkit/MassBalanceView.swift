import SwiftUI

enum MassBalanceUnknown: String, CaseIterable, Identifiable {
    case outletFlow
    case outletComposition
    case inletFlow1
    case inletFlow2

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .outletFlow:
            return "F₃"

        case .outletComposition:
            return "x₃"

        case .inletFlow1:
            return "F₁"

        case .inletFlow2:
            return "F₂"
        }
    }

    var title: String {
        switch self {
        case .outletFlow:
            return "Outlet Flow"

        case .outletComposition:
            return "Outlet Composition"

        case .inletFlow1:
            return "Inlet Flow 1"

        case .inletFlow2:
            return "Inlet Flow 2"
        }
    }
}

enum CompositionFormat: String, CaseIterable, Identifiable {
    case fraction = "Fraction"
    case percentage = "Percentage"

    var id: String { rawValue }

    var unit: String {
        switch self {
        case .fraction:
            return "0 – 1"

        case .percentage:
            return "%"
        }
    }
}

struct MassBalanceResult: Identifiable {
    let id = UUID()
    let label: String
    let value: String
    let unit: String
}

struct MassBalanceView: View {
    @State private var unknownVariable: MassBalanceUnknown = .outletFlow
    @State private var compositionFormat: CompositionFormat = .fraction

    @State private var flow1Input = ""
    @State private var flow2Input = ""

    @State private var composition1Input = ""
    @State private var composition2Input = ""
    @State private var composition3Input = ""

    @State private var results: [MassBalanceResult] = []
    @State private var errorMessage = ""

    private let flowUnit = "kg/h"
    private let tolerance = 1.0e-12

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "arrow.triangle.merge")
                    .font(.system(size: 54))
                    .foregroundStyle(.blue)

                Text("Mass Balance Calculator")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Steady-State Non-Reactive Mixer")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                equationCard

                VStack(alignment: .leading, spacing: 20) {
                    Text("Select the unknown variable")
                        .font(.headline)

                    Picker(
                        "Unknown Variable",
                        selection: $unknownVariable
                    ) {
                        ForEach(MassBalanceUnknown.allCases) { variable in
                            Text(variable.symbol)
                                .tag(variable)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(
                        "\(unknownVariable.title) "
                        + "(\(unknownVariable.symbol)) will be calculated."
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
                            ForEach(CompositionFormat.allCases) { format in
                                Text(format.rawValue)
                                    .tag(format)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Divider()

                    requiredFields

                    Button {
                        calculate()
                    } label: {
                        Label(
                            "Calculate",
                            systemImage: "equal.circle.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    if !results.isEmpty {
                        resultCard
                    }

                    if !errorMessage.isEmpty {
                        Label(
                            errorMessage,
                            systemImage: "exclamationmark.triangle.fill"
                        )
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(24)
                .frame(maxWidth: 620)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.quaternary)
                )
            }
            .padding(40)
        }
        .frame(minWidth: 720, minHeight: 760)
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

    private var equationCard: some View {
        VStack(spacing: 10) {
            Text("Overall Mass Balance")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("F₁ + F₂ = F₃")
                .font(.system(size: 25, weight: .semibold))

            Text("Component Balance")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("F₁x₁ + F₂x₂ = F₃x₃")
                .font(.system(size: 25, weight: .semibold))

            Text(
                "F: mass flow rate • x: component mass fraction"
            )
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: 620)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.blue.opacity(0.08))
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(title) (\(symbol))")
                    .font(.headline)

                Spacer()

                Text(flowUnit)
                    .foregroundStyle(.secondary)
            }

            TextField(
                "Enter mass flow rate",
                text: text
            )
            .textFieldStyle(.roundedBorder)
        }
    }

    private func compositionField(
        title: String,
        symbol: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(title) (\(symbol))")
                    .font(.headline)

                Spacer()

                Text(compositionFormat.unit)
                    .foregroundStyle(.secondary)
            }

            TextField(
                compositionPlaceholder,
                text: text
            )
            .textFieldStyle(.roundedBorder)
        }
    }

    private var compositionPlaceholder: String {
        switch compositionFormat {
        case .fraction:
            return "Enter a value between 0 and 1"

        case .percentage:
            return "Enter a value between 0 and 100"
        }
    }

    private var resultCard: some View {
        VStack(spacing: 18) {
            ForEach(results) { result in
                VStack(spacing: 6) {
                    Text(result.label)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text(result.value)
                        .font(.system(size: 32, weight: .bold))

                    Text(result.unit)
                        .foregroundStyle(.secondary)
                }

                if result.id != results.last?.id {
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.green.opacity(0.12))
        )
    }

    private func calculate() {
        clearResult()

        switch unknownVariable {
        case .outletFlow:
            calculateOutletFlow()

        case .outletComposition:
            calculateOutletComposition()

        case .inletFlow1:
            calculateInletFlow1()

        case .inletFlow2:
            calculateInletFlow2()
        }
    }

    private func calculateOutletFlow() {
        guard
            let flow1 = parseNumber(flow1Input),
            let flow2 = parseNumber(flow2Input)
        else {
            showInvalidInputError()
            return
        }

        guard flow1 >= 0, flow2 >= 0 else {
            showFlowError()
            return
        }

        let outletFlow = flow1 + flow2

        results = [
            makeFlowResult(
                label: "Outlet Flow (F₃)",
                value: outletFlow
            )
        ]
    }

    private func calculateOutletComposition() {
        guard
            let flow1 = parseNumber(flow1Input),
            let flow2 = parseNumber(flow2Input),
            let composition1 = parseComposition(
                composition1Input
            ),
            let composition2 = parseComposition(
                composition2Input
            )
        else {
            showInvalidInputError()
            return
        }

        guard flow1 >= 0, flow2 >= 0 else {
            showFlowError()
            return
        }

        let outletFlow = flow1 + flow2

        guard outletFlow > 0 else {
            errorMessage =
                "The total outlet flow must be greater than zero."
            return
        }

        let outletComposition =
            (
                flow1 * composition1
                + flow2 * composition2
            ) / outletFlow

        results = [
            makeFlowResult(
                label: "Outlet Flow (F₃)",
                value: outletFlow
            ),
            makeCompositionResult(
                label: "Outlet Composition (x₃)",
                value: outletComposition
            )
        ]
    }

    private func calculateInletFlow1() {
        guard
            let flow2 = parseNumber(flow2Input),
            let composition1 = parseComposition(
                composition1Input
            ),
            let composition2 = parseComposition(
                composition2Input
            ),
            let outletComposition = parseComposition(
                composition3Input
            )
        else {
            showInvalidInputError()
            return
        }

        guard flow2 >= 0 else {
            showFlowError()
            return
        }

        let denominator =
            outletComposition - composition1

        guard abs(denominator) > tolerance else {
            errorMessage =
                "F₁ cannot be uniquely calculated "
                + "with these composition values."
            return
        }

        let calculatedFlow1 =
            flow2
            * (composition2 - outletComposition)
            / denominator

        guard calculatedFlow1 >= -tolerance else {
            showImpossibleBalanceError()
            return
        }

        let flow1 = max(0, calculatedFlow1)
        let outletFlow = flow1 + flow2

        results = [
            makeFlowResult(
                label: "Inlet Flow 1 (F₁)",
                value: flow1
            ),
            makeFlowResult(
                label: "Outlet Flow (F₃)",
                value: outletFlow
            )
        ]
    }

    private func calculateInletFlow2() {
        guard
            let flow1 = parseNumber(flow1Input),
            let composition1 = parseComposition(
                composition1Input
            ),
            let composition2 = parseComposition(
                composition2Input
            ),
            let outletComposition = parseComposition(
                composition3Input
            )
        else {
            showInvalidInputError()
            return
        }

        guard flow1 >= 0 else {
            showFlowError()
            return
        }

        let denominator =
            outletComposition - composition2

        guard abs(denominator) > tolerance else {
            errorMessage =
                "F₂ cannot be uniquely calculated "
                + "with these composition values."
            return
        }

        let calculatedFlow2 =
            flow1
            * (composition1 - outletComposition)
            / denominator

        guard calculatedFlow2 >= -tolerance else {
            showImpossibleBalanceError()
            return
        }

        let flow2 = max(0, calculatedFlow2)
        let outletFlow = flow1 + flow2

        results = [
            makeFlowResult(
                label: "Inlet Flow 2 (F₂)",
                value: flow2
            ),
            makeFlowResult(
                label: "Outlet Flow (F₃)",
                value: outletFlow
            )
        ]
    }

    private func parseNumber(_ text: String) -> Double? {
        let normalizedText = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        return Double(normalizedText)
    }

    private func parseComposition(
        _ text: String
    ) -> Double? {
        guard let enteredValue = parseNumber(text) else {
            return nil
        }

        let fraction: Double

        switch compositionFormat {
        case .fraction:
            fraction = enteredValue

        case .percentage:
            fraction = enteredValue / 100
        }

        guard fraction >= 0, fraction <= 1 else {
            return nil
        }

        return fraction
    }

    private func makeFlowResult(
        label: String,
        value: Double
    ) -> MassBalanceResult {
        MassBalanceResult(
            label: label,
            value: formatNumber(value),
            unit: flowUnit
        )
    }

    private func makeCompositionResult(
        label: String,
        value: Double
    ) -> MassBalanceResult {
        switch compositionFormat {
        case .fraction:
            return MassBalanceResult(
                label: label,
                value: formatNumber(value),
                unit: "mass fraction"
            )

        case .percentage:
            return MassBalanceResult(
                label: label,
                value: formatNumber(value * 100),
                unit: "%"
            )
        }
    }

    private func formatNumber(
        _ value: Double
    ) -> String {
        value.formatted(
            .number.precision(.significantDigits(1...8))
        )
    }

    private func showInvalidInputError() {
        errorMessage =
            "Please enter valid numerical values. "
            + "Compositions must also remain within the selected range."
    }

    private func showFlowError() {
        errorMessage =
            "Mass flow rates cannot be negative."
    }

    private func showImpossibleBalanceError() {
        errorMessage =
            "These values produce a negative flow rate. "
            + "Check whether the outlet composition lies "
            + "between the two inlet compositions."
    }

    private func clearResult() {
        results = []
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MassBalanceView()
    }
}
