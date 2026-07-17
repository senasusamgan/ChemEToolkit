import SwiftUI

struct FlammabilityMixtureLimitsView:
    View {

    @State private var component1FractionInput = "0.5"
    @State private var component1LFLInput = "5"
    @State private var component1UFLInput = "15"
    @State private var component2FractionInput = "0.3"
    @State private var component2LFLInput = "2.1"
    @State private var component2UFLInput = "9.5"
    @State private var component3FractionInput = "0.2"
    @State private var component3LFLInput = "1.8"
    @State private var component3UFLInput = "8.4"

    @State private var result:
        FlammabilityMixtureLimitsResult?

    @State private var errorMessage = ""

    private let engine =
        FlammabilityMixtureLimitsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "flame.fill",
                    title: "Flammability Mixture Limits",
                    subtitle: "Estimate mixture LFL and UFL with reciprocal mixing rules",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Fuel fractions are normalized automatically before applying Le Chatelier-style reciprocal mixing.")
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
                            title: "Component 1 Fraction",
                            symbol: "y₁",
                            unit: "fraction of fuel mixture",
                            placeholder: "0.5",
                            text: $component1FractionInput
                        )

                        EngineeringInputField(
                            title: "Component 1 LFL",
                            symbol: "LFL₁",
                            unit: "vol%",
                            placeholder: "5",
                            text: $component1LFLInput
                        )

                        EngineeringInputField(
                            title: "Component 1 UFL",
                            symbol: "UFL₁",
                            unit: "vol%",
                            placeholder: "15",
                            text: $component1UFLInput
                        )

                        EngineeringInputField(
                            title: "Component 2 Fraction",
                            symbol: "y₂",
                            unit: "fraction of fuel mixture",
                            placeholder: "0.3",
                            text: $component2FractionInput
                        )

                        EngineeringInputField(
                            title: "Component 2 LFL",
                            symbol: "LFL₂",
                            unit: "vol%",
                            placeholder: "2.1",
                            text: $component2LFLInput
                        )

                        EngineeringInputField(
                            title: "Component 2 UFL",
                            symbol: "UFL₂",
                            unit: "vol%",
                            placeholder: "9.5",
                            text: $component2UFLInput
                        )

                        EngineeringInputField(
                            title: "Component 3 Fraction",
                            symbol: "y₃",
                            unit: "fraction of fuel mixture",
                            placeholder: "0.2",
                            text: $component3FractionInput
                        )

                        EngineeringInputField(
                            title: "Component 3 LFL",
                            symbol: "LFL₃",
                            unit: "vol%",
                            placeholder: "1.8",
                            text: $component3LFLInput
                        )

                        EngineeringInputField(
                            title: "Component 3 UFL",
                            symbol: "UFL₃",
                            unit: "vol%",
                            placeholder: "8.4",
                            text: $component3UFLInput
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
                            systemImage: "flame.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Mixture LFL",
                                        value: numberFormatter.format(result.mixtureLowerFlammabilityLimit),
                                        unit: "vol%"
                                    ),
.init(
                                        label: "Mixture UFL",
                                        value: numberFormatter.format(result.mixtureUpperFlammabilityLimit),
                                        unit: "vol%"
                                    ),
.init(
                                        label: "Flammable Range Width",
                                        value: numberFormatter.format(result.flammableRangeWidth),
                                        unit: "vol%"
                                    ),
.init(
                                        label: "Normalized Component 1",
                                        value: numberFormatter.format(100 * result.normalizedComponent1Fraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Normalized Component 2",
                                        value: numberFormatter.format(100 * result.normalizedComponent2Fraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Dominant Fuel Component",
                                        value: result.dominantFuelComponent,
                                        unit: "—"
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
        .navigationTitle("Flammability Mixture Limits")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    component1Fraction:
                        try InputValidator.parseNumber(
                            component1FractionInput,
                            fieldName:
                                "component 1 fraction"
                        ),
                    component1LowerLimit:
                        try InputValidator.parseNumber(
                            component1LFLInput,
                            fieldName:
                                "component 1 LFL"
                        ),
                    component1UpperLimit:
                        try InputValidator.parseNumber(
                            component1UFLInput,
                            fieldName:
                                "component 1 UFL"
                        ),
                    component2Fraction:
                        try InputValidator.parseNumber(
                            component2FractionInput,
                            fieldName:
                                "component 2 fraction"
                        ),
                    component2LowerLimit:
                        try InputValidator.parseNumber(
                            component2LFLInput,
                            fieldName:
                                "component 2 LFL"
                        ),
                    component2UpperLimit:
                        try InputValidator.parseNumber(
                            component2UFLInput,
                            fieldName:
                                "component 2 UFL"
                        ),
                    component3Fraction:
                        try InputValidator.parseNumber(
                            component3FractionInput,
                            fieldName:
                                "component 3 fraction"
                        ),
                    component3LowerLimit:
                        try InputValidator.parseNumber(
                            component3LFLInput,
                            fieldName:
                                "component 3 LFL"
                        ),
                    component3UpperLimit:
                        try InputValidator.parseNumber(
                            component3UFLInput,
                            fieldName:
                                "component 3 UFL"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        component1FractionInput = "0.5"
        component1LFLInput = "5"
        component1UFLInput = "15"
        component2FractionInput = "0.3"
        component2LFLInput = "2.1"
        component2UFLInput = "9.5"
        component3FractionInput = "0.2"
        component3LFLInput = "1.8"
        component3UFLInput = "8.4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        component1FractionInput = ""
        component1LFLInput = ""
        component1UFLInput = ""
        component2FractionInput = ""
        component2LFLInput = ""
        component2UFLInput = ""
        component3FractionInput = ""
        component3LFLInput = ""
        component3UFLInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FlammabilityMixtureLimitsView()
    }
}
