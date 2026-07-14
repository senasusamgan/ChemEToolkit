import SwiftUI
import Charts

private struct IntegrationPointDraft:
    Identifiable,
    Equatable {

    let id: UUID
    var xText: String
    var yText: String

    init(
        id: UUID = UUID(),
        xText: String = "",
        yText: String = ""
    ) {
        self.id = id
        self.xText = xText
        self.yText = yText
    }
}

struct NumericalIntegrationView: View {
    @State
    private var selectedMethod:
        NumericalIntegrationMethod = .trapezoidal

    @State
    private var pointRows: [IntegrationPointDraft] = [
        IntegrationPointDraft(),
        IntegrationPointDraft(),
        IntegrationPointDraft()
    ]

    @State
    private var integrationResult:
        NumericalIntegrationResult?

    @State
    private var plottedPoints:
        [IntegrationPoint] = []

    @State private var errorMessage = ""

    private let engine =
        NumericalIntegrationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "function",
                    title: "Numerical Integration",
                    subtitle:
                        "Trapezoidal and Simpson’s 1/3 Rules",
                    tint: .blue
                )

                methodInformationCard

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
        .navigationTitle("Numerical Integration")
        .onChange(
            of: selectedMethod
        ) { _, newMethod in
            ensureMinimumPointCount(
                for: newMethod
            )

            clearResult()
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Integration Method")
                .font(.headline)

            Picker(
                "Integration Method",
                selection: $selectedMethod
            ) {
                ForEach(
                    NumericalIntegrationMethod
                        .allCases
                ) { method in
                    Text(method.pickerTitle)
                        .tag(method)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            dataPointsHeader

            VStack(spacing: AppSpacing.small) {
                ForEach(
                    Array(pointRows.enumerated()),
                    id: \.element.id
                ) { index, row in
                    pointRow(
                        index: index,
                        rowID: row.id,
                        xText:
                            $pointRows[index].xText,
                        yText:
                            $pointRows[index].yText
                    )
                }
            }

            pointActions

            PrimaryActionButton(
                title: "Integrate",
                systemImage: "function",
                action: calculateIntegral
            )

            if let integrationResult {
                resultSection(
                    integrationResult
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var methodInformationCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(selectedMethod.title)
                    .font(.headline)

                Text(selectedMethod.formula)
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.7)

                Text(selectedMethod.explanation)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text(minimumPointMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
        }
        .frame(
            maxWidth:
                AppTheme.Layout.calculatorMaxWidth
        )
    }

    private var minimumPointMessage: String {
        let pointCount =
            selectedMethod.minimumPointCount

        return "Minimum required data points: \(pointCount)"
    }

    private var dataPointsHeader: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text("Data Points")
                    .font(.headline)

                Text(
                    "Enter x values in strictly increasing order."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(pointRows.count) points")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func pointRow(
        index: Int,
        rowID: UUID,
        xText: Binding<String>,
        yText: Binding<String>
    ) -> some View {
        HStack(
            alignment: .bottom,
            spacing: AppSpacing.small
        ) {
            Text("\(index + 1)")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 24)

            compactNumberField(
                title: "x",
                placeholder: "x",
                text: xText
            )

            compactNumberField(
                title: "f(x)",
                placeholder: "f(x)",
                text: yText
            )

            Button {
                removePoint(rowID)
            } label: {
                Image(systemName: "trash")
                    .frame(
                        width: 34,
                        height: 34
                    )
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.red)
            .disabled(
                pointRows.count <=
                    selectedMethod
                        .minimumPointCount
            )
            .accessibilityLabel(
                "Delete point \(index + 1)"
            )
        }
        .padding(AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.medium
            )
            .fill(
                AppTheme.Colors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.medium
            )
            .stroke(
                AppTheme.Colors.border,
                lineWidth: 1
            )
        )
    }

    private func compactNumberField(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.xxSmall
        ) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField(
                placeholder,
                text: text
            )
            .textFieldStyle(.roundedBorder)
            .engineeringNumberKeyboard()
            .accessibilityLabel(title)
        }
        .frame(maxWidth: .infinity)
    }

    private var pointActions: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: AppSpacing.small) {
                addPointButton
                loadExampleButton
                clearPointsButton
            }

            VStack(spacing: AppSpacing.small) {
                addPointButton
                loadExampleButton
                clearPointsButton
            }
        }
    }

    private var addPointButton: some View {
        Button {
            pointRows.append(
                IntegrationPointDraft()
            )

            clearResult()
        } label: {
            Label(
                "Add Point",
                systemImage: "plus"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var loadExampleButton: some View {
        Button {
            loadExample()
        } label: {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearPointsButton: some View {
        Button {
            resetPoints()
        } label: {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result: NumericalIntegrationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Approximate Integral",
                        value:
                            numberFormatter.format(
                                result.value
                            ),
                        unit: "∫ f(x) dx"
                    )
                ]
            )

            if !plottedPoints.isEmpty {
                integrationChart
            }

            resultInformationCard(result)
        }
    }

    private var integrationChart: some View {
        Chart(
            plottedPoints,
            id: \.x
        ) { point in
            LineMark(
                x: .value("x", point.x),
                y: .value("f(x)", point.y)
            )

            PointMark(
                x: .value("x", point.x),
                y: .value("f(x)", point.y)
            )
        }
        .chartXAxisLabel("x")
        .chartYAxisLabel("f(x)")
        .frame(height: 260)
        .padding(AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.large
            )
            .fill(
                AppTheme.Colors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.large
            )
            .stroke(
                AppTheme.Colors.border,
                lineWidth: 1
            )
        )
        .accessibilityLabel(
            "Graph of the entered integration data points"
        )
    }

    private func resultInformationCard(
        _ result: NumericalIntegrationResult
    ) -> some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                informationRow(
                    title: "Method",
                    value: result.method.title
                )

                Divider()

                informationRow(
                    title: "Data Points",
                    value:
                        "\(result.pointCount)"
                )

                informationRow(
                    title: "Subintervals",
                    value:
                        "\(result.intervalCount)"
                )

                informationRow(
                    title: "Bounds",
                    value:
                        "[\(numberFormatter.format(result.lowerBound)), \(numberFormatter.format(result.upperBound))]"
                )

                informationRow(
                    title: "Spacing",
                    value:
                        spacingDescription(
                            for: result
                        )
                )
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }

    private func spacingDescription(
        for result:
            NumericalIntegrationResult
    ) -> String {
        guard
            result.isEquallySpaced,
            let spacing = result.spacing
        else {
            return "Unequally spaced"
        }

        return "h = \(numberFormatter.format(spacing))"
    }

    private func calculateIntegral() {
        clearResult()

        do {
            let input = try makeInput()

            integrationResult =
                try engine.integrate(
                    method: selectedMethod,
                    input: input
                )

            plottedPoints = input.points
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> NumericalIntegrationInput {
        let points = try pointRows
            .enumerated()
            .map { index, row in
                let pointNumber = index + 1

                let xValue =
                    try InputValidator
                        .parseNumber(
                            row.xText,
                            fieldName:
                                "x value for point \(pointNumber)"
                        )

                let yValue =
                    try InputValidator
                        .parseNumber(
                            row.yText,
                            fieldName:
                                "f(x) value for point \(pointNumber)"
                        )

                return IntegrationPoint(
                    x: xValue,
                    y: yValue
                )
            }

        return NumericalIntegrationInput(
            points: points
        )
    }

    private func removePoint(
        _ rowID: UUID
    ) {
        guard pointRows.count >
                selectedMethod
                    .minimumPointCount else {
            return
        }

        pointRows.removeAll {
            $0.id == rowID
        }

        clearResult()
    }

    private func ensureMinimumPointCount(
        for method:
            NumericalIntegrationMethod
    ) {
        while pointRows.count <
                method.minimumPointCount {
            pointRows.append(
                IntegrationPointDraft()
            )
        }
    }

    private func loadExample() {
        switch selectedMethod {
        case .trapezoidal:
            pointRows = [
                IntegrationPointDraft(
                    xText: "0",
                    yText: "0"
                ),
                IntegrationPointDraft(
                    xText: "1",
                    yText: "1"
                ),
                IntegrationPointDraft(
                    xText: "2",
                    yText: "4"
                )
            ]

        case .simpsonOneThird:
            pointRows = [
                IntegrationPointDraft(
                    xText: "0",
                    yText: "0"
                ),
                IntegrationPointDraft(
                    xText: "0.5",
                    yText: "0.25"
                ),
                IntegrationPointDraft(
                    xText: "1",
                    yText: "1"
                )
            ]
        }

        clearResult()
    }

    private func resetPoints() {
        pointRows = Array(
            repeating:
                IntegrationPointDraft(),
            count:
                selectedMethod
                    .minimumPointCount
        )

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The numerical integration could not be completed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        integrationResult = nil
        plottedPoints = []
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        NumericalIntegrationView()
    }
}
