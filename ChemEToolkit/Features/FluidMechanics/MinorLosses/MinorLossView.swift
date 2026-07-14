import SwiftUI

private struct LossCoefficientDraft:
    Identifiable,
    Equatable {

    let id: UUID
    var coefficientText: String

    init(
        id: UUID = UUID(),
        coefficientText: String = ""
    ) {
        self.id = id
        self.coefficientText =
            coefficientText
    }
}

struct MinorLossView: View {

    @State
    private var densityText = "998"

    @State
    private var velocityText = "3"

    @State
    private var gravityText = "9.80665"

    @State
    private var coefficientRows: [
        LossCoefficientDraft
    ] = [
        LossCoefficientDraft(
            coefficientText: "0.5"
        ),
        LossCoefficientDraft(
            coefficientText: "1"
        ),
        LossCoefficientDraft(
            coefficientText: "0.2"
        )
    ]

    @State
    private var calculationResult:
        MinorLossResult?

    @State
    private var errorMessage = ""

    private let engine =
        MinorLossEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.down.right.circle.fill",
                    title:
                        "Minor Losses",
                    subtitle:
                        "Calculate losses through fittings, valves and pipe components",
                    tint:
                        .orange
                )

                equationInformationCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity
            )
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
        .navigationTitle("Minor Losses")
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .orange
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Loss Coefficient Method")
                    .font(.headline)

                Text("hₘ = ΣK · v² / 2g")
                    .font(
                        .system(
                            size: 23,
                            weight: .semibold
                        )
                    )

                Text("ΔPₘ = ρghₘ")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text(
                    "Add the K value of each fitting, valve, entrance, exit or other local restriction."
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

    private var calculatorContent:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Fluid & Flow Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Fluid Density",
                symbol: "ρ",
                unit: "kg/m³",
                placeholder: "Example: 998",
                text: $densityText
            )

            EngineeringInputField(
                title:
                    "Average Flow Velocity",
                symbol: "v",
                unit: "m/s",
                placeholder: "Example: 3",
                text: $velocityText
            )

            Divider()

            coefficientSection

            DisclosureGroup(
                "Advanced Inputs"
            ) {
                EngineeringInputField(
                    title:
                        "Gravitational Acceleration",
                    symbol: "g",
                    unit: "m/s²",
                    placeholder:
                        "Example: 9.80665",
                    text: $gravityText
                )
                .padding(
                    .top,
                    AppSpacing.medium
                )
            }
            .font(.headline)

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Minor Losses",
                systemImage:
                    "equal.circle",
                action:
                    calculate
            )

            if let calculationResult {
                resultSection(
                    calculationResult
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var coefficientSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing:
                        AppSpacing.xxSmall
                ) {
                    Text("Loss Coefficients")
                        .font(.headline)

                    Text(
                        "Enter one K value per component."
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()

                Text(
                    "\(coefficientRows.count) components"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            ForEach(
                Array(
                    coefficientRows
                        .enumerated()
                ),
                id: \.element.id
            ) { index, row in
                coefficientRow(
                    index: index,
                    rowID: row.id,
                    text:
                        $coefficientRows[
                            index
                        ]
                        .coefficientText
                )
            }

            Button {
                coefficientRows.append(
                    LossCoefficientDraft()
                )

                clearResult()
            } label: {
                Label(
                    "Add Coefficient",
                    systemImage: "plus"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    private func coefficientRow(
        index: Int,
        rowID: UUID,
        text: Binding<String>
    ) -> some View {

        HStack(
            spacing: AppSpacing.small
        ) {
            Text("K\(index + 1)")
                .font(
                    .subheadline
                        .monospacedDigit()
                )
                .foregroundStyle(.secondary)
                .frame(width: 34)

            TextField(
                "Loss coefficient",
                text: text
            )
            .textFieldStyle(.roundedBorder)
            .engineeringNumberKeyboard()
            .accessibilityLabel(
                "Loss coefficient \(index + 1)"
            )

            Button {
                removeCoefficient(
                    rowID
                )
            } label: {
                Image(systemName: "trash")
                    .frame(
                        width: 32,
                        height: 32
                    )
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.red)
            .disabled(
                coefficientRows.count <= 1
            )
        }
        .padding(AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.medium
            )
            .fill(
                AppTheme.Colors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.medium
            )
            .stroke(
                AppTheme.Colors.border,
                lineWidth: 1
            )
        )
    }

    private var actionButtons:
        some View {

        ViewThatFits(
            in: .horizontal
        ) {
            HStack(
                spacing: AppSpacing.small
            ) {
                loadExampleButton
                clearButton
            }

            VStack(
                spacing: AppSpacing.small
            ) {
                loadExampleButton
                clearButton
            }
        }
    }

    private var loadExampleButton:
        some View {

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

    private var clearButton:
        some View {

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
        _ result: MinorLossResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Minor Head Loss",
                        value:
                            numberFormatter.format(
                                result.headLoss
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Drop",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureDropKilopascals
                            ),
                        unit: "kPa"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Loss Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .totalLossCoefficient
                            ),
                        unit: "ΣK"
                    )
                ]
            )

            CalculatorInfoCard(
                tint: .orange
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Components",
                        value:
                            "\(result.fittingCount)"
                    )

                    informationRow(
                        title:
                            "Velocity head",
                        value:
                            numberFormatter.format(
                                result.velocityHead,
                                unit: "m"
                            )
                    )
                }
            }
        }
    }

    private func informationRow(
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
            calculationResult =
                try engine.solve(
                    input:
                        try makeInput()
                )
        } catch let error
            as CalculationError {

            showCalculationError(error)
        } catch let error
            as MinorLossError {

            errorMessage =
                error.errorDescription
                ?? "The minor loss could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> MinorLossInput {

        let coefficients =
            try coefficientRows
                .enumerated()
                .map { index, row in
                    let value =
                        try InputValidator
                            .parseNumber(
                                row
                                    .coefficientText,
                                fieldName:
                                    "Loss Coefficient \(index + 1)"
                            )

                    return try InputValidator
                        .requireNonNegative(
                            value,
                            fieldName:
                                "Loss Coefficient \(index + 1)"
                        )
                }

        return MinorLossInput(
            density:
                try parsePositive(
                    densityText,
                    fieldName:
                        "Fluid Density"
                ),
            averageVelocity:
                try parseNonNegative(
                    velocityText,
                    fieldName:
                        "Average Flow Velocity"
                ),
            lossCoefficients:
                coefficients,
            gravity:
                try parsePositive(
                    gravityText,
                    fieldName:
                        "Gravitational Acceleration"
                )
        )
    }

    private func parsePositive(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let value =
            try InputValidator
                .parseNumber(
                    text,
                    fieldName: fieldName
                )

        return try InputValidator
            .requirePositive(
                value,
                fieldName: fieldName
            )
    }

    private func parseNonNegative(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let value =
            try InputValidator
                .parseNumber(
                    text,
                    fieldName: fieldName
                )

        return try InputValidator
            .requireNonNegative(
                value,
                fieldName: fieldName
            )
    }

    private func removeCoefficient(
        _ rowID: UUID
    ) {
        guard
            coefficientRows.count > 1
        else {
            return
        }

        coefficientRows.removeAll {
            $0.id == rowID
        }

        clearResult()
    }

    private func loadExample() {
        densityText = "998"
        velocityText = "3"
        gravityText = "9.80665"

        coefficientRows = [
            LossCoefficientDraft(
                coefficientText: "0.5"
            ),
            LossCoefficientDraft(
                coefficientText: "1"
            ),
            LossCoefficientDraft(
                coefficientText: "0.2"
            )
        ]

        clearResult()
    }

    private func resetInputs() {
        densityText = ""
        velocityText = ""
        gravityText = ""

        coefficientRows = [
            LossCoefficientDraft()
        ]

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The inputs could not be processed."

        if let suggestion =
            error.recoverySuggestion {
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
}

#Preview {
    NavigationStack {
        MinorLossView()
    }
}
