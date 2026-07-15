import SwiftUI

struct DistributionCoefficientSelectivityView:
    View {

    @State
    private var raffinateSoluteInput =
        "0.1"

    @State
    private var extractSoluteInput =
        "0.4"

    @State
    private var raffinateImpurityInput =
        "0.2"

    @State
    private var extractImpurityInput =
        "0.1"

    @State
    private var result:
        DistributionCoefficientSelectivityResult?

    @State
    private var errorMessage = ""

    private let engine =
        DistributionCoefficientSelectivityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scale.3d",
                    title:
                        "Distribution Coefficient & Selectivity",
                    subtitle:
                        "Evaluate phase preference and solvent selectivity from equilibrium data",
                    tint: .blue
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
            "Distribution & Selectivity"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Liquid–Liquid Equilibrium"
                )
                .font(.headline)

                Text(
                    "Dᵢ = Cᵢ,extract / Cᵢ,raffinate"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)

                Text("βA/B = DA / DB")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Both components must use the same concentration basis \
                    in the two equilibrium phases. A separation factor \
                    above one favors the target solute.
                    """
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
            Text("Target Solute at Equilibrium")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Raffinate Concentration",
                symbol: "CA,R",
                unit: "kg/kg",
                placeholder: "Example: 0.1",
                text: $raffinateSoluteInput
            )

            EngineeringInputField(
                title:
                    "Extract Concentration",
                symbol: "CA,E",
                unit: "kg/kg",
                placeholder: "Example: 0.4",
                text: $extractSoluteInput
            )

            Divider()

            Text("Impurity at Equilibrium")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Raffinate Concentration",
                symbol: "CB,R",
                unit: "kg/kg",
                placeholder: "Example: 0.2",
                text:
                    $raffinateImpurityInput
            )

            EngineeringInputField(
                title:
                    "Extract Concentration",
                symbol: "CB,E",
                unit: "kg/kg",
                placeholder: "Example: 0.1",
                text:
                    $extractImpurityInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Distribution & Selectivity",
                systemImage: "scale.3d",
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

    private func resultSection(
        _ result:
            DistributionCoefficientSelectivityResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Solute Distribution Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .soluteDistributionCoefficient
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Impurity Distribution Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .impurityDistributionCoefficient
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Separation Factor",
                        value:
                            numberFormatter.format(
                                result
                                    .separationFactor
                            ),
                        unit: "—"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "Solvent Assessment",
                        systemImage: "scale.3d"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .solutePreferenceDescription
                    )
                    .fontWeight(.semibold)

                    Text(
                        result
                            .selectivityDescription
                    )
                    .foregroundStyle(.secondary)

                    Text(result.modelName)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> DistributionCoefficientSelectivityInput {

        DistributionCoefficientSelectivityInput(
            raffinateSoluteConcentration:
                try InputValidator.parseNumber(
                    raffinateSoluteInput,
                    fieldName:
                        "raffinate solute concentration"
                ),
            extractSoluteConcentration:
                try InputValidator.parseNumber(
                    extractSoluteInput,
                    fieldName:
                        "extract solute concentration"
                ),
            raffinateImpurityConcentration:
                try InputValidator.parseNumber(
                    raffinateImpurityInput,
                    fieldName:
                        "raffinate impurity concentration"
                ),
            extractImpurityConcentration:
                try InputValidator.parseNumber(
                    extractImpurityInput,
                    fieldName:
                        "extract impurity concentration"
                )
        )
    }

    private func loadExample() {
        raffinateSoluteInput = "0.1"
        extractSoluteInput = "0.4"
        raffinateImpurityInput = "0.2"
        extractImpurityInput = "0.1"
        clearResult()
    }

    private func resetInputs() {
        raffinateSoluteInput = ""
        extractSoluteInput = ""
        raffinateImpurityInput = ""
        extractImpurityInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DistributionCoefficientSelectivityView()
    }
}
