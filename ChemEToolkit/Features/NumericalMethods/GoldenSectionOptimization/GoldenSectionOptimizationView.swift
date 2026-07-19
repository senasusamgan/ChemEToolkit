import SwiftUI

    struct GoldenSectionOptimizationView: View {
        @State private var aInput = "2"
    @State private var bInput = "-8"
    @State private var cInput = "10"
    @State private var lowerInput = "0"
    @State private var upperInput = "10"
    @State private var toleranceInput = "0.00000001"
    @State private var iterationsInput = "500"

        @State private var result: GoldenSectionOptimizationResult?
        @State private var errorMessage = ""

        private let engine = GoldenSectionOptimizationEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "scope",
                        title: "Golden-Section Optimization",
                        subtitle: "Minimize a quadratic objective on a bounded interval",
                        tint: .indigo
                    )

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Quadratic A",
                        symbol: "a",
                        unit: "—",
                        placeholder: "2",
                        text: $aInput
                    )

                    EngineeringInputField(
                        title: "Quadratic B",
                        symbol: "b",
                        unit: "—",
                        placeholder: "-8",
                        text: $bInput
                    )

                    EngineeringInputField(
                        title: "Quadratic C",
                        symbol: "c",
                        unit: "—",
                        placeholder: "10",
                        text: $cInput
                    )

                    EngineeringInputField(
                        title: "Lower Bound",
                        symbol: "xL",
                        unit: "—",
                        placeholder: "0",
                        text: $lowerInput
                    )

                    EngineeringInputField(
                        title: "Upper Bound",
                        symbol: "xU",
                        unit: "—",
                        placeholder: "10",
                        text: $upperInput
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
                        placeholder: "500",
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
                                label: "Minimizing X",
                                value: numberFormatter.format(result.minimizingX),
                                unit: "—"
                            ),
.init(
                                label: "Minimum Value",
                                value: numberFormatter.format(result.minimumValue),
                                unit: "—"
                            ),
.init(
                                label: "Final Interval Width",
                                value: numberFormatter.format(result.finalIntervalWidth),
                                unit: "—"
                            ),
.init(
                                label: "Iterations",
                                value: numberFormatter.format(result.iterationCount),
                                unit: "iterations"
                            ),
.init(
                                label: "Analytical Stationary Point",
                                value: numberFormatter.format(result.analyticalStationaryPoint),
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
            .navigationTitle("Golden-Section Optimization")
        }

        private func calculate() {
            result = nil
            errorMessage = ""
            do {
                result = try engine.calculate(
                    .init(
                            quadraticA: try InputValidator.parseNumber(
                            aInput,
                            fieldName: "quadratic a"
                        ),
                        quadraticB: try InputValidator.parseNumber(
                            bInput,
                            fieldName: "quadratic b"
                        ),
                        quadraticC: try InputValidator.parseNumber(
                            cInput,
                            fieldName: "quadratic c"
                        ),
                        lowerBound: try InputValidator.parseNumber(
                            lowerInput,
                            fieldName: "lower bound"
                        ),
                        upperBound: try InputValidator.parseNumber(
                            upperInput,
                            fieldName: "upper bound"
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
            aInput = ""
        bInput = ""
        cInput = ""
        lowerInput = ""
        upperInput = ""
        toleranceInput = ""
        iterationsInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { GoldenSectionOptimizationView() }
    }
