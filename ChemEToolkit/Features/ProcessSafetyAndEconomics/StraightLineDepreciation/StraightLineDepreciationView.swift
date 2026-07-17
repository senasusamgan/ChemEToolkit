import SwiftUI

struct StraightLineDepreciationView:
    View {

    @State private var assetCostInput = "10000000"
    @State private var salvageInput = "1000000"
    @State private var lifeInput = "10"
    @State private var ageInput = "4"

    @State private var result:
        StraightLineDepreciationResult?

    @State private var errorMessage = ""

    private let engine =
        StraightLineDepreciationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "minus.circle.fill",
                    title: "Straight-Line Depreciation",
                    subtitle: "Calculate annual depreciation, accumulated depreciation and book value",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("Straight-line depreciation allocates the depreciable basis equally across the selected service life.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Asset Cost",
                            symbol: "P",
                            unit: "currency",
                            placeholder: "10000000",
                            text: $assetCostInput
                        )

                        EngineeringInputField(
                            title: "Salvage Value",
                            symbol: "S",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $salvageInput
                        )

                        EngineeringInputField(
                            title: "Service Life",
                            symbol: "n",
                            unit: "years",
                            placeholder: "10",
                            text: $lifeInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Age",
                            symbol: "t",
                            unit: "years",
                            placeholder: "4",
                            text: $ageInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "minus.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Depreciable Basis",
                                        value: numberFormatter.format(result.depreciableBasis),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Annual Depreciation",
                                        value: numberFormatter.format(result.annualDepreciation),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Accumulated Depreciation",
                                        value: numberFormatter.format(result.accumulatedDepreciation),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Book Value",
                                        value: numberFormatter.format(result.bookValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Remaining Depreciable Basis",
                                        value: numberFormatter.format(result.remainingDepreciableBasis),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Life Elapsed",
                                        value: numberFormatter.format(100 * result.elapsedLifeFraction),
                                        unit: "%"
                                    )
                                ],
                                tint: .green
                            )

                            CalculatorInfoCard(tint: .green) {
                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.small
                                ) {
                                    Text(result.modelName)
                                        .font(.headline)

                                    Divider()

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message: errorMessage
                            )
                        }
                    }
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
        .navigationTitle("Straight-Line Depreciation")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    depreciableAssetCost:
                        try InputValidator.parseNumber(
                            assetCostInput,
                            fieldName:
                                "asset cost"
                        ),
                    salvageValue:
                        try InputValidator.parseNumber(
                            salvageInput,
                            fieldName:
                                "salvage value"
                        ),
                    serviceLifeYears:
                        try InputValidator.parseNumber(
                            lifeInput,
                            fieldName:
                                "service life"
                        ),
                    evaluationAgeYears:
                        try InputValidator.parseNumber(
                            ageInput,
                            fieldName:
                                "evaluation age"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        assetCostInput = "10000000"
        salvageInput = "1000000"
        lifeInput = "10"
        ageInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        assetCostInput = ""
        salvageInput = ""
        lifeInput = ""
        ageInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        StraightLineDepreciationView()
    }
}
