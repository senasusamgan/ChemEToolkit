import SwiftUI

    struct RichardsonErrorEstimateView: View {
        @State private var coarseInput = "1.2"
    @State private var fineInput = "1.05"
    @State private var ratioInput = "2"
    @State private var orderInput = "2"

        @State private var result: RichardsonErrorEstimateResult?
        @State private var errorMessage = ""

        private let engine = RichardsonErrorEstimateEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "plus.forwardslash.minus",
                        title: "Richardson Error Estimate",
                        subtitle: "Extrapolate a result and estimate discretization error",
                        tint: .indigo
                    )

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Coarse Result",
                        symbol: "phi_h",
                        unit: "—",
                        placeholder: "1.2",
                        text: $coarseInput
                    )

                    EngineeringInputField(
                        title: "Fine Result",
                        symbol: "phi_f",
                        unit: "—",
                        placeholder: "1.05",
                        text: $fineInput
                    )

                    EngineeringInputField(
                        title: "Refinement Ratio",
                        symbol: "r",
                        unit: "—",
                        placeholder: "2",
                        text: $ratioInput
                    )

                    EngineeringInputField(
                        title: "Method Order",
                        symbol: "p",
                        unit: "—",
                        placeholder: "2",
                        text: $orderInput
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
                                systemImage: "plus.forwardslash.minus",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Extrapolated Result",
                                value: numberFormatter.format(result.extrapolatedResult),
                                unit: "—"
                            ),
.init(
                                label: "Estimated Fine-Grid Error",
                                value: numberFormatter.format(result.estimatedFineGridError),
                                unit: "—"
                            ),
.init(
                                label: "Estimated Relative Error",
                                value: numberFormatter.format(result.estimatedRelativeErrorPercent),
                                unit: "%"
                            ),
.init(
                                label: "Correction",
                                value: numberFormatter.format(result.correctionFactor),
                                unit: "—"
                            ),
.init(
                                label: "Convergence Direction",
                                value: numberFormatter.format(result.convergenceDirection),
                                unit: "±1"
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
            .navigationTitle("Richardson Error Estimate")
        }

        private func calculate() {
            result = nil
            errorMessage = ""
            do {
                result = try engine.calculate(
                    .init(
                            coarseResult: try InputValidator.parseNumber(
                            coarseInput,
                            fieldName: "coarse result"
                        ),
                        fineResult: try InputValidator.parseNumber(
                            fineInput,
                            fieldName: "fine result"
                        ),
                        refinementRatio: try InputValidator.parseNumber(
                            ratioInput,
                            fieldName: "refinement ratio"
                        ),
                        methodOrder: try InputValidator.parseNumber(
                            orderInput,
                            fieldName: "method order"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            coarseInput = ""
        fineInput = ""
        ratioInput = ""
        orderInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { RichardsonErrorEstimateView() }
    }
