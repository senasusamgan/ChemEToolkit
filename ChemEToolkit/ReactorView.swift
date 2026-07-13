import SwiftUI

enum ReactorType: String, CaseIterable, Identifiable {
    case batch = "Batch"
    case cstr = "CSTR"
    case pfr = "PFR"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .batch:
            return "Batch Reactor"

        case .cstr:
            return "Continuous Stirred-Tank Reactor"

        case .pfr:
            return "Plug Flow Reactor"
        }
    }

    var subtitle: String {
        switch self {
        case .batch:
            return "Closed, unsteady-state reactor"

        case .cstr:
            return "Steady-state, perfectly mixed reactor"

        case .pfr:
            return "Steady-state tubular reactor"
        }
    }

    var icon: String {
        switch self {
        case .batch:
            return "flask.fill"

        case .cstr:
            return "arrow.triangle.2.circlepath"

        case .pfr:
            return "arrow.right.to.line"
        }
    }

    var equation: String {
        switch self {
        case .batch:
            return "X = 1 − e^(−kt)"

        case .cstr:
            return "X = kτ / (1 + kτ)"

        case .pfr:
            return "X = 1 − e^(−kτ)"
        }
    }
}

enum ReactorCalculation: String, Identifiable {
    case conversion = "Conversion"
    case time = "Reaction Time"
    case rateConstant = "Rate Constant"
    case spaceTime = "Space Time"
    case volume = "Reactor Volume"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .conversion:
            return "X"

        case .time:
            return "t"

        case .rateConstant:
            return "k"

        case .spaceTime:
            return "τ"

        case .volume:
            return "V"
        }
    }

    static func options(
        for reactorType: ReactorType
    ) -> [ReactorCalculation] {
        switch reactorType {
        case .batch:
            return [
                .conversion,
                .time,
                .rateConstant
            ]

        case .cstr, .pfr:
            return [
                .conversion,
                .spaceTime,
                .volume
            ]
        }
    }
}

enum ReactorConversionFormat: String, CaseIterable, Identifiable {
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

struct ReactorResult: Identifiable {
    let id = UUID()
    let label: String
    let value: String
    let unit: String
}

struct ReactorView: View {
    @State private var reactorType: ReactorType = .batch
    @State private var calculation: ReactorCalculation = .conversion

    @State private var conversionFormat:
        ReactorConversionFormat = .fraction

    @State private var rateConstantInput = ""
    @State private var conversionInput = ""
    @State private var timeInput = ""
    @State private var spaceTimeInput = ""
    @State private var flowRateInput = ""

    @State private var results: [ReactorResult] = []
    @State private var errorMessage = ""

    private var availableCalculations: [ReactorCalculation] {
        ReactorCalculation.options(for: reactorType)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: reactorType.icon)
                    .font(.system(size: 54))
                    .foregroundStyle(.blue)

                Text("Reactor Design Calculator")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Batch, CSTR and PFR")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                reactorInformationCard

