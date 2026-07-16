import SwiftUI

struct CatalystDeactivationKineticsView:
    View {

    @State private var initialActivityInput =
        "1"

    @State private var rateConstantInput =
        "0.1"

    @State private var orderInput =
        "1"

    @State private var elapsedTimeInput =
        "5"

    @State private var targetActivityInput =
        "0.5"

    @State private var result:
        CatalystDeactivationKineticsResult?

    @State private var errorMessage = ""

    private let engine =
        CatalystDeactivationKineticsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.line.downtrend.xyaxis",
                    title:
                        "Catalyst Deactivation Kinetics",
                    subtitle:
                        "Evaluate power-law activity loss and catalyst lifetime",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Power-Law Deactivation")
                            .font(.headline)

                        Text("−da/dt = k_d aᵐ")
                            .font(
                                .system(
                                    size: 21,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "Deactivation order is restricted to the validated interval from zero through two."
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

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Initial Activity",
                            symbol: "a₀",
                            unit: "—",
                            placeholder: "1",
                            text:
                                $initialActivityInput
                        )

                        EngineeringInputField(
                            title:
                                "Deactivation Rate Constant",
                            symbol: "k_d",
                            unit:
                                "order-consistent units",
                            placeholder: "0.1",
                            text:
                                $rateConstantInput
                        )

                        EngineeringInputField(
                            title:
                                "Deactivation Order",
                            symbol: "m",
                            unit: "—",
                            placeholder: "1",
                            text: $orderInput
                        )

                        EngineeringInputField(
                            title: "Elapsed Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "5",
                            text:
                                $elapsedTimeInput
                        )

                        EngineeringInputField(
                            title: "Target Activity",
                            symbol: "a_target",
                            unit: "—",
                            placeholder: "0.5",
                            text:
                                $targetActivityInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                            title:
                                "Calculate Deactivation",
                            systemImage:
                                "chart.line.downtrend.xyaxis",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Current Activity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .currentActivity
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Retained Activity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .retainedActivityPercent
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Time to Target Activity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .timeToTargetActivity
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Activity Half-Life",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .timeToHalfInitialActivity
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Finite Extinction Time",
                                            value:
                                                result.finiteExtinctionTime
                                                .map {
                                                    numberFormatter.format(
                                                        $0
                                                    )
                                                }
                                                ?? "No finite extinction",
                                            unit: "time"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Catalyst Deactivation")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialActivity:
                        try InputValidator.parseNumber(
                            initialActivityInput,
                            fieldName:
                                "initial activity"
                        ),
                    deactivationRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "deactivation rate constant"
                        ),
                    deactivationOrder:
                        try InputValidator.parseNumber(
                            orderInput,
                            fieldName:
                                "deactivation order"
                        ),
                    elapsedTime:
                        try InputValidator.parseNumber(
                            elapsedTimeInput,
                            fieldName:
                                "elapsed time"
                        ),
                    targetActivity:
                        try InputValidator.parseNumber(
                            targetActivityInput,
                            fieldName:
                                "target activity"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialActivityInput = "1"
        rateConstantInput = "0.1"
        orderInput = "1"
        elapsedTimeInput = "5"
        targetActivityInput = "0.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialActivityInput = ""
        rateConstantInput = ""
        orderInput = ""
        elapsedTimeInput = ""
        targetActivityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CatalystDeactivationKineticsView()
    }
}
