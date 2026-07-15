import SwiftUI

struct ThermalResistanceNetworkView: View {

    @State
    private var arrangement:
        ThermalResistanceArrangement = .series

    @State
    private var branchCount = 3

    @State
    private var resistanceInputs = [
        "0.01",
        "0.02",
        "0.03",
        "0.04"
    ]

    @State
    private var hotTemperatureInput = "100"

    @State
    private var coldTemperatureInput = "20"

    @State
    private var result:
        ThermalResistanceNetworkResult?

    @State
    private var errorMessage = ""

    private let engine =
        ThermalResistanceNetworkEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "point.3.connected.trianglepath.dotted",
                    title:
                        "Thermal Resistance Network",
                    subtitle:
                        "Combine thermal resistances in series or parallel",
                    tint: .orange
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
            "Thermal Resistance Network"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Equivalent Resistance")
                    .font(.headline)

                Text(
                    arrangement == .series
                    ? "Rₑq = ΣRᵢ"
                    : "1/Rₑq = Σ(1/Rᵢ)"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )

                Text(
                    arrangement == .series
                    ? "The same heat rate passes through every series resistance."
                    : "Every parallel branch experiences the same temperature difference."
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

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Network Configuration")
                .font(.headline)

            Picker(
                "Arrangement",
                selection: $arrangement
            ) {
                ForEach(
                    ThermalResistanceArrangement
                        .allCases
                ) { option in
                    Text(option.title)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            Picker(
                "Branch Count",
                selection: $branchCount
            ) {
                ForEach(2...4, id: \.self) {
                    count in

                    Text("\(count)")
                        .tag(count)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            Divider()

            Text("Boundary Temperatures")
                .font(.headline)

            EngineeringInputField(
                title: "Hot-Side Temperature",
                symbol: "Tₕ",
                unit: "°C",
                placeholder: "Example: 100",
                text: $hotTemperatureInput
            )

            EngineeringInputField(
                title: "Cold-Side Temperature",
                symbol: "T𝚌",
                unit: "°C",
                placeholder: "Example: 20",
                text: $coldTemperatureInput
            )

            Divider()

            Text("Thermal Resistances")
                .font(.headline)

            ForEach(
                0..<branchCount,
                id: \.self
            ) { index in
                EngineeringInputField(
                    title:
                        "Resistance \(index + 1)",
                    symbol: "R\(index + 1)",
                    unit: "K/W",
                    placeholder:
                        "Example: \(index + 1)",
                    text:
                        bindingForResistance(
                            at: index
                        )
                )
            }

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Equivalent Network",
                systemImage:
                    "point.3.connected.trianglepath.dotted",
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

    private var actionButtons: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }

            VStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }
        }
    }

    private var loadExampleButton: some View {
        Button(action: loadExample) {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button(action: resetInputs) {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result:
            ThermalResistanceNetworkResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Equivalent Resistance",
                        value:
                            formatter.format(
                                result
                                    .equivalentResistance
                            ),
                        unit: "K/W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Heat Transfer Rate",
                        value:
                            formatter.format(
                                result
                                    .totalHeatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Temperature Difference",
                        value:
                            formatter.format(
                                result
                                    .temperatureDifference
                            ),
                        unit: "K"
                    )
                ],
                tint: .orange
            )

            ForEach(
                result.branchResults,
                id: \.branchNumber
            ) { branch in
                CalculatorInfoCard(tint: .orange) {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.small
                    ) {
                        Text(
                            "Resistance \(branch.branchNumber)"
                        )
                        .font(.headline)

                        Divider()

                        row(
                            title: "Resistance",
                            value:
                                "\(formatter.format(branch.resistance)) K/W"
                        )

                        row(
                            title:
                                "Branch Heat Rate",
                            value:
                                "\(formatter.format(branch.heatTransferRate)) W"
                        )

                        row(
                            title:
                                "Temperature Drop",
                            value:
                                "\(formatter.format(branch.temperatureDrop)) K"
                        )
                    }
                }
            }
        }
    }

    private func bindingForResistance(
        at index: Int
    ) -> Binding<String> {

        Binding(
            get: {
                resistanceInputs[index]
            },
            set: {
                resistanceInputs[index] = $0
            }
        )
    }

    private func row(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }

    private func calculate() {
        clearResult()

        do {
            let resistances =
                try (0..<branchCount).map {
                    index in

                    try InputValidator.parseNumber(
                        resistanceInputs[index],
                        fieldName:
                            "resistance \(index + 1)"
                    )
                }

            result = try engine.calculate(
                input:
                    ThermalResistanceNetworkInput(
                        arrangement: arrangement,
                        hotSideTemperature:
                            try InputValidator.parseNumber(
                                hotTemperatureInput,
                                fieldName:
                                    "hot-side temperature"
                            ),
                        coldSideTemperature:
                            try InputValidator.parseNumber(
                                coldTemperatureInput,
                                fieldName:
                                    "cold-side temperature"
                            ),
                        resistances: resistances
                    )
            )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        arrangement = .series
        branchCount = 3
        resistanceInputs = [
            "0.01",
            "0.02",
            "0.03",
            "0.04"
        ]
        hotTemperatureInput = "100"
        coldTemperatureInput = "20"
        clearResult()
    }

    private func resetInputs() {
        resistanceInputs = [
            "",
            "",
            "",
            ""
        ]
        hotTemperatureInput = ""
        coldTemperatureInput = ""
        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The entered values could not be processed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ThermalResistanceNetworkView()
    }
}