                VStack(alignment: .leading, spacing: 20) {
                    Text("Reactor Type")
                        .font(.headline)

                    Picker(
                        "Reactor Type",
                        selection: $reactorType
                    ) {
                        ForEach(ReactorType.allCases) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    Text("Calculate")
                        .font(.headline)

                    Picker(
                        "Calculate",
                        selection: $calculation
                    ) {
                        ForEach(availableCalculations) { option in
                            Text(option.shortTitle)
                                .tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(
                        "\(calculation.rawValue) "
                        + "(\(calculation.shortTitle)) "
                        + "will be calculated."
                    )
                    .foregroundStyle(.secondary)

                    if needsConversionInput {
                        Divider()

                        Text("Conversion Input Format")
                            .font(.headline)

                        Picker(
                            "Conversion Input Format",
                            selection: $conversionFormat
                        ) {
                            ForEach(
                                ReactorConversionFormat.allCases
                            ) { format in
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
                            systemImage:
                                "exclamationmark.triangle.fill"
                        )
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(24)
                .frame(maxWidth: 640)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.quaternary)
                )

                NavigationLink {
                    ReactorComparisonView()
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.title2)
                            .foregroundStyle(.blue)
                            .frame(width: 36)

                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {
                            Text("Compare CSTR and PFR")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text(
                                "Compare reactor volumes "
                                + "at the same conversion"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding(18)
                    .frame(maxWidth: 640)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue.opacity(0.1))
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(40)
        }
        .frame(minWidth: 760, minHeight: 780)
        .navigationTitle("Reactor Calculator")
        .onChange(of: reactorType) { _, newType in
            calculation =
                ReactorCalculation.options(
                    for: newType
                )[0]

            clearAll()
        }
        .onChange(of: calculation) { _, _ in
            clearResult()
        }
        .onChange(of: conversionFormat) { _, _ in
            conversionInput = ""
            clearResult()
        }
    }

    private var reactorInformationCard: some View {
        VStack(spacing: 10) {
            Text(reactorType.title)
                .font(.headline)

            Text(reactorType.subtitle)
                .foregroundStyle(.secondary)

            Text(reactorType.equation)
                .font(
                    .system(
                        size: 26,
                        weight: .semibold
                    )
                )

            Text("First-order reaction: −rₐ = kCₐ")
                .foregroundStyle(.secondary)

            if reactorType != .batch {
                Text("V = v₀τ")
                    .font(
                        .system(
                            size: 21,
                            weight: .medium
                        )
                    )
            }
        }
        .frame(maxWidth: 640)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.blue.opacity(0.08))
        )
    }

    private var needsConversionInput: Bool {
        switch calculation {
        case .time, .rateConstant, .spaceTime, .volume:
            return true

        case .conversion:
            return false
        }
    }

    @ViewBuilder
    private var requiredFields: some View {
        switch reactorType {
        case .batch:
            batchFields

        case .cstr, .pfr:
            flowReactorFields
        }
    }

    @ViewBuilder
    private var batchFields: some View {
        switch calculation {
        case .conversion:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder: "Enter rate constant",
                text: $rateConstantInput
            )

            numberField(
                title: "Reaction Time",
                symbol: "t",
                unit: "min",
                placeholder: "Enter reaction time",
                text: $timeInput
            )

        case .time:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder: "Enter rate constant",
                text: $rateConstantInput
            )

            conversionField

        case .rateConstant:
            conversionField

            numberField(
                title: "Reaction Time",
                symbol: "t",
                unit: "min",
                placeholder: "Enter reaction time",
                text: $timeInput
            )

        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var flowReactorFields: some View {
        switch calculation {
        case .conversion:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder: "Enter rate constant",
                text: $rateConstantInput
            )

            numberField(
                title: "Space Time",
                symbol: "τ",
                unit: "min",
                placeholder: "Enter space time",
                text: $spaceTimeInput
            )

        case .spaceTime:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder: "Enter rate constant",
                text: $rateConstantInput
            )

            conversionField

        case .volume:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder: "Enter rate constant",
                text: $rateConstantInput
            )

            conversionField

            numberField(
                title: "Volumetric Flow Rate",
                symbol: "v₀",
                unit: "L/min",
                placeholder:
                    "Enter inlet volumetric flow rate",
                text: $flowRateInput
            )

