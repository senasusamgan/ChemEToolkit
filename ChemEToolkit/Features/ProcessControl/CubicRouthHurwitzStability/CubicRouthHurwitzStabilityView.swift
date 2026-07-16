import SwiftUI

struct CubicRouthHurwitzStabilityView: View {
    @State private var quadraticInput = "6"
    @State private var linearInput = "11"
    @State private var constantInput = "6"
    @State private var result: CubicRouthHurwitzStabilityResult?
    @State private var errorMessage = ""

    private let engine = CubicRouthHurwitzStabilityEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "checkmark.shield",
                    title: "Cubic Routh–Hurwitz Stability",
                    subtitle: "Determine cubic closed-loop stability without calculating roots",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("For a monic cubic, stability requires positive coefficients and a₂a₁ > a₀.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Quadratic Coefficient",
                            symbol: "a₂",
                            unit: "—",
                            placeholder: "6",
                            text: $quadraticInput
                        )

                        EngineeringInputField(
                            title: "Linear Coefficient",
                            symbol: "a₁",
                            unit: "—",
                            placeholder: "11",
                            text: $linearInput
                        )

                        EngineeringInputField(
                            title: "Constant Coefficient",
                            symbol: "a₀",
                            unit: "—",
                            placeholder: "6",
                            text: $constantInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "checkmark.shield",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "First Column — Row 1",
                                        value: numberFormatter.format(result.firstColumnOne),
                                        unit: "—"
                                    ),
.init(
                                        label: "First Column — Row 2",
                                        value: numberFormatter.format(result.firstColumnTwo),
                                        unit: "—"
                                    ),
.init(
                                        label: "First Column — Row 3",
                                        value: numberFormatter.format(result.firstColumnThree),
                                        unit: "—"
                                    ),
.init(
                                        label: "First Column — Row 4",
                                        value: numberFormatter.format(result.firstColumnFour),
                                        unit: "—"
                                    ),
.init(
                                        label: "Right-Half-Plane Roots",
                                        value: "\(result.signChangeCount)",
                                        unit: "count"
                                    ),
.init(
                                        label: "Stable",
                                        value: result.isAsymptoticallyStable ? "Yes" : "No",
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Cubic Routh–Hurwitz Stability")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    quadraticCoefficient: try InputValidator.parseNumber(quadraticInput, fieldName: "quadratic coefficient"),
                    linearCoefficient: try InputValidator.parseNumber(linearInput, fieldName: "linear coefficient"),
                    constantCoefficient: try InputValidator.parseNumber(constantInput, fieldName: "constant coefficient")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        quadraticInput = "6"
        linearInput = "11"
        constantInput = "6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        quadraticInput = ""
        linearInput = ""
        constantInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { CubicRouthHurwitzStabilityView() } }
