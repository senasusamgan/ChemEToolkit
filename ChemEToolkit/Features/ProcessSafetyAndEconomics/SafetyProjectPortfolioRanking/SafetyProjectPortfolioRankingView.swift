import SwiftUI

struct SafetyProjectPortfolioRankingView:
    View {

    @State private var project1RiskInput = "0.0005"
    @State private var project1CostInput = "500000"
    @State private var project1UrgencyInput = "5"
    @State private var project2RiskInput = "0.0008"
    @State private var project2CostInput = "1200000"
    @State private var project2UrgencyInput = "4"
    @State private var project3RiskInput = "0.0002"
    @State private var project3CostInput = "150000"
    @State private var project3UrgencyInput = "3"

    @State private var result:
        SafetyProjectPortfolioRankingResult?

    @State private var errorMessage = ""

    private let engine =
        SafetyProjectPortfolioRankingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "list.number",
                    title: "Safety Project Portfolio Ranking",
                    subtitle: "Rank three projects by urgency-adjusted risk reduction per cost",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Each score multiplies risk reduction per cost by an urgency fraction from one through five.")
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
                            title: "Project 1 Risk Reduction",
                            symbol: "ΔR₁",
                            unit: "risk/year",
                            placeholder: "0.0005",
                            text: $project1RiskInput
                        )

                        EngineeringInputField(
                            title: "Project 1 Cost",
                            symbol: "C₁",
                            unit: "currency",
                            placeholder: "500000",
                            text: $project1CostInput
                        )

                        EngineeringInputField(
                            title: "Project 1 Urgency",
                            symbol: "U₁",
                            unit: "1–5",
                            placeholder: "5",
                            text: $project1UrgencyInput
                        )

                        EngineeringInputField(
                            title: "Project 2 Risk Reduction",
                            symbol: "ΔR₂",
                            unit: "risk/year",
                            placeholder: "0.0008",
                            text: $project2RiskInput
                        )

                        EngineeringInputField(
                            title: "Project 2 Cost",
                            symbol: "C₂",
                            unit: "currency",
                            placeholder: "1200000",
                            text: $project2CostInput
                        )

                        EngineeringInputField(
                            title: "Project 2 Urgency",
                            symbol: "U₂",
                            unit: "1–5",
                            placeholder: "4",
                            text: $project2UrgencyInput
                        )

                        EngineeringInputField(
                            title: "Project 3 Risk Reduction",
                            symbol: "ΔR₃",
                            unit: "risk/year",
                            placeholder: "0.0002",
                            text: $project3RiskInput
                        )

                        EngineeringInputField(
                            title: "Project 3 Cost",
                            symbol: "C₃",
                            unit: "currency",
                            placeholder: "150000",
                            text: $project3CostInput
                        )

                        EngineeringInputField(
                            title: "Project 3 Urgency",
                            symbol: "U₃",
                            unit: "1–5",
                            placeholder: "3",
                            text: $project3UrgencyInput
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
                            systemImage: "list.number",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Project 1 Priority Score",
                                        value: numberFormatter.format(result.project1PriorityScore),
                                        unit: "risk/(currency·year)"
                                    ),
.init(
                                        label: "Project 2 Priority Score",
                                        value: numberFormatter.format(result.project2PriorityScore),
                                        unit: "risk/(currency·year)"
                                    ),
.init(
                                        label: "Project 3 Priority Score",
                                        value: numberFormatter.format(result.project3PriorityScore),
                                        unit: "risk/(currency·year)"
                                    ),
.init(
                                        label: "Highest Priority Project",
                                        value: result.highestPriorityProject,
                                        unit: "—"
                                    ),
.init(
                                        label: "Total Portfolio Cost",
                                        value: numberFormatter.format(result.totalPortfolioCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Portfolio Risk Reduction / Cost",
                                        value: numberFormatter.format(result.portfolioRiskReductionPerCost),
                                        unit: "risk/(currency·year)"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Safety Project Portfolio Ranking")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    project1RiskReduction:
                        try InputValidator.parseNumber(
                            project1RiskInput,
                            fieldName:
                                "project 1 risk reduction"
                        ),
                    project1Cost:
                        try InputValidator.parseNumber(
                            project1CostInput,
                            fieldName:
                                "project 1 cost"
                        ),
                    project1UrgencyRating:
                        try InputValidator.parseNumber(
                            project1UrgencyInput,
                            fieldName:
                                "project 1 urgency"
                        ),
                    project2RiskReduction:
                        try InputValidator.parseNumber(
                            project2RiskInput,
                            fieldName:
                                "project 2 risk reduction"
                        ),
                    project2Cost:
                        try InputValidator.parseNumber(
                            project2CostInput,
                            fieldName:
                                "project 2 cost"
                        ),
                    project2UrgencyRating:
                        try InputValidator.parseNumber(
                            project2UrgencyInput,
                            fieldName:
                                "project 2 urgency"
                        ),
                    project3RiskReduction:
                        try InputValidator.parseNumber(
                            project3RiskInput,
                            fieldName:
                                "project 3 risk reduction"
                        ),
                    project3Cost:
                        try InputValidator.parseNumber(
                            project3CostInput,
                            fieldName:
                                "project 3 cost"
                        ),
                    project3UrgencyRating:
                        try InputValidator.parseNumber(
                            project3UrgencyInput,
                            fieldName:
                                "project 3 urgency"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        project1RiskInput = "0.0005"
        project1CostInput = "500000"
        project1UrgencyInput = "5"
        project2RiskInput = "0.0008"
        project2CostInput = "1200000"
        project2UrgencyInput = "4"
        project3RiskInput = "0.0002"
        project3CostInput = "150000"
        project3UrgencyInput = "3"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        project1RiskInput = ""
        project1CostInput = ""
        project1UrgencyInput = ""
        project2RiskInput = ""
        project2CostInput = ""
        project2UrgencyInput = ""
        project3RiskInput = ""
        project3CostInput = ""
        project3UrgencyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SafetyProjectPortfolioRankingView()
    }
}
