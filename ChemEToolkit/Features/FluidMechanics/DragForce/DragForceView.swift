import SwiftUI

struct DragForceView: View {

    @State private var densityText = "1.225"
    @State private var velocityText = "20"
    @State private var areaText = "0.5"
    @State private var dragCoefficientText = "0.8"

    @State private var calculationResult: DragForceResult?
    @State private var errorMessage = ""

    private let engine = DragForceEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title: "Drag Force",
                    subtitle:
                        "Calculate fluid drag force and associated power",
                    tint: .purple
                )

                equationInformationCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(maxWidth: .infinity)
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Drag Force")
    }

    private var equationInformationCard: some View {
        CalculatorInfoCard(tint: .purple) {
            VStack(spacing: AppSpacing.small) {
                Text("Drag Equation")
                    .font(.headline)

                Text("Fᴅ = ½ρv²CᴅA")
                    .font(
                        .system(
                            size: 25,
                            weight: .semibold
                        )
                    )

                Text("q = ½ρv²")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )

                Text(
                    "Velocity is the relative velocity between the object and surrounding fluid."
                )
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
            Text("Fluid & Object Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Fluid Density",
                symbol: "ρ",
                unit: "kg/m³",
                placeholder: "Example: 1.225",
                text: $densityText
            )

            EngineeringInputField(
                title: "Relative Velocity",
                symbol: "v",
                unit: "m/s",
                placeholder: "Example: 20",
                text: $velocityText
            )

            EngineeringInputField(
                title: "Projected Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 0.5",
                text: $areaText
            )

            EngineeringInputField(
                title: "Drag Coefficient",
                symbol: "Cᴅ",
                unit: "",
                placeholder: "Example: 0.8",
                text: $dragCoefficientText
            )

            actionButtons

            PrimaryActionButton(
                title: "Calculate Drag Force",
                systemImage: "equal.circle",
                action: calculate
            )

            if let calculationResult {
                resultSection(calculationResult)
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
                systemImage: "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result: DragForceResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Drag Force",
                        value: numberFormatter.format(
                            result.dragForce
                        ),
                        unit: "N"
                    ),
                    CalculationResultDisplayItem(
                        label: "Drag Power",
                        value: numberFormatter.format(
                            result.dragPowerKilowatts
                        ),
                        unit: "kW"
                    ),
                    CalculationResultDisplayItem(
                        label: "Dynamic Pressure",
                        value: numberFormatter.format(
                            result.dynamicPressure
                        ),
                        unit: "Pa"
                    )
                ]
            )

            CalculatorInfoCard(tint: .purple) {
                VStack(spacing: AppSpacing.small) {
                    informationRow(
                        title: "Force per unit area",
                        value: numberFormatter.format(
                            result.forcePerUnitArea,
                            unit: "Pa"
                        )
                    )

                    informationRow(
                        title: "Relative velocity",
                        value: numberFormatter.format(
                            result.relativeVelocity,
                            unit: "m/s"
                        )
                    )

                    informationRow(
                        title: "Projected area",
                        value: numberFormatter.format(
                            result.projectedArea,
                            unit: "m²"
                        )
                    )

                    informationRow(
                        title: "Drag coefficient",
                        value: numberFormatter.format(
                            result.dragCoefficient
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
            calculationResult = try engine.solve(
                input: try makeInput()
            )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch let error as DragForceError {
            errorMessage =
                error.errorDescription
                ?? "The drag force could not be calculated."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func makeInput() throws
        -> DragForceInput {

        DragForceInput(
            fluidDensity: try parsePositive(
                densityText,
                fieldName: "Fluid Density"
            ),
            relativeVelocity: try parseNonNegative(
                velocityText,
                fieldName: "Relative Velocity"
            ),
            projectedArea: try parsePositive(
                areaText,
                fieldName: "Projected Area"
            ),
            dragCoefficient: try parseNonNegative(
                dragCoefficientText,
                fieldName: "Drag Coefficient"
            )
        )
    }

    private func parsePositive(
        _ text: String,
        fieldName: String
    ) throws -> Double {
        let value = try InputValidator.parseNumber(
            text,
            fieldName: fieldName
        )

        return try InputValidator.requirePositive(
            value,
            fieldName: fieldName
        )
    }

    private func parseNonNegative(
        _ text: String,
        fieldName: String
    ) throws -> Double {
        let value = try InputValidator.parseNumber(
            text,
            fieldName: fieldName
        )

        return try InputValidator.requireNonNegative(
            value,
            fieldName: fieldName
        )
    }

    private func loadExample() {
        densityText = "1.225"
        velocityText = "20"
        areaText = "0.5"
        dragCoefficientText = "0.8"

        clearResult()
    }

    private func resetInputs() {
        densityText = ""
        velocityText = ""
        areaText = ""
        dragCoefficientText = ""

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
        DragForceView()
    }
}