        default:
            EmptyView()
        }
    }

    private var conversionField: some View {
        numberField(
            title: "Conversion",
            symbol: "X",
            unit: conversionFormat.unit,
            placeholder: conversionPlaceholder,
            text: $conversionInput
        )
    }

    private var conversionPlaceholder: String {
        switch conversionFormat {
        case .fraction:
            return "Enter a value from 0 to less than 1"

        case .percentage:
            return "Enter a value from 0 to less than 100"
        }
    }

    private func numberField(
        title: String,
        symbol: String,
        unit: String,
        placeholder: String,
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

            TextField(
                placeholder,
                text: text
            )
            .textFieldStyle(.roundedBorder)
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
                        .font(
                            .system(
                                size: 32,
                                weight: .bold
                            )
                        )

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

        switch reactorType {
        case .batch:
            calculateBatch()

        case .cstr:
            calculateCSTR()

        case .pfr:
            calculatePFR()
        }
    }

    private func calculateBatch() {
        switch calculation {
        case .conversion:
            guard
                let rateConstant =
                    parseNumber(rateConstantInput),
                let time = parseNumber(timeInput)
            else {
                showInvalidInputError()
                return
            }

            guard rateConstant > 0, time >= 0 else {
                showPositiveInputError()
                return
            }

            let conversion =
                1 - exp(-rateConstant * time)

            showConversionResult(conversion)

        case .time:
            guard
                let rateConstant =
                    parseNumber(rateConstantInput),
                let conversion =
                    parseConversion(conversionInput)
            else {
                showInvalidInputError()
                return
            }

            guard rateConstant > 0 else {
                showPositiveInputError()
                return
            }

            let time =
                -log(1 - conversion) / rateConstant

            results = [
                makeResult(
                    label: "Reaction Time (t)",
                    value: time,
                    unit: "min"
                )
            ]

        case .rateConstant:
            guard
                let conversion =
                    parseConversion(conversionInput),
                let time = parseNumber(timeInput)
            else {
                showInvalidInputError()
                return
            }

            guard time > 0 else {
                errorMessage =
                    "Reaction time must be greater than zero."
                return
            }

            let rateConstant =
                -log(1 - conversion) / time

            results = [
                makeResult(
                    label: "Rate Constant (k)",
                    value: rateConstant,
                    unit: "1/min"
                )
            ]

        default:
            break
        }
    }

    private func calculatePFR() {
        switch calculation {
        case .conversion:
            guard
                let rateConstant =
                    parseNumber(rateConstantInput),
                let spaceTime =
                    parseNumber(spaceTimeInput)
            else {
                showInvalidInputError()
                return
            }

            guard rateConstant > 0, spaceTime >= 0 else {
                showPositiveInputError()
                return
            }

            let conversion =
                1 - exp(-rateConstant * spaceTime)

            showConversionResult(conversion)

        case .spaceTime:
            guard
                let rateConstant =
                    parseNumber(rateConstantInput),
                let conversion =
                    parseConversion(conversionInput)
            else {
                showInvalidInputError()
                return
            }

            guard rateConstant > 0 else {
                showPositiveInputError()
                return
            }

            let spaceTime =
                -log(1 - conversion) / rateConstant

            results = [
                makeResult(
                    label: "Space Time (τ)",
                    value: spaceTime,
                    unit: "min"
                )
            ]

        case .volume:
            calculateFlowReactorVolume(
                isCSTR: false
            )

        default:
            break
        }
    }

    private func calculateCSTR() {
        switch calculation {
        case .conversion:
            guard
                let rateConstant =
                    parseNumber(rateConstantInput),
                let spaceTime =
                    parseNumber(spaceTimeInput)
            else {
                showInvalidInputError()
                return
            }

            guard rateConstant > 0, spaceTime >= 0 else {
                showPositiveInputError()
                return
            }

            let rateTimeProduct =
                rateConstant * spaceTime

            let conversion =
                rateTimeProduct /
                (1 + rateTimeProduct)

            showConversionResult(conversion)

        case .spaceTime:
            guard
                let rateConstant =
                    parseNumber(rateConstantInput),
                let conversion =
                    parseConversion(conversionInput)
            else {
                showInvalidInputError()
                return
            }

            guard rateConstant > 0 else {
                showPositiveInputError()
                return
            }

            let spaceTime =
                conversion /
                (
                    rateConstant
                    * (1 - conversion)
                )

            results = [
                makeResult(
                    label: "Space Time (τ)",
                    value: spaceTime,
                    unit: "min"
                )
            ]

        case .volume:
            calculateFlowReactorVolume(
                isCSTR: true
            )

        default:
            break
        }
    }

    private func calculateFlowReactorVolume(
        isCSTR: Bool
    ) {
        guard
            let rateConstant =
                parseNumber(rateConstantInput),
            let conversion =
                parseConversion(conversionInput),
            let flowRate =
                parseNumber(flowRateInput)
        else {
            showInvalidInputError()
            return
        }

        guard rateConstant > 0, flowRate > 0 else {
            showPositiveInputError()
            return
        }

        let spaceTime: Double

        if isCSTR {
            spaceTime =
                conversion /
                (
                    rateConstant
                    * (1 - conversion)
                )
        } else {
            spaceTime =
                -log(1 - conversion)
                / rateConstant
        }

        let reactorVolume =
            flowRate * spaceTime

        results = [
            makeResult(
                label: "Space Time (τ)",
                value: spaceTime,
                unit: "min"
            ),
            makeResult(
                label: "Reactor Volume (V)",
                value: reactorVolume,
                unit: "L"
            )
        ]
    }

    private func parseNumber(
        _ text: String
    ) -> Double? {
        let normalizedText = text
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .replacingOccurrences(
                of: ",",
                with: "."
            )

        return Double(normalizedText)
    }

    private func parseConversion(
        _ text: String
    ) -> Double? {
        guard let enteredValue = parseNumber(text) else {
            return nil
        }

        let fraction: Double

        switch conversionFormat {
        case .fraction:
            fraction = enteredValue

        case .percentage:
            fraction = enteredValue / 100
        }

        guard fraction >= 0, fraction < 1 else {
            return nil
        }

        return fraction
    }

    private func showConversionResult(
        _ conversion: Double
    ) {
        switch conversionFormat {
        case .fraction:
            results = [
                makeResult(
                    label: "Conversion (X)",
                    value: conversion,
                    unit: "fraction"
                )
            ]

        case .percentage:
            results = [
                makeResult(
                    label: "Conversion (X)",
                    value: conversion * 100,
                    unit: "%"
                )
            ]
        }
    }

    private func makeResult(
        label: String,
        value: Double,
        unit: String
    ) -> ReactorResult {
        ReactorResult(
            label: label,
            value: formatNumber(value),
            unit: unit
        )
    }

    private func formatNumber(
        _ value: Double
    ) -> String {
        value.formatted(
            .number.precision(
                .significantDigits(1...8)
            )
        )
    }

    private func showInvalidInputError() {
        errorMessage =
            "Please enter valid numerical values. "
            + "Conversion must be at least zero "
            + "and less than one or 100%."
    }

    private func showPositiveInputError() {
        errorMessage =
            "Rate constant and flow rate must be "
            + "greater than zero. Time cannot be negative."
    }

    private func clearResult() {
        results = []
        errorMessage = ""
    }

    private func clearAll() {
        rateConstantInput = ""
        conversionInput = ""
        timeInput = ""
        spaceTimeInput = ""
        flowRateInput = ""

        clearResult()
    }
}

#Preview {
    NavigationStack {
        ReactorView()
    }
}
