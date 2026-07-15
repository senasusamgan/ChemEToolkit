import SwiftUI

struct OverallHeatTransferCoefficientView: View {

    @State
    private var hotSideCoefficientInput = "100"

    @State
    private var coldSideCoefficientInput = "50"

    @State
    private var wallConductivityInput = "10"

    @State
    private var wallThicknessInput = "0.02"

    @State
    private var hotSideFoulingInput = "0.001"

    @State
    private var coldSideFoulingInput = "0.002"

    @State
    private var result:
        OverallHeatTransferCoefficientResult?

    @State
    private var errorMessage = ""

    private let engine =
        OverallHeatTransferCoefficientEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "rectangle.split.3x1.fill",
                    title:
                        "Overall Heat Transfer Coefficient",
                    subtitle:
                        "Combine convection, conduction and fouling resistances",
                    tint: .orange
                )

                formulaCard

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
        .navigationTitle(
            "Overall Heat Transfer Coefficient"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Series Thermal Resistance")
                    .font(.headline)

                Text(
                    "1/U = 1/hₕ + Rᶠₕ + L/k + Rᶠ𝚌 + 1/h𝚌"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)

                Text(
                    """
                    Calculates an area-based overall \
                    heat-transfer coefficient by combining \
                    convection, wall conduction and fouling.
                    """
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Assumes the same reference area is used \
                    for every resistance.
                    """
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth:
                AppTheme.Layout.calculatorMaxWidth
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Convection Coefficients")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Hot-Side Coefficient",
                symbol: "hₕ",
                unit: "W/(m²·K)",
                placeholder: "Example: 100",
                text:
                    $hotSideCoefficientInput
            )

            EngineeringInputField(
                title:
                    "Cold-Side Coefficient",
                symbol: "h𝚌",
                unit: "W/(m²·K)",
                placeholder: "Example: 50",
                text:
                    $coldSideCoefficientInput
            )

            Divider()

            Text("Wall Properties")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Wall Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 10",
                text:
                    $wallConductivityInput
            )

            EngineeringInputField(
                title: "Wall Thickness",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.02",
                text:
                    $wallThicknessInput
            )

            Divider()

            Text("Fouling Resistances")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Hot-Side Fouling Resistance",
                symbol: "Rᶠₕ",
                unit: "m²·K/W",
                placeholder: "Example: 0.001",
                text:
                    $hotSideFoulingInput
            )

            EngineeringInputField(
                title:
                    "Cold-Side Fouling Resistance",
                symbol: "Rᶠ𝚌",
                unit: "m²·K/W",
                placeholder: "Example: 0.002",
                text:
                    $coldSideFoulingInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Overall Coefficient",
                systemImage:
                    "rectangle.split.3x1.fill",
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
        Button {
            loadExample()
        } label: {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button {
            resetInputs()
        } label: {
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
            OverallHeatTransferCoefficientResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Overall Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .overallHeatTransferCoefficient
                            ),
                        unit: "W/(m²·K)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .totalResistancePerUnitArea
                            ),
                        unit: "m²·K/W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Hot Convection Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .hotSideConvectionResistance
                            ),
                        unit: "m²·K/W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Cold Convection Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .coldSideConvectionResistance
                            ),
                        unit: "m²·K/W"
                    )
                ],
                tint: .orange
            )

            resistanceBreakdownCard(result)
        }
    }

    private func resistanceBreakdownCard(
        _ result:
            OverallHeatTransferCoefficientResult
    ) -> some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.medium
            ) {
                Label(
                    "Resistance Breakdown",
                    systemImage: "chart.bar.fill"
                )
                .font(.headline)

                Divider()

                resistanceRow(
                    title: "Hot-Side Convection",
                    value:
                        result
                            .hotSideConvectionResistance,
                    total:
                        result
                            .totalResistancePerUnitArea
                )

                resistanceRow(
                    title: "Hot-Side Fouling",
                    value:
                        result
                            .hotSideFoulingResistance,
                    total:
                        result
                            .totalResistancePerUnitArea
                )

                resistanceRow(
                    title: "Wall Conduction",
                    value:
                        result
                            .wallConductionResistance,
                    total:
                        result
                            .totalResistancePerUnitArea
                )

                resistanceRow(
                    title: "Cold-Side Fouling",
                    value:
                        result
                            .coldSideFoulingResistance,
                    total:
                        result
                            .totalResistancePerUnitArea
                )

                resistanceRow(
                    title: "Cold-Side Convection",
                    value:
                        result
                            .coldSideConvectionResistance,
                    total:
                        result
                            .totalResistancePerUnitArea
                )

                Divider()

                HStack {
                    Text("Dominant Resistance")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(
                        dominantResistance(
                            in: result
                        )
                    )
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                }

                Text(
                    """
                    Reducing the largest resistance usually \
                    provides the greatest improvement in the \
                    overall heat-transfer coefficient.
                    """
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }

    private func resistanceRow(
        title: String,
        value: Double,
        total: Double
    ) -> some View {
        HStack(
            alignment: .firstTextBaseline,
            spacing: AppSpacing.medium
        ) {
            VStack(alignment: .leading) {
                Text(title)

                Text(
                    "\(numberFormatter.format(100 * value / total))%"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Text(
                "\(numberFormatter.format(value)) m²·K/W"
            )
            .fontWeight(.semibold)
            .multilineTextAlignment(.trailing)
        }
    }

    private func dominantResistance(
        in result:
            OverallHeatTransferCoefficientResult
    ) -> String {
        let components: [(String, Double)] = [
            (
                "Hot-side convection",
                result.hotSideConvectionResistance
            ),
            (
                "Hot-side fouling",
                result.hotSideFoulingResistance
            ),
            (
                "Wall conduction",
                result.wallConductionResistance
            ),
            (
                "Cold-side fouling",
                result.coldSideFoulingResistance
            ),
            (
                "Cold-side convection",
                result.coldSideConvectionResistance
            )
        ]

        return components.max {
            first,
            second in

            first.1 < second.1
        }?.0 ?? "—"
    }

    private func calculate() {
        clearResult()

        do {
            let input = try makeInput()

            result =
                try engine.calculate(
                    input: input
                )
        } catch let error
            as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> OverallHeatTransferCoefficientInput {

        let hotSideCoefficient =
            try InputValidator.parseNumber(
                hotSideCoefficientInput,
                fieldName:
                    "hot-side heat-transfer coefficient"
            )

        let coldSideCoefficient =
            try InputValidator.parseNumber(
                coldSideCoefficientInput,
                fieldName:
                    "cold-side heat-transfer coefficient"
            )

        let wallConductivity =
            try InputValidator.parseNumber(
                wallConductivityInput,
                fieldName:
                    "wall thermal conductivity"
            )

        let wallThickness =
            try InputValidator.parseNumber(
                wallThicknessInput,
                fieldName:
                    "wall thickness"
            )

        let hotSideFouling =
            try InputValidator.parseNumber(
                hotSideFoulingInput,
                fieldName:
                    "hot-side fouling resistance"
            )

        let coldSideFouling =
            try InputValidator.parseNumber(
                coldSideFoulingInput,
                fieldName:
                    "cold-side fouling resistance"
            )

        return OverallHeatTransferCoefficientInput(
            hotSideHeatTransferCoefficient:
                hotSideCoefficient,
            coldSideHeatTransferCoefficient:
                coldSideCoefficient,
            wallThermalConductivity:
                wallConductivity,
            wallThickness:
                wallThickness,
            hotSideFoulingResistance:
                hotSideFouling,
            coldSideFoulingResistance:
                coldSideFouling
        )
    }

    private func loadExample() {
        hotSideCoefficientInput = "100"
        coldSideCoefficientInput = "50"
        wallConductivityInput = "10"
        wallThicknessInput = "0.02"
        hotSideFoulingInput = "0.001"
        coldSideFoulingInput = "0.002"

        clearResult()
    }

    private func resetInputs() {
        hotSideCoefficientInput = ""
        coldSideCoefficientInput = ""
        wallConductivityInput = ""
        wallThicknessInput = ""
        hotSideFoulingInput = ""
        coldSideFoulingInput = ""

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
        OverallHeatTransferCoefficientView()
    }
}
