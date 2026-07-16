import SwiftUI

struct NonInteractingTankSystemView:
    View {

    @State private var firstAreaInput = "2"
    @State private var firstResistanceInput = "3"
    @State private var secondAreaInput = "1"
    @State private var secondResistanceInput = "4"
    @State private var flowStepInput = "0.5"
    @State private var timeInput = "5"

    @State private var result:
        NonInteractingTankSystemResult?

    @State private var errorMessage = ""

    private let engine =
        NonInteractingTankSystemEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.up.fill",
                    title: "Non-Interacting Tank System",
                    subtitle: "Calculate two-tank cascade dynamics when downstream level does not affect upstream flow",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The cascade response contains two first-order lags with time constants A₁R₁ and A₂R₂.")
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
                            title: "First Tank Resistance",
                            symbol: "R₁",
                            unit: "time/area",
                            placeholder: "3",
                            text: $firstResistanceInput
                        )

                        EngineeringInputField(
                            title: "Second Tank Area",
                            symbol: "A₂",
                            unit: "area",
                            placeholder: "1",
                            text: $secondAreaInput
                        )

                        EngineeringInputField(
                            title: "Second Tank Resistance",
                            symbol: "R₂",
                            unit: "time/area",
                            placeholder: "4",
                            text: $secondResistanceInput
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
                            systemImage: "square.stack.3d.up.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "First Tank Time Constant",
                                        value: numberFormatter.format(result.firstTankTimeConstant),
                                        unit: "time"
                                    ),
.init(
                                        label: "Second Tank Time Constant",
                                        value: numberFormatter.format(result.secondTankTimeConstant),
                                        unit: "time"
                                    ),
.init(
                                        label: "First Tank Level Change",
                                        value: numberFormatter.format(result.firstTankLevelChange),
                                        unit: "length"
                                    ),
.init(
                                        label: "Second Tank Level Change",
                                        value: numberFormatter.format(result.secondTankLevelChange),
                                        unit: "length"
                                    ),
.init(
                                        label: "Outlet Response Completed",
                                        value: numberFormatter.format(100 * result.normalizedOutletResponse),
                                        unit: "%"
                                    ),
.init(
                                        label: "Combined Mean Residence Time",
                                        value: numberFormatter.format(result.combinedMeanResidenceTime),
                                        unit: "time"
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
        .navigationTitle("Non-Interacting Tank System")
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
                    firstTankResistance:
                        try InputValidator.parseNumber(
                            firstResistanceInput,
                            fieldName:
                                "first tank resistance"
                        ),
                    secondTankArea:
                        try InputValidator.parseNumber(
                            secondAreaInput,
                            fieldName:
                                "second tank area"
                        ),
                    secondTankResistance:
                        try InputValidator.parseNumber(
                            secondResistanceInput,
                            fieldName:
                                "second tank resistance"
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
        firstResistanceInput = "3"
        secondAreaInput = "1"
        secondResistanceInput = "4"
        flowStepInput = "0.5"
        timeInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        firstAreaInput = ""
        firstResistanceInput = ""
        secondAreaInput = ""
        secondResistanceInput = ""
        flowStepInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        NonInteractingTankSystemView()
    }
}
