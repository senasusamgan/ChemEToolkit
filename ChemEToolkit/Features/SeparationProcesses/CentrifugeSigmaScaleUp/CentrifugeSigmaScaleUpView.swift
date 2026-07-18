import SwiftUI

    struct CentrifugeSigmaScaleUpView: View {
        @State private var throughputInput = "10"

    @State private var referenceSigmaInput = "5000"

    @State private var targetSigmaInput = "12000"

    @State private var correctionInput = "0.85"

        @State private var result: CentrifugeSigmaScaleUpResult?
        @State private var errorMessage = ""

        private let engine = CentrifugeSigmaScaleUpEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "circle.circle.fill",
                        title: "Centrifuge Sigma Scale-Up",
                        subtitle: "Scale centrifuge throughput using equivalent settling area",
                        tint: .purple
                    )

                    CalculatorInfoCard(tint: .purple) {
                        Text("Use a consistent engineering unit system across all entered quantities.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Reference Throughput",
                        symbol: "Q_ref",
                        unit: "m³/h",
                        placeholder: "10",
                        text: $throughputInput
                    )

                    EngineeringInputField(
                        title: "Reference Sigma Factor",
                        symbol: "Sigma_ref",
                        unit: "m²",
                        placeholder: "5000",
                        text: $referenceSigmaInput
                    )

                    EngineeringInputField(
                        title: "Target Sigma Factor",
                        symbol: "Sigma_target",
                        unit: "m²",
                        placeholder: "12000",
                        text: $targetSigmaInput
                    )

                    EngineeringInputField(
                        title: "Efficiency Correction",
                        symbol: "eta",
                        unit: "—",
                        placeholder: "0.85",
                        text: $correctionInput
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
                                systemImage: "circle.circle.fill",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Corrected Target Throughput",
                                value: numberFormatter.format(result.correctedTargetThroughput),
                                unit: "m³/h"
                            ),
.init(
                                label: "Ideal Target Throughput",
                                value: numberFormatter.format(result.idealTargetThroughput),
                                unit: "m³/h"
                            ),
.init(
                                label: "Sigma Ratio",
                                value: numberFormatter.format(result.sigmaRatio),
                                unit: "—"
                            ),
.init(
                                label: "Throughput Increase",
                                value: numberFormatter.format(result.throughputIncrease),
                                unit: "m³/h"
                            ),
.init(
                                label: "Relative Capacity Gain",
                                value: numberFormatter.format(result.relativeCapacityGain),
                                unit: "—"
                            )
                                    ],
                                    tint: .purple
                                )

                                CalculatorInfoCard(tint: .purple) {
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
            .navigationTitle("Centrifuge Sigma Scale-Up")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            referenceThroughput: try InputValidator.parseNumber(
                            throughputInput,
                            fieldName: "reference throughput"
                        ),
                        referenceSigmaFactor: try InputValidator.parseNumber(
                            referenceSigmaInput,
                            fieldName: "reference sigma factor"
                        ),
                        targetSigmaFactor: try InputValidator.parseNumber(
                            targetSigmaInput,
                            fieldName: "target sigma factor"
                        ),
                        efficiencyCorrection: try InputValidator.parseNumber(
                            correctionInput,
                            fieldName: "efficiency correction"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            throughputInput = ""
        referenceSigmaInput = ""
        targetSigmaInput = ""
        correctionInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { CentrifugeSigmaScaleUpView() }
    }
