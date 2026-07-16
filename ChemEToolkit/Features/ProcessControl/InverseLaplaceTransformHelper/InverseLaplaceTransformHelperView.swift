import SwiftUI

struct InverseLaplaceTransformHelperView: View {
    @State private var selectedForm: InverseLaplaceTransformForm = .firstOrderStep
    @State private var amplitudeInput = "10"
    @State private var parameterInput = "4"
    @State private var timeInput = "6"

    @State private var result: InverseLaplaceTransformHelperResult?
    @State private var errorMessage = ""

    private let engine = InverseLaplaceTransformHelperEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.uturn.backward",
                    title: "Inverse Laplace Transform",
                    subtitle: "Convert common transform forms into time-domain responses",
                    tint: .blue
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        VStack(alignment: .leading, spacing: AppSpacing.small) {
                            Text("Transform Form").font(.headline)

                            Picker("Transform Form", selection: $selectedForm) {
                                ForEach(InverseLaplaceTransformForm.allCases) { form in
                                    Text(form.title).tag(form)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        EngineeringInputField(
                            title: "Amplitude",
                            symbol: "A",
                            unit: "—",
                            placeholder: "10",
                            text: $amplitudeInput
                        )

                        EngineeringInputField(
                            title: "Pole, Frequency or Time Constant",
                            symbol: "a, ω or τ",
                            unit: "varies",
                            placeholder: "4",
                            text: $parameterInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "6",
                            text: $timeInput
                        )

                        HStack {
                            Button("Load Example", action: loadExample)
                            Spacer()
                            Button("Clear", role: .destructive, action: resetInputs)
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate Inverse Transform",
                            systemImage: "arrow.uturn.backward",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Transform", value: result.transformExpression, unit: "—"),
                                    .init(label: "Time-Domain Function", value: result.timeDomainExpression, unit: "—"),
                                    .init(label: "Value at t", value: formatter.format(result.evaluatedTimeResponse), unit: "—"),
                                    .init(label: "Initial Value", value: formatter.format(result.initialValue), unit: "—"),
                                    .init(label: "Final Value", value: result.finalValue.map { formatter.format($0) } ?? "No finite limit", unit: "—")
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
        .navigationTitle("Inverse Laplace")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    form: selectedForm,
                    amplitude: try InputValidator.parseNumber(amplitudeInput, fieldName: "amplitude"),
                    parameter: try InputValidator.parseNumber(parameterInput, fieldName: "transform parameter"),
                    evaluationTime: try InputValidator.parseNumber(timeInput, fieldName: "evaluation time")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        selectedForm = .firstOrderStep
        amplitudeInput = "10"
        parameterInput = "4"
        timeInput = "6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        amplitudeInput = ""
        parameterInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { InverseLaplaceTransformHelperView() }
}
