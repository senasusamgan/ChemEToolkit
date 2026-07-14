import SwiftUI

struct UnitConverterView: View {
    @State
    private var selectedCategory:
        ConversionCategory = .temperature

    @State private var inputValue = ""

    @State
    private var fromUnit: ConversionUnit = .celsius

    @State
    private var toUnit: ConversionUnit = .kelvin

    @State
    private var conversionResult:
        UnitConversionResult?

    @State private var errorMessage = ""

    private let engine = UnitConverterEngine()

    private let numberFormatter =
        NumberFormatterService(
            maximumFractionDigits: 6
        )

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: selectedCategory.icon,
                    title: "Unit Converter",
                    subtitle:
                        "Convert common engineering units",
                    tint: .blue
                )

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Unit Converter")
        .onChange(
            of: selectedCategory
        ) { _, newCategory in
            updateUnits(for: newCategory)
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Category")
                .font(.headline)

            Picker(
                "Category",
                selection: $selectedCategory
            ) {
                ForEach(
                    ConversionCategory.allCases
                ) { category in
                    Text(category.title)
                        .tag(category)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            CalculatorInputField(
                title: "Value",
                symbol: "",
                unit: fromUnit.symbol,
                placeholder: "Enter a numerical value",
                text: $inputValue
            )

            ViewThatFits(in: .horizontal) {
                HStack(
                    alignment: .bottom,
                    spacing: AppSpacing.large
                ) {
                    unitPicker(
                        title: "From",
                        selection: $fromUnit
                    )

                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, AppSpacing.xSmall)
                        .accessibilityHidden(true)

                    unitPicker(
                        title: "To",
                        selection: $toUnit
                    )
                }

                VStack(spacing: AppSpacing.medium) {
                    unitPicker(
                        title: "From",
                        selection: $fromUnit
                    )

                    Image(systemName: "arrow.down")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)

                    unitPicker(
                        title: "To",
                        selection: $toUnit
                    )
                }
            }

            PrimaryActionButton(
                title: "Convert",
                systemImage:
                    "arrow.left.arrow.right",
                action: convert
            )

            if let conversionResult {
                CalculationResultCard(
                    items: [
                        CalculationResultDisplayItem(
                            label: "Result",
                            value:
                                numberFormatter.format(
                                    conversionResult
                                        .outputValue
                                ),
                            unit:
                                "\(conversionResult.toUnit.name) " +
                                "(\(conversionResult.toUnit.symbol))"
                        )
                    ],
                    tint: .blue
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func unitPicker(
        title: String,
        selection: Binding<ConversionUnit>
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.xSmall
        ) {
            Text(title)
                .font(.headline)

            Picker(
                title,
                selection: selection
            ) {
                ForEach(
                    selectedCategory.units
                ) { unit in
                    Text(
                        "\(unit.name) (\(unit.symbol))"
                    )
                    .tag(unit)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity)
        }
    }

    private func updateUnits(
        for category: ConversionCategory
    ) {
        let units = category.units

        guard let firstUnit = units.first else {
            return
        }

        fromUnit = firstUnit
        toUnit = units.dropFirst().first ?? firstUnit

        clearOutput()
    }

    private func convert() {
        clearOutput()

        do {
            let value =
                try InputValidator.parseNumber(
                    inputValue,
                    fieldName: "Value"
                )

            conversionResult =
                try engine.convert(
                    value: value,
                    from: fromUnit,
                    to: toUnit
                )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The conversion could not be completed."

        if let suggestion = error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearOutput() {
        conversionResult = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        UnitConverterView()
    }
}
