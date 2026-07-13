import SwiftUI

enum ConcentrationMode: String, CaseIterable, Identifiable {
    case molarity = "Molarity"
    case molality = "Molality"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .molarity:
            return "M"
        case .molality:
            return "m"
        }
    }

    var formula: String {
        switch self {
        case .molarity:
            return "M = n / V"
        case .molality:
            return "m = n / mₛ"
        }
    }

    var concentrationUnit: String {
        switch self {
        case .molarity:
            return "mol/L"
        case .molality:
            return "mol/kg"
        }
    }

    var denominatorName: String {
        switch self {
        case .molarity:
            return "Solution Volume"
        case .molality:
            return "Solvent Mass"
        }
    }

    var denominatorSymbol: String {
        switch self {
        case .molarity:
            return "V"
        case .molality:
            return "mₛ"
        }
    }

    var denominatorUnit: String {
        switch self {
        case .molarity:
            return "L"
        case .molality:
            return "kg"
        }
    }

    var explanation: String {
        switch self {
        case .molarity:
            return "Moles of solute per liter of solution"
        case .molality:
            return "Moles of solute per kilogram of solvent"
        }
    }

    var icon: String {
        switch self {
        case .molarity:
            return "flask.fill"
        case .molality:
            return "scalemass.fill"
        }
    }
}

enum ConcentrationUnknown: String, CaseIterable, Identifiable {
    case concentration
    case moles
    case denominator

    var id: String { rawValue }

    func symbol(for mode: ConcentrationMode) -> String {
        switch self {
        case .concentration:
            return mode.symbol

        case .moles:
            return "n"

        case .denominator:
            return mode.denominatorSymbol
        }
    }
}

struct ConcentrationView: View {
    @State private var selectedMode: ConcentrationMode = .molarity
    @State private var unknownVariable: ConcentrationUnknown = .concentration

    @State private var concentrationInput = ""
    @State private var molesInput = ""
    @State private var denominatorInput = ""

    @State private var resultValue = ""
    @State private var resultLabel = ""
    @State private var resultUnit = ""
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: selectedMode.icon)
                    .font(.system(size: 54))
                    .foregroundStyle(.blue)

                Text("Solution Concentration")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Molarity and Molality Calculator")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Calculation Type")
                        .font(.headline)

                    Picker(
                        "Calculation Type",
                        selection: $selectedMode
                    ) {
                        ForEach(ConcentrationMode.allCases) { mode in
                            Text(mode.rawValue)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    VStack(spacing: 6) {
                        Text(selectedMode.formula)
                            .font(.system(size: 26, weight: .semibold))

                        Text(selectedMode.explanation)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(0.08))
                    )

                    Text("Select the unknown variable")
                        .font(.headline)

                    Picker(
                        "Unknown Variable",
                        selection: $unknownVariable
                    ) {
                        ForEach(ConcentrationUnknown.allCases) { variable in
                            Text(variable.symbol(for: selectedMode))
                                .tag(variable)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    valueField(
                        title: selectedMode.rawValue,
                        symbol: selectedMode.symbol,
                        unit: selectedMode.concentrationUnit,
                        variable: .concentration,
                        text: $concentrationInput
                    )

                    valueField(
                        title: "Amount of Solute",
                        symbol: "n",
                        unit: "mol",
                        variable: .moles,
                        text: $molesInput
                    )

                    valueField(
                        title: selectedMode.denominatorName,
                        symbol: selectedMode.denominatorSymbol,
                        unit: selectedMode.denominatorUnit,
                        variable: .denominator,
                        text: $denominatorInput
                    )

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

                    if !resultValue.isEmpty {
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
        .frame(minWidth: 720, minHeight: 720)
        .navigationTitle("Solution Concentration")
        .onChange(of: selectedMode) { _, _ in
            clearAll()
        }
        .onChange(of: unknownVariable) { _, _ in
            clearResult()
        }
    }

    @ViewBuilder
    private func valueField(
        title: String,
        symbol: String,
        unit: String,
        variable: ConcentrationUnknown,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(title) (\(symbol))")
                    .font(.headline)

                Spacer()

                Text(unit)
                    .foregroundStyle(.secondary)
            }

            if unknownVariable == variable {
                HStack {
                    Image(systemName: "function")
                        .foregroundStyle(.secondary)

                    Text("Calculated automatically")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, minHeight: 30)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.secondary.opacity(0.1))
                )
            } else {
                TextField(
                    "Enter \(title.lowercased())",
                    text: text
                )
                .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var resultCard: some View {
        VStack(spacing: 8) {
            Text(resultLabel)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(resultValue)
                .font(.system(size: 34, weight: .bold))

            Text(resultUnit)
                .font(.title3)
                .foregroundStyle(.secondary)
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
        case .concentration:
            guard
                let moles = parseNumber(molesInput),
                let denominator = parseNumber(denominatorInput)
            else {
                showInvalidInputError()
                return
            }

            guard moles >= 0, denominator > 0 else {
                showPositiveValueError()
                return
            }

            let concentration = moles / denominator

            showResult(
                value: concentration,
                label: selectedMode.rawValue,
                unit: selectedMode.concentrationUnit
            )

        case .moles:
            guard
                let concentration = parseNumber(concentrationInput),
                let denominator = parseNumber(denominatorInput)
            else {
                showInvalidInputError()
                return
            }

            guard concentration >= 0, denominator > 0 else {
                showPositiveValueError()
                return
            }

            let moles = concentration * denominator

            showResult(
                value: moles,
                label: "Amount of Solute",
                unit: "mol"
            )

        case .denominator:
            guard
                let concentration = parseNumber(concentrationInput),
                let moles = parseNumber(molesInput)
            else {
                showInvalidInputError()
                return
            }

            guard concentration > 0, moles >= 0 else {
                showPositiveValueError()
                return
            }

            let denominator = moles / concentration

            showResult(
                value: denominator,
                label: selectedMode.denominatorName,
                unit: selectedMode.denominatorUnit
            )
        }
    }

    private func parseNumber(_ text: String) -> Double? {
        let normalizedText = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        return Double(normalizedText)
    }

    private func showResult(
        value: Double,
        label: String,
        unit: String
    ) {
        resultValue = value.formatted(
            .number.precision(.significantDigits(1...8))
        )

        resultLabel = label
        resultUnit = unit
    }

    private func showInvalidInputError() {
        errorMessage =
            "Please enter valid numerical values in all required fields."
    }

    private func showPositiveValueError() {
        errorMessage =
            "Concentration must be non-negative, and volume or mass must be greater than zero."
    }

    private func clearResult() {
        resultValue = ""
        resultLabel = ""
        resultUnit = ""
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
