import SwiftUI

struct LiquidLevelDynamicsView:
    View {

    @State private var areaInput = "2"
    @State private var resistanceInput = "4"
    @State private var initialLevelInput = "3"
    @State private var flowStepInput = "0.5"
    @State private var timeInput = "4"
    @State private var maximumLevelInput = "10"

    @State private var result:
        LiquidLevelDynamicsResult?

    @State private var errorMessage = ""

    private let engine =
        LiquidLevelDynamicsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "water.waves",
                    title: "Liquid-Level Dynamics",
                    subtitle: "Calculate a single-tank level response and overflow risk",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The linear tank time constant equals cross-sectional area multiplied by hydraulic resistance.")
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
                            title: "Tank Cross-Sectional Area",
                            symbol: "A",
                            unit: "area",
                            placeholder: "2",
                            text: $areaInput
                        )

                        EngineeringInputField(
                            title: "Hydraulic Resistance",
                            symbol: "R",
                            unit: "time/area",
                            placeholder: "4",
                            text: $resistanceInput
                        )

                        EngineeringInputField(
                            title: "Initial Liquid Level",
                            symbol: "h₀",
                            unit: "length",
                            placeholder: "3",
                            text: $initialLevelInput
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
                            placeholder: "4",
                            text: $timeInput
                        )

                        EngineeringInputField(
                            title: "Maximum Tank Level",
                            symbol: "h_max",
                            unit: "length",
                            placeholder: "10",
                            text: $maximumLevelInput
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
                            systemImage: "water.waves",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Liquid Level",
                                        value: numberFormatter.format(result.levelAtEvaluationTime),
                                        unit: "length"
                                    ),
.init(
                                        label: "Final Steady Level",
                                        value: numberFormatter.format(result.finalSteadyStateLevel),
                                        unit: "length"
                                    ),
.init(
                                        label: "Time Constant",
                                        value: numberFormatter.format(result.timeConstant),
                                        unit: "time"
                                    ),
.init(
                                        label: "Initial Level Rate",
                                        value: numberFormatter.format(result.initialLevelRate),
                                        unit: "length/time"
                                    ),
.init(
                                        label: "Response Completed",
                                        value: numberFormatter.format(100 * result.fractionOfFinalChange),
                                        unit: "%"
                                    ),
.init(
                                        label: "Overflow Risk",
                                        value: result.overflowRisk ? "Yes" : "No",
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
        .navigationTitle("Liquid-Level Dynamics")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    tankCrossSectionalArea:
                        try InputValidator.parseNumber(
                            areaInput,
                            fieldName:
                                "tank area"
                        ),
                    hydraulicResistance:
                        try InputValidator.parseNumber(
                            resistanceInput,
                            fieldName:
                                "hydraulic resistance"
                        ),
                    initialLevel:
                        try InputValidator.parseNumber(
                            initialLevelInput,
                            fieldName:
                                "initial liquid level"
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
                        ),
                    maximumTankLevel:
                        try InputValidator.parseNumber(
                            maximumLevelInput,
                            fieldName:
                                "maximum tank level"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        areaInput = "2"
        resistanceInput = "4"
        initialLevelInput = "3"
        flowStepInput = "0.5"
        timeInput = "4"
        maximumLevelInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        areaInput = ""
        resistanceInput = ""
        initialLevelInput = ""
        flowStepInput = ""
        timeInput = ""
        maximumLevelInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LiquidLevelDynamicsView()
    }
}
