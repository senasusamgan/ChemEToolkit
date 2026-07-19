import SwiftUI

    struct ShootingMethodBoundaryValueView: View {
        @State private var kInput = "1"
    @State private var initialXInput = "0"
    @State private var finalXInput = "1.570796327"
    @State private var initialYInput = "0"
    @State private var targetInput = "1"
    @State private var guessOneInput = "0.5"
    @State private var guessTwoInput = "1.5"
    @State private var stepInput = "0.01"
    @State private var toleranceInput = "0.00000001"
    @State private var iterationsInput = "50"

        @State private var result: ShootingMethodBoundaryValueResult?
        @State private var errorMessage = ""

        private let engine = ShootingMethodBoundaryValueEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "scope",
                        title: "Shooting Method Boundary Value",
                        subtitle: "Solve y'' + ky = 0 with endpoint conditions",
                        tint: .indigo
                    )

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Coefficient K",
                        symbol: "k",
                        unit: "—",
                        placeholder: "1",
                        text: $kInput
                    )

                    EngineeringInputField(
                        title: "Initial X",
                        symbol: "x0",
                        unit: "—",
                        placeholder: "0",
                        text: $initialXInput
                    )

                    EngineeringInputField(
                        title: "Final X",
                        symbol: "xf",
                        unit: "—",
                        placeholder: "1.570796327",
                        text: $finalXInput
                    )

                    EngineeringInputField(
                        title: "Initial Y",
                        symbol: "y0",
                        unit: "—",
                        placeholder: "0",
                        text: $initialYInput
                    )

                    EngineeringInputField(
                        title: "Target Final Y",
                        symbol: "yf",
                        unit: "—",
                        placeholder: "1",
                        text: $targetInput
                    )

                    EngineeringInputField(
                        title: "Slope Guess One",
                        symbol: "s1",
                        unit: "—",
                        placeholder: "0.5",
                        text: $guessOneInput
                    )

                    EngineeringInputField(
                        title: "Slope Guess Two",
                        symbol: "s2",
                        unit: "—",
                        placeholder: "1.5",
                        text: $guessTwoInput
                    )

                    EngineeringInputField(
                        title: "Integration Step",
                        symbol: "h",
                        unit: "—",
                        placeholder: "0.01",
                        text: $stepInput
                    )

                    EngineeringInputField(
                        title: "Tolerance",
                        symbol: "epsilon",
                        unit: "—",
                        placeholder: "0.00000001",
                        text: $toleranceInput
                    )

                    EngineeringInputField(
                        title: "Maximum Iterations",
                        symbol: "N",
                        unit: "iterations",
                        placeholder: "50",
                        text: $iterationsInput
                    )

                            HStack {
                                Spacer()
                                Button(role: .destructive, action: resetInputs) {
                                    Label("Clear", systemImage: "trash")
                                }
                            }
                            .buttonStyle(.bordered)

                            PrimaryActionButton(
                                title: "Calculate",
                                systemImage: "scope",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Required Initial Slope",
                                value: numberFormatter.format(result.requiredInitialSlope),
                                unit: "—"
                            ),
.init(
                                label: "Achieved Final Y",
                                value: numberFormatter.format(result.achievedFinalY),
                                unit: "—"
                            ),
.init(
                                label: "Boundary Residual",
                                value: numberFormatter.format(result.boundaryResidual),
                                unit: "—"
                            ),
.init(
                                label: "Shooting Iterations",
                                value: numberFormatter.format(result.iterationCount),
                                unit: "iterations"
                            ),
.init(
                                label: "RK4 Steps",
                                value: numberFormatter.format(result.integrationSteps),
                                unit: "steps"
                            )
                                    ],
                                    tint: .indigo
                                )

                                CalculatorInfoCard(tint: .indigo) {
                                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                                        Text(result.modelName).font(.headline)
                                        Divider()
                                        Text(result.limitationDescription)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }

                            if !errorMessage.isEmpty {
                                CalculationErrorCard(message: errorMessage)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
                .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
            }
            .navigationTitle("Shooting Method Boundary Value")
        }

        private func calculate() {
            result = nil
            errorMessage = ""
            do {
                result = try engine.calculate(
                    .init(
                            coefficientK: try InputValidator.parseNumber(
                            kInput,
                            fieldName: "coefficient k"
                        ),
                        initialX: try InputValidator.parseNumber(
                            initialXInput,
                            fieldName: "initial x"
                        ),
                        finalX: try InputValidator.parseNumber(
                            finalXInput,
                            fieldName: "final x"
                        ),
                        initialY: try InputValidator.parseNumber(
                            initialYInput,
                            fieldName: "initial y"
                        ),
                        targetFinalY: try InputValidator.parseNumber(
                            targetInput,
                            fieldName: "target final y"
                        ),
                        initialSlopeGuessOne: try InputValidator.parseNumber(
                            guessOneInput,
                            fieldName: "slope guess one"
                        ),
                        initialSlopeGuessTwo: try InputValidator.parseNumber(
                            guessTwoInput,
                            fieldName: "slope guess two"
                        ),
                        stepSize: try InputValidator.parseNumber(
                            stepInput,
                            fieldName: "integration step"
                        ),
                        tolerance: try InputValidator.parseNumber(
                            toleranceInput,
                            fieldName: "tolerance"
                        ),
                        maximumIterations: try InputValidator.parseNumber(
                            iterationsInput,
                            fieldName: "maximum iterations"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            kInput = ""
        initialXInput = ""
        finalXInput = ""
        initialYInput = ""
        targetInput = ""
        guessOneInput = ""
        guessTwoInput = ""
        stepInput = ""
        toleranceInput = ""
        iterationsInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { ShootingMethodBoundaryValueView() }
    }
