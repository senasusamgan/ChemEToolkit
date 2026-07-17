import SwiftUI

struct DryerBalanceView:
    View {

    @State private var feedInput = "1000"
    @State private var initialMoistureInput = "0.40"
    @State private var targetMoistureInput = "0.10"

    @State private var result:
        DryerBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        DryerBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "humidity.fill",
                    title: "Dryer Balance",
                    subtitle: "Calculate dried-product and water-removal flows",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Dry solids are conserved while wet-basis moisture decreases to the selected target.")
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
                            title: "Wet Feed Mass Flow",
                            symbol: "F_wet",
                            unit: "kg/h",
                            placeholder: "1000",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Initial Moisture",
                            symbol: "X_i",
                            unit: "wet basis",
                            placeholder: "0.40",
                            text: $initialMoistureInput
                        )

                        EngineeringInputField(
                            title: "Target Moisture",
                            symbol: "X_f",
                            unit: "wet basis",
                            placeholder: "0.10",
                            text: $targetMoistureInput
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
                            systemImage: "humidity.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Dry Solid Flow",
                                        value: numberFormatter.format(result.drySolidFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Initial Water Flow",
                                        value: numberFormatter.format(result.initialWaterFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Dried Product Flow",
                                        value: numberFormatter.format(result.driedProductFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Final Water Flow",
                                        value: numberFormatter.format(result.finalWaterFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Water Removed",
                                        value: numberFormatter.format(result.waterRemovedFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Final Moisture, Dry Basis",
                                        value: numberFormatter.format(result.finalMoistureDryBasis),
                                        unit: "kg water/kg dry solid"
                                    ),
.init(
                                        label: "Water Removal Fraction",
                                        value: numberFormatter.format(100 * result.waterRemovalFraction),
                                        unit: "%"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Dryer Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    wetFeedMassFlow:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "wet feed mass flow"
                        ),
                    initialMoistureWetBasis:
                        try InputValidator.parseNumber(
                            initialMoistureInput,
                            fieldName:
                                "initial moisture"
                        ),
                    targetMoistureWetBasis:
                        try InputValidator.parseNumber(
                            targetMoistureInput,
                            fieldName:
                                "target moisture"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "1000"
        initialMoistureInput = "0.40"
        targetMoistureInput = "0.10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        initialMoistureInput = ""
        targetMoistureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DryerBalanceView()
    }
}
