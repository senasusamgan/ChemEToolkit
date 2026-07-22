import SwiftUI

struct MIMODecouplingControlView:
    View {

    @State private var gain11Input = "2"
    @State private var gain12Input = "0.5"
    @State private var gain21Input = "0.4"
    @State private var gain22Input = "1.5"

    @State private var result:
        MIMODecouplingControlResult?

    @State private var errorMessage = ""

    private let engine =
        MIMODecouplingControlEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.grid.2x2.fill",
                    title: "2×2 MIMO Decoupling",
                    subtitle: "Calculate the RGA, inverse gain matrix and control-loop pairing",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Relative Gain Array values near one indicate favorable input-output pairings at steady state.")
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
                            title: "Gain G₁₁",
                            symbol: "G₁₁",
                            unit: "—",
                            placeholder: "2",
                            text: $gain11Input
                        )

                        EngineeringInputField(
                            title: "Gain G₁₂",
                            symbol: "G₁₂",
                            unit: "—",
                            placeholder: "0.5",
                            text: $gain12Input
                        )

                        EngineeringInputField(
                            title: "Gain G₂₁",
                            symbol: "G₂₁",
                            unit: "—",
                            placeholder: "0.4",
                            text: $gain21Input
                        )

                        EngineeringInputField(
                            title: "Gain G₂₂",
                            symbol: "G₂₂",
                            unit: "—",
                            placeholder: "1.5",
                            text: $gain22Input
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
                            title: "Calculate",
                            systemImage: "square.grid.2x2.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Determinant",
                                        value: numberFormatter.format(result.determinant),
                                        unit: "—"
                                    ),
.init(
                                        label: "RGA λ₁₁",
                                        value: numberFormatter.format(result.relativeGain11),
                                        unit: "—"
                                    ),
.init(
                                        label: "RGA λ₁₂",
                                        value: numberFormatter.format(result.relativeGain12),
                                        unit: "—"
                                    ),
.init(
                                        label: "Interaction Index",
                                        value: numberFormatter.format(result.interactionIndex),
                                        unit: "—"
                                    ),
.init(
                                        label: "Pairing Recommendation",
                                        value: result.pairingRecommendation,
                                        unit: "—"
                                    ),
.init(
                                        label: "Conditioning",
                                        value: result.conditioningDescription,
                                        unit: "—"
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
        .navigationTitle("2×2 MIMO Decoupling")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    gain11:
                        try InputValidator.parseNumber(
                            gain11Input,
                            fieldName: "gain G11"
                        ),
                    gain12:
                        try InputValidator.parseNumber(
                            gain12Input,
                            fieldName: "gain G12"
                        ),
                    gain21:
                        try InputValidator.parseNumber(
                            gain21Input,
                            fieldName: "gain G21"
                        ),
                    gain22:
                        try InputValidator.parseNumber(
                            gain22Input,
                            fieldName: "gain G22"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        gain11Input = "2"
        gain12Input = "0.5"
        gain21Input = "0.4"
        gain22Input = "1.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        gain11Input = ""
        gain12Input = ""
        gain21Input = ""
        gain22Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MIMODecouplingControlView()
    }
}
