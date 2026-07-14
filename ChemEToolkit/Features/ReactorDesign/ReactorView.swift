import SwiftUI

struct ReactorView: View {
    @EnvironmentObject
    private var router: AppRouter

    @State
    private var reactorType:
        ReactorType = .batch

    @State
    private var calculation:
        ReactorCalculation = .conversion

    @State
    private var conversionFormat:
        ReactorConversionFormat = .fraction

    @State private var rateConstantInput = ""
    @State private var conversionInput = ""
    @State private var timeInput = ""
    @State private var spaceTimeInput = ""
    @State private var flowRateInput = ""

    @State
    private var solution: ReactorSolution?

    @State private var errorMessage = ""

    private let engine = ReactorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    private var availableCalculations:
        [ReactorCalculation] {
        ReactorCalculation.options(
            for: reactorType
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: reactorType.icon,
                    title:
                        "Reactor Design Calculator",
                    subtitle: "Batch, CSTR and PFR",
                    tint: .blue
                )

                reactorInformationCard

                CalculatorCard {
                    calculatorContent
                }

                comparisonButton
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
        .navigationTitle("Reactor Calculator")
        .onChange(of: reactorType) { _, newType in
            calculation =
                ReactorCalculation
                    .options(for: newType)
                    .first ?? .conversion

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

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Reactor Type")
                .font(.headline)

            Picker(
                "Reactor Type",
                selection: $reactorType
            ) {
                ForEach(
                    ReactorType.allCases
                ) { type in
                    Text(type.pickerTitle)
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
                ForEach(
                    availableCalculations
                ) { option in
                    Text(option.shortTitle)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)

            Text(
                "\(calculation.title) " +
                "(\(calculation.shortTitle)) " +
                "will be calculated."
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

    private var reactorInformationCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
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

                Text(
                    "First-order reaction: −rₐ = kCₐ"
                )
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
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth:
                AppTheme.Layout.calculatorMaxWidth
        )
    }

    private var comparisonButton: some View {
        Button {
            router.openModule(
                .reactorComparison
            )
        } label: {
            HStack(spacing: AppSpacing.medium) {
                Image(
                    systemName: "chart.bar.xaxis"
                )
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 36)
                .accessibilityHidden(true)

                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.xxSmall
                ) {
                    Text("Compare CSTR and PFR")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(
                        "Compare reactor volumes at the same conversion"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            .padding(AppSpacing.large)
            .frame(
                maxWidth:
                    AppTheme.Layout.calculatorMaxWidth
            )
            .background(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.large
                )
                .fill(
                    AppTheme.Colors.infoSurface
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.large
                )
                .stroke(
                    Color.blue.opacity(0.14),
                    lineWidth: 1
                )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(
            "Opens the CSTR and PFR comparison calculator"
        )
    }

    private var needsConversionInput: Bool {
        switch calculation {
        case .time,
             .rateConstant,
             .spaceTime,
             .volume:
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
                placeholder:
                    "Enter rate constant",
                text: $rateConstantInput
            )

            numberField(
                title: "Reaction Time",
                symbol: "t",
                unit: "min",
                placeholder:
                    "Enter reaction time",
                text: $timeInput
            )

        case .time:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder:
                    "Enter rate constant",
                text: $rateConstantInput
            )

            conversionField

        case .rateConstant:
            conversionField

            numberField(
                title: "Reaction Time",
                symbol: "t",
                unit: "min",
                placeholder:
                    "Enter reaction time",
                text: $timeInput
            )

        case .spaceTime, .volume:
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
                placeholder:
                    "Enter rate constant",
                text: $rateConstantInput
            )

            numberField(
                title: "Space Time",
                symbol: "τ",
                unit: "min",
                placeholder:
                    "Enter space time",
                text: $spaceTimeInput
            )

        case .spaceTime:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder:
                    "Enter rate constant",
                text: $rateConstantInput
            )

            conversionField

        case .volume:
            numberField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder:
                    "Enter rate constant",
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

        case .time, .rateConstant:
            EmptyView()
        }
    }

    private var conversionField: some View {
        numberField(
            title: "Conversion",
            symbol: "X",
            unit: conversionFormat.unit,
            placeholder:
                conversionFormat.placeholder,
            text: $conversionInput
        )
    }

    private func numberField(
        title: String,
        symbol: String,
        unit: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        CalculatorInputField(
            title: title,
            symbol: symbol,
            unit: unit,
            placeholder: placeholder,
            text: text
        )
    }

    private func resultItems(
        from solution: ReactorSolution
    ) -> [CalculationResultDisplayItem] {
        solution.items.map { item in
            CalculationResultDisplayItem(
                label:
                    item.variable.displayLabel,
                value:
                    formattedValue(for: item),
                unit: unit(for: item)
            )
        }
    }

    private func calculate() {
        clearResult()

        do {
            let input = try makeInput()

            solution = try engine.solve(
                reactorType: reactorType,
                calculation: calculation,
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
        -> ReactorInput {
        switch calculation {
        case .conversion:
            switch reactorType {
            case .batch:
                return ReactorInput(
                    rateConstant:
                        try parseNumber(
                            rateConstantInput,
                            fieldName:
                                "Rate Constant"
                        ),
                    conversion: nil,
                    time:
                        try parseNumber(
                            timeInput,
                            fieldName:
                                "Reaction Time"
                        ),
                    spaceTime: nil,
                    flowRate: nil
                )

            case .cstr, .pfr:
                return ReactorInput(
                    rateConstant:
                        try parseNumber(
                            rateConstantInput,
                            fieldName:
                                "Rate Constant"
                        ),
                    conversion: nil,
                    time: nil,
                    spaceTime:
                        try parseNumber(
                            spaceTimeInput,
                            fieldName:
                                "Space Time"
                        ),
                    flowRate: nil
                )
            }

        case .time:
            return ReactorInput(
                rateConstant:
                    try parseNumber(
                        rateConstantInput,
                        fieldName:
                            "Rate Constant"
                    ),
                conversion:
                    try parseConversion(),
                time: nil,
                spaceTime: nil,
                flowRate: nil
            )

        case .rateConstant:
            return ReactorInput(
                rateConstant: nil,
                conversion:
                    try parseConversion(),
                time:
                    try parseNumber(
                        timeInput,
                        fieldName:
                            "Reaction Time"
                    ),
                spaceTime: nil,
                flowRate: nil
            )

        case .spaceTime:
            return ReactorInput(
                rateConstant:
                    try parseNumber(
                        rateConstantInput,
                        fieldName:
                            "Rate Constant"
                    ),
                conversion:
                    try parseConversion(),
                time: nil,
                spaceTime: nil,
                flowRate: nil
            )

        case .volume:
            return ReactorInput(
                rateConstant:
                    try parseNumber(
                        rateConstantInput,
                        fieldName:
                            "Rate Constant"
                    ),
                conversion:
                    try parseConversion(),
                time: nil,
                spaceTime: nil,
                flowRate:
                    try parseNumber(
                        flowRateInput,
                        fieldName:
                            "Volumetric Flow Rate"
                    )
            )
        }
    }

    private func parseNumber(
        _ text: String,
        fieldName: String
    ) throws -> Double {
        try InputValidator.parseNumber(
            text,
            fieldName: fieldName
        )
    }

    private func parseConversion() throws
        -> Double {
        let enteredValue =
            try InputValidator.parseNumber(
                conversionInput,
                fieldName: "Conversion"
            )

        let fraction =
            conversionFormat.fractionValue(
                from: enteredValue
            )

        guard fraction >= 0, fraction < 1 else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Conversion must be at least zero and less than one or 100%."
                )
        }

        return fraction
    }

    private func formattedValue(
        for item: ReactorResultItem
    ) -> String {
        let displayValue: Double

        if item.variable == .conversion {
            displayValue =
                conversionFormat.displayValue(
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
        for item: ReactorResultItem
    ) -> String {
        switch item.variable {
        case .conversion:
            switch conversionFormat {
            case .fraction:
                return "fraction"

            case .percentage:
                return "%"
            }

        case .time, .spaceTime:
            return "min"

        case .rateConstant:
            return "1/min"

        case .volume:
            return "L"
        }
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The reactor calculation could not be completed."

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
    .environmentObject(AppRouter())
}
