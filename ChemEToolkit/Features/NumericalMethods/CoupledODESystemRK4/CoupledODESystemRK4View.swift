import SwiftUI

    struct CoupledODESystemRK4View: View {
        @State private var a11Input = "0"
    @State private var a12Input = "1"
    @State private var a21Input = "-1"
    @State private var a22Input = "0"
    @State private var initialXInput = "1"
    @State private var initialYInput = "0"
    @State private var finalTimeInput = "6.283185307"
    @State private var stepInput = "0.01"

        @State private var result: CoupledODESystemRK4Result?
        @State private var errorMessage = ""

        private let engine = CoupledODESystemRK4Engine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "point.3.connected.trianglepath.dotted",
                        title: "Coupled ODE System RK4",
                        subtitle: "Integrate a linear two-equation ODE system",
                        tint: .indigo
                    )

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Coefficient a11",
                        symbol: "a11",
                        unit: "—",
                        placeholder: "0",
                        text: $a11Input
                    )

                    EngineeringInputField(
                        title: "Coefficient a12",
                        symbol: "a12",
                        unit: "—",
                        placeholder: "1",
                        text: $a12Input
                    )

                    EngineeringInputField(
                        title: "Coefficient a21",
                        symbol: "a21",
                        unit: "—",
                        placeholder: "-1",
                        text: $a21Input
                    )

                    EngineeringInputField(
                        title: "Coefficient a22",
                        symbol: "a22",
                        unit: "—",
                        placeholder: "0",
                        text: $a22Input
                    )

                    EngineeringInputField(
                        title: "Initial X",
                        symbol: "x0",
                        unit: "—",
                        placeholder: "1",
                        text: $initialXInput
                    )

                    EngineeringInputField(
                        title: "Initial Y",
                        symbol: "y0",
                        unit: "—",
                        placeholder: "0",
                        text: $initialYInput
                    )

                    EngineeringInputField(
                        title: "Final Time",
                        symbol: "tf",
                        unit: "—",
                        placeholder: "6.283185307",
                        text: $finalTimeInput
                    )

                    EngineeringInputField(
                        title: "Step Size",
                        symbol: "h",
                        unit: "—",
                        placeholder: "0.01",
                        text: $stepInput
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
                                systemImage: "point.3.connected.trianglepath.dotted",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Final X",
                                value: numberFormatter.format(result.finalX),
                                unit: "—"
                            ),
.init(
                                label: "Final Y",
                                value: numberFormatter.format(result.finalY),
                                unit: "—"
                            ),
.init(
                                label: "Final Magnitude",
                                value: numberFormatter.format(result.finalMagnitude),
                                unit: "—"
                            ),
.init(
                                label: "Step Count",
                                value: numberFormatter.format(result.stepCount),
                                unit: "steps"
                            ),
.init(
                                label: "Final Time",
                                value: numberFormatter.format(result.finalTime),
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
            .navigationTitle("Coupled ODE System RK4")
        }

        private func calculate() {
            result = nil
            errorMessage = ""
            do {
                result = try engine.calculate(
                    .init(
                            a11: try InputValidator.parseNumber(
                            a11Input,
                            fieldName: "coefficient a11"
                        ),
                        a12: try InputValidator.parseNumber(
                            a12Input,
                            fieldName: "coefficient a12"
                        ),
                        a21: try InputValidator.parseNumber(
                            a21Input,
                            fieldName: "coefficient a21"
                        ),
                        a22: try InputValidator.parseNumber(
                            a22Input,
                            fieldName: "coefficient a22"
                        ),
                        initialX: try InputValidator.parseNumber(
                            initialXInput,
                            fieldName: "initial x"
                        ),
                        initialY: try InputValidator.parseNumber(
                            initialYInput,
                            fieldName: "initial y"
                        ),
                        finalTime: try InputValidator.parseNumber(
                            finalTimeInput,
                            fieldName: "final time"
                        ),
                        stepSize: try InputValidator.parseNumber(
                            stepInput,
                            fieldName: "step size"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            a11Input = ""
        a12Input = ""
        a21Input = ""
        a22Input = ""
        initialXInput = ""
        initialYInput = ""
        finalTimeInput = ""
        stepInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { CoupledODESystemRK4View() }
    }
