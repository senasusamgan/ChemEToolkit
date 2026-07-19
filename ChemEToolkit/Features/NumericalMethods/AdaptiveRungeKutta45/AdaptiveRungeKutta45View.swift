import SwiftUI

    struct AdaptiveRungeKutta45View: View {
        @State private var aInput = "1"
    @State private var bInput = "-1"
    @State private var initialXInput = "0"
    @State private var finalXInput = "2"
    @State private var initialYInput = "1"
    @State private var stepInput = "0.2"
    @State private var toleranceInput = "0.000001"
    @State private var maxInput = "10000"

        @State private var result: AdaptiveRungeKutta45Result?
        @State private var errorMessage = ""

        private let engine = AdaptiveRungeKutta45Engine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "waveform.path.ecg.rectangle.fill",
                        title: "Adaptive Runge–Kutta 4/5",
                        subtitle: "Integrate dy/dx = ax + by with adaptive steps",
                        tint: .indigo
                    )

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Coefficient A",
                        symbol: "a",
                        unit: "—",
                        placeholder: "1",
                        text: $aInput
                    )

                    EngineeringInputField(
                        title: "Coefficient B",
                        symbol: "b",
                        unit: "—",
                        placeholder: "-1",
                        text: $bInput
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
                        placeholder: "2",
                        text: $finalXInput
                    )

                    EngineeringInputField(
                        title: "Initial Y",
                        symbol: "y0",
                        unit: "—",
                        placeholder: "1",
                        text: $initialYInput
                    )

                    EngineeringInputField(
                        title: "Initial Step",
                        symbol: "h0",
                        unit: "—",
                        placeholder: "0.2",
                        text: $stepInput
                    )

                    EngineeringInputField(
                        title: "Tolerance",
                        symbol: "epsilon",
                        unit: "—",
                        placeholder: "0.000001",
                        text: $toleranceInput
                    )

                    EngineeringInputField(
                        title: "Maximum Steps",
                        symbol: "N",
                        unit: "steps",
                        placeholder: "10000",
                        text: $maxInput
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
                                systemImage: "waveform.path.ecg.rectangle.fill",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Final Y",
                                value: numberFormatter.format(result.finalY),
                                unit: "—"
                            ),
.init(
                                label: "Accepted Steps",
                                value: numberFormatter.format(result.acceptedSteps),
                                unit: "steps"
                            ),
.init(
                                label: "Rejected Steps",
                                value: numberFormatter.format(result.rejectedSteps),
                                unit: "steps"
                            ),
.init(
                                label: "Final Step Size",
                                value: numberFormatter.format(result.finalStepSize),
                                unit: "—"
                            ),
.init(
                                label: "Maximum Estimated Error",
                                value: numberFormatter.format(result.maximumEstimatedError),
                                unit: "—"
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
            .navigationTitle("Adaptive Runge–Kutta 4/5")
        }

        private func calculate() {
            result = nil
            errorMessage = ""
            do {
                result = try engine.calculate(
                    .init(
                            coefficientA: try InputValidator.parseNumber(
                            aInput,
                            fieldName: "coefficient a"
                        ),
                        coefficientB: try InputValidator.parseNumber(
                            bInput,
                            fieldName: "coefficient b"
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
                        initialStep: try InputValidator.parseNumber(
                            stepInput,
                            fieldName: "initial step"
                        ),
                        tolerance: try InputValidator.parseNumber(
                            toleranceInput,
                            fieldName: "tolerance"
                        ),
                        maximumSteps: try InputValidator.parseNumber(
                            maxInput,
                            fieldName: "maximum steps"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            aInput = ""
        bInput = ""
        initialXInput = ""
        finalXInput = ""
        initialYInput = ""
        stepInput = ""
        toleranceInput = ""
        maxInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { AdaptiveRungeKutta45View() }
    }
