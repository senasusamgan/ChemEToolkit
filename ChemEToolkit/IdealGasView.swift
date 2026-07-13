import SwiftUI

enum GasVariable: String, CaseIterable, Identifiable {
    case pressure
    case volume
    case moles
    case temperature

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .pressure:
            return "P"
        case .volume:
            return "V"
        case .moles:
            return "n"
        case .temperature:
            return "T"
        }
    }

    var name: String {
        switch self {
        case .pressure:
            return "Pressure"
        case .volume:
            return "Volume"
        case .moles:
            return "Amount of Substance"
        case .temperature:
            return "Temperature"
        }
    }

    var unit: String {
        switch self {
        case .pressure:
            return "kPa"
        case .volume:
            return "L"
        case .moles:
            return "mol"
        case .temperature:
            return "K"
        }
    }
}

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

    private let gasConstant = 8.314462618

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "flask.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.blue)

                Text("Ideal Gas Calculator")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("PV = nRT")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 20) {
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

                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Units used in this calculator")
                                .font(.headline)

                            Text("P: kPa   •   V: L   •   n: mol   •   T: K")
                                .foregroundStyle(.secondary)

                            Text("R = 8.314462618 L·kPa/(mol·K)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(0.08))
                    )

                    Divider()

                    valueField(
                        variable: .pressure,
                        text: $pressureInput
                    )

                    valueField(
                        variable: .volume,
                        text: $volumeInput
                    )

                    valueField(
                        variable: .moles,
                        text: $molesInput
                    )

                    valueField(
                        variable: .temperature,
                        text: $temperatureInput
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
        .navigationTitle("Ideal Gas Calculator")
        .onChange(of: unknownVariable) { _, _ in
            clearResult()
        }
    }

    @ViewBuilder
    private func valueField(
        variable: GasVariable,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(variable.name) (\(variable.symbol))")
                    .font(.headline)

                Spacer()

                Text(variable.unit)
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
                    "Enter \(variable.name.lowercased())",
                    text: text
                )
                .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var resultCard: some View {
        VStack(spacing: 8) {
            Text(resultName)
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
        case .pressure:
            guard
                let volume = parseNumber(volumeInput),
                let moles = parseNumber(molesInput),
                let temperature = parseNumber(temperatureInput)
            else {
                showInvalidInputError()
                return
            }

            guard volume > 0, moles > 0, temperature > 0 else {
                showPositiveValueError()
                return
            }

            let pressure =
                moles * gasConstant * temperature / volume

            showResult(
                value: pressure,
                variable: .pressure
            )

        case .volume:
            guard
                let pressure = parseNumber(pressureInput),
                let moles = parseNumber(molesInput),
                let temperature = parseNumber(temperatureInput)
            else {
                showInvalidInputError()
                return
            }

            guard pressure > 0, moles > 0, temperature > 0 else {
                showPositiveValueError()
                return
            }

            let volume =
                moles * gasConstant * temperature / pressure

            showResult(
                value: volume,
                variable: .volume
            )

        case .moles:
            guard
                let pressure = parseNumber(pressureInput),
                let volume = parseNumber(volumeInput),
                let temperature = parseNumber(temperatureInput)
            else {
                showInvalidInputError()
                return
            }

            guard pressure > 0, volume > 0, temperature > 0 else {
                showPositiveValueError()
                return
            }

            let moles =
                pressure * volume /
                (gasConstant * temperature)

            showResult(
                value: moles,
                variable: .moles
            )

        case .temperature:
            guard
                let pressure = parseNumber(pressureInput),
                let volume = parseNumber(volumeInput),
                let moles = parseNumber(molesInput)
            else {
                showInvalidInputError()
                return
            }

            guard pressure > 0, volume > 0, moles > 0 else {
                showPositiveValueError()
                return
            }

            let temperature =
                pressure * volume /
                (moles * gasConstant)

            showResult(
                value: temperature,
                variable: .temperature
            )
        }
    }

    private func parseNumber(
        _ text: String
    ) -> Double? {
        let normalizedText = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        return Double(normalizedText)
    }

    private func showResult(
        value: Double,
        variable: GasVariable
    ) {
        resultValue = value.formatted(
            .number.precision(.significantDigits(1...8))
        )

        resultName = "\(variable.name) (\(variable.symbol))"
        resultUnit = variable.unit
    }

    private func showInvalidInputError() {
        errorMessage =
            "Please enter valid numerical values in all required fields."
    }

    private func showPositiveValueError() {
        errorMessage =
            "Pressure, volume, amount and temperature must be greater than zero."
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
