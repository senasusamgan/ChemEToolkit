import SwiftUI

struct InteractingTankSystemView:
    View {

    @State private var firstAreaInput = "2"
    @State private var secondAreaInput = "1"
    @State private var interResistanceInput = "3"
    @State private var outletResistanceInput = "4"
    @State private var flowStepInput = "0.5"
    @State private var timeInput = "5"

    @State private var result:
        InteractingTankSystemResult?

    @State private var errorMessage = ""

    private let engine =
        InteractingTankSystemEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.down.right.fill",
                    title: "Interacting Tank System",
                    subtitle: "Calculate coupled two-tank liquid-level dynamics",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The inter-tank flow depends on the difference between both liquid levels, producing coupled second-order behavior.")
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
                            title: "First Tank Area",
                            symbol: "A₁",
                            unit: "area",
                            placeholder: "2",
                            text: $firstAreaInput
                        )

                        EngineeringInputField(
                            title: "Second Tank Area",
                            symbol: "A₂",
                            unit: "area",
                            placeholder: "1",
                            text: $secondAreaInput
                        )

                        EngineeringInputField(
                            title: "Inter-Tank Resistance",
                            symbol: "R₁",
                            unit: "time/area",
                            placeholder: "3",
                            text: $interResistanceInput
                        )

                        EngineeringInputField(
                            title: "Outlet Resistance",
                            symbol: "R₂",
                            unit: "time/area",
                            placeholder: "4",
                            text: $outletResistanceInput
                        )

                        EngineeringInputField(
                            title: "Inlet Flow Step",
                            symbol: "Δq",
                            unit: "volume/time",
                            placeholder: "0.5",
                            text: $flowStepInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "5",
                            text: $timeInput
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
                            title: "Calculate Response",
                            systemImage: "square.stack.3d.down.right.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Natural Frequency",
                                        value: numberFormatter.format(result.naturalFrequency),
                                        unit: "rad/time"
                                    ),
.init(
                                        label: "Damping Ratio",
                                        value: numberFormatter.format(result.dampingRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Damping Regime",
                                        value: result.dampingRegime,
                                        unit: "—"
                                    ),
.init(
                                        label: "Outlet Level Change",
                                        value: numberFormatter.format(result.outletLevelChange),
                                        unit: "length"
                                    ),
.init(
                                        label: "Final Outlet Change",
                                        value: numberFormatter.format(result.finalOutletLevelChange),
                                        unit: "length"
                                    ),
.init(
                                        label: "Response Completed",
                                        value: numberFormatter.format(100 * result.normalizedOutletResponse),
                                        unit: "%"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Interacting Tank System")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    firstTankArea:
                        try InputValidator.parseNumber(
                            firstAreaInput,
                            fieldName:
                                "first tank area"
                        ),
                    secondTankArea:
                        try InputValidator.parseNumber(
                            secondAreaInput,
                            fieldName:
                                "second tank area"
                        ),
                    interTankResistance:
                        try InputValidator.parseNumber(
                            interResistanceInput,
                            fieldName:
                                "inter-tank resistance"
                        ),
                    outletResistance:
                        try InputValidator.parseNumber(
                            outletResistanceInput,
                            fieldName:
                                "outlet resistance"
                        ),
                    inletFlowStepChange:
                        try InputValidator.parseNumber(
                            flowStepInput,
                            fieldName:
                                "inlet flow step"
                        ),
                    evaluationTime:
                        try InputValidator.parseNumber(
                            timeInput,
                            fieldName:
                                "evaluation time"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        firstAreaInput = "2"
        secondAreaInput = "1"
        interResistanceInput = "3"
        outletResistanceInput = "4"
        flowStepInput = "0.5"
        timeInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        firstAreaInput = ""
        secondAreaInput = ""
        interResistanceInput = ""
        outletResistanceInput = ""
        flowStepInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        InteractingTankSystemView()
    }
}
