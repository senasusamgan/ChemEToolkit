import SwiftUI

struct EquipmentCostScalingView:
    View {

    @State private var referenceCostInput = "1000000"
    @State private var referenceCapacityInput = "100"
    @State private var targetCapacityInput = "200"
    @State private var exponentInput = "0.6"

    @State private var result:
        EquipmentCostScalingResult?

    @State private var errorMessage = ""

    private let engine =
        EquipmentCostScalingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.right.circle.fill",
                    title: "Equipment Cost Scaling",
                    subtitle: "Scale a known equipment cost to a new processing capacity",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("The cost-capacity exponent captures economies or diseconomies of scale for similar equipment.")
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
                            title: "Reference Equipment Cost",
                            symbol: "C₁",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $referenceCostInput
                        )

                        EngineeringInputField(
                            title: "Reference Capacity",
                            symbol: "S₁",
                            unit: "capacity units",
                            placeholder: "100",
                            text: $referenceCapacityInput
                        )

                        EngineeringInputField(
                            title: "Target Capacity",
                            symbol: "S₂",
                            unit: "capacity units",
                            placeholder: "200",
                            text: $targetCapacityInput
                        )

                        EngineeringInputField(
                            title: "Scaling Exponent",
                            symbol: "n",
                            unit: "—",
                            placeholder: "0.6",
                            text: $exponentInput
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
                            systemImage: "arrow.up.right.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Capacity Ratio",
                                        value: numberFormatter.format(result.capacityRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Cost Ratio",
                                        value: numberFormatter.format(result.costRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Scaled Equipment Cost",
                                        value: numberFormatter.format(result.scaledEquipmentCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Target Unit Capacity Cost",
                                        value: numberFormatter.format(result.targetUnitCapacityCost),
                                        unit: "currency/capacity"
                                    ),
.init(
                                        label: "Saving vs Linear Scaling",
                                        value: numberFormatter.format(100 * result.costSavingFractionVersusLinear),
                                        unit: "%"
                                    ),
.init(
                                        label: "Scaling Behavior",
                                        value: result.scalingBehaviorDescription,
                                        unit: "—"
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
        .navigationTitle("Equipment Cost Scaling")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    referenceEquipmentCost:
                        try InputValidator.parseNumber(
                            referenceCostInput,
                            fieldName:
                                "reference equipment cost"
                        ),
                    referenceCapacity:
                        try InputValidator.parseNumber(
                            referenceCapacityInput,
                            fieldName:
                                "reference capacity"
                        ),
                    targetCapacity:
                        try InputValidator.parseNumber(
                            targetCapacityInput,
                            fieldName:
                                "target capacity"
                        ),
                    scalingExponent:
                        try InputValidator.parseNumber(
                            exponentInput,
                            fieldName:
                                "scaling exponent"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        referenceCostInput = "1000000"
        referenceCapacityInput = "100"
        targetCapacityInput = "200"
        exponentInput = "0.6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        referenceCostInput = ""
        referenceCapacityInput = ""
        targetCapacityInput = ""
        exponentInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EquipmentCostScalingView()
    }
}
