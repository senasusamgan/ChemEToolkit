import SwiftUI

struct LaplaceTransformHelperView: View {
    @State private var selectedFunction: LaplaceTransformFunction = .exponential
    @State private var amplitudeInput = "2"
    @State private var parameterInput = "0.5"
    @State private var evaluationInput = "2"

    @State private var result: LaplaceTransformHelperResult?
    @State private var errorMessage = ""

    private let engine = LaplaceTransformHelperEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "function",
                    title: "Laplace Transform Helper",
                    subtitle: "Evaluate common one-sided Laplace-transform pairs",
                    tint: .blue
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        VStack(alignment: .leading, spacing: AppSpacing.small) {
                            Text("Time-Domain Function").font(.headline)

                            Picker("Function", selection: $selectedFunction) {
                                ForEach(LaplaceTransformFunction.allCases) { function in
                                    Text(function.title).tag(function)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        EngineeringInputField(
                            title: "Amplitude",
                            symbol: "A",
                            unit: "—",
                            placeholder: "2",
                            text: $amplitudeInput
                        )

                        EngineeringInputField(
                            title: "Parameter",
                            symbol: "a or ω",
                            unit: "1/time",
                            placeholder: "0.5",
                            text: $parameterInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Value",
                            symbol: "s",
                            unit: "1/time",
                            placeholder: "2",
                            text: $evaluationInput
                        )

                        HStack {
                            Button("Load Example", action: loadExample)
                            Spacer()
                            Button("Clear", role: .destructive, action: resetInputs)
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate Transform",
                            systemImage: "function",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Time-Domain Function", value: result.timeDomainExpression, unit: "—"),
                                    .init(label: "Laplace Transform", value: result.transformExpression, unit: "—"),
                                    .init(label: "Evaluated Transform", value: formatter.format(result.evaluatedTransform), unit: "—"),
                                    .init(label: "Convergence", value: result.convergenceDescription, unit: "—")
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription).foregroundStyle(.secondary)
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
        .navigationTitle("Laplace Transform")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    function: selectedFunction,
                    amplitude: try InputValidator.parseNumber(amplitudeInput, fieldName: "amplitude"),
                    parameter: try InputValidator.parseNumber(parameterInput, fieldName: "function parameter"),
                    evaluationS: try InputValidator.parseNumber(evaluationInput, fieldName: "evaluation s")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        selectedFunction = .exponential
        amplitudeInput = "2"
        parameterInput = "0.5"
        evaluationInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        amplitudeInput = ""
        parameterInput = ""
        evaluationInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { LaplaceTransformHelperView() }
}
