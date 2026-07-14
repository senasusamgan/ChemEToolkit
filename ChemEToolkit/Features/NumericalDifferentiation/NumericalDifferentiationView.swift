import SwiftUI
import Charts

private struct DifferentiationPointDraft:
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

struct NumericalDifferentiationView: View {
    @State
    private var selectedMethod:
        NumericalDifferentiationMethod = .forward

    @State
    private var pointRows: [DifferentiationPointDraft] = [
        DifferentiationPointDraft(),
        DifferentiationPointDraft(),
        DifferentiationPointDraft()
    ]

    @State private var targetXInput = ""

    @State
    private var differentiationResult:
        NumericalDifferentiationResult?

    @State
    private var plottedPoints:
        [DifferentiationPoint] = []

    @State private var errorMessage = ""

    private let engine =
        NumericalDifferentiationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "function",
                    title: "Numerical Differentiation",
                    subtitle:
                        "Forward, Backward and Central Differences",
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
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle(
            "Numerical Differentiation"
        )
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
            Text("Differentiation Method")
                .font(.headline)

            Picker(
                "Differentiation Method",
                selection: $selectedMethod
            ) {
                ForEach(
                    NumericalDifferentiationMethod
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
                    Array(
                        pointRows.enumerated()
                    ),
                    id: \.element.id
                ) { index, row in
                    pointRow(
                        index: index,
                        rowID: row.id,
                        xText:
                            $pointRows[index]
                                .xText,
                        yText:
                            $pointRows[index]
                                .yText
                    )
                }
            }

            pointActions

            Divider()

            CalculatorInputField(
                title: "Target Data Point",
                symbol: "x",
                unit: "",
                placeholder:
                    "Enter one of the x values above",
                text: $targetXInput
            )

            Text(
                "The target x value must match one of the entered data points."
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            PrimaryActionButton(
                title: "Calculate Derivative",
                systemImage: "function",
                action: calculateDerivative
            )

            if let differentiationResult {
                resultSection(
                    differentiationResult
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var methodInformationCard:
        some View {
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
                    .multilineTextAlignment(
                        .center
                    )
                    .minimumScaleFactor(0.65)

                Text(
                    selectedMethod.explanation
                )
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
                AppTheme.Layout
                    .calculatorMaxWidth
        )
    }

    private var minimumPointMessage: String {
        let count =
            selectedMethod.minimumPointCount

        return "Minimum required data points: \(count)"
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
                    "Points may be entered in any order, but every x value must be unique."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            }

            Spacer()

            Text(
                pointRows.count == 1
                    ? "1 point"
                    : "\(pointRows.count) points"
            )
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
                .font(
                    .subheadline
                        .monospacedDigit()
                )
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
            .fill(AppTheme.Colors.surface)
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
                clearButton
            }

            VStack(spacing: AppSpacing.small) {
                addPointButton
                loadExampleButton
                clearButton
            }
        }
    }

    private var addPointButton: some View {
        Button {
            pointRows.append(
                DifferentiationPointDraft()
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

    private var clearButton: some View {
        Button {
            resetInputs()
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
        _ result:
            NumericalDifferentiationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Approximate Derivative",
                        value:
                            numberFormatter.format(
                                result.derivative
                            ),
                        unit:
                            "f′(\(numberFormatter.format(result.targetX)))"
                    )
                ]
            )

            differentiationChart(result)

            resultInformationCard(result)
        }
    }

    private func differentiationChart(
        _ result:
            NumericalDifferentiationResult
    ) -> some View {
        Chart {
            ForEach(
                plottedPoints,
                id: \.x
            ) { point in
                LineMark(
                    x: .value(
                        "x",
                        point.x
                    ),
                    y: .value(
                        "f(x)",
                        point.y
                    )
                )
                .interpolationMethod(.linear)

                PointMark(
                    x: .value(
                        "Known x",
                        point.x
                    ),
                    y: .value(
                        "Known f(x)",
                        point.y
                    )
                )
                .symbolSize(60)
            }

            ForEach(
                result.usedPoints,
                id: \.x
            ) { point in
                PointMark(
                    x: .value(
                        "Used x",
                        point.x
                    ),
                    y: .value(
                        "Used f(x)",
                        point.y
                    )
                )
                .symbolSize(130)
            }

            RuleMark(
                x: .value(
                    "Target x",
                    result.targetX
                )
            )
            .lineStyle(
                StrokeStyle(
                    lineWidth: 1,
                    dash: [5, 5]
                )
            )
            .annotation(position: .top) {
                Text(
                    "x = \(numberFormatter.format(result.targetX))"
                )
                .font(.caption)
                .fontWeight(.semibold)
            }
        }
        .chartXAxisLabel("x")
        .chartYAxisLabel("f(x)")
        .frame(height: 280)
        .padding(AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.large
            )
            .fill(AppTheme.Colors.surface)
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
            "Numerical differentiation graph showing entered data points and points used in the derivative calculation"
        )
    }

    private func resultInformationCard(
        _ result:
            NumericalDifferentiationResult
    ) -> some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                informationRow(
                    title: "Method",
                    value: result.method.title
                )

                Divider()

                informationRow(
                    title: "Target x",
                    value:
                        numberFormatter.format(
                            result.targetX
                        )
                )

                informationRow(
                    title: "Entered Points",
                    value:
                        "\(result.pointCount)"
                )

                informationRow(
                    title: "Points Used",
                    value:
                        "\(result.usedPoints.count)"
                )

                informationRow(
                    title: "Used x Values",
                    value:
                        usedPointDescription(
                            result.usedPoints
                        )
                )

                informationRow(
                    title: "Known Range",
                    value:
                        "[\(numberFormatter.format(result.lowerBound)), \(numberFormatter.format(result.upperBound))]"
                )

                informationRow(
                    title: "Spacing",
                    value:
                        spacingDescription(
                            result
                        )
                )
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack(
            alignment: .firstTextBaseline,
            spacing: AppSpacing.medium
        ) {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(
                    .trailing
                )
        }
    }

    private func usedPointDescription(
        _ points: [DifferentiationPoint]
    ) -> String {
        points
            .map {
                numberFormatter.format($0.x)
            }
            .joined(separator: ", ")
    }

    private func spacingDescription(
        _ result:
            NumericalDifferentiationResult
    ) -> String {
        guard
            result.isEquallySpaced,
            let spacing = result.spacing
        else {
            return "Unequally spaced"
        }

        return "h = \(numberFormatter.format(spacing))"
    }

    private func calculateDerivative() {
        clearResult()

        do {
            let input = try makeInput()

            let result =
                try engine.differentiate(
                    method: selectedMethod,
                    input: input
                )

            differentiationResult = result

            plottedPoints =
                input.points.sorted {
                    $0.x < $1.x
                }
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> NumericalDifferentiationInput {
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

                return DifferentiationPoint(
                    x: xValue,
                    y: yValue
                )
            }

        let targetX =
            try InputValidator.parseNumber(
                targetXInput,
                fieldName: "Target x"
            )

        return NumericalDifferentiationInput(
            points: points,
            targetX: targetX
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
            NumericalDifferentiationMethod
    ) {
        while pointRows.count <
                method.minimumPointCount {
            pointRows.append(
                DifferentiationPointDraft()
            )
        }
    }

    private func loadExample() {
        switch selectedMethod {
        case .forward:
            pointRows = [
                DifferentiationPointDraft(
                    xText: "0",
                    yText: "0"
                ),
                DifferentiationPointDraft(
                    xText: "1",
                    yText: "1"
                ),
                DifferentiationPointDraft(
                    xText: "2",
                    yText: "4"
                )
            ]

            targetXInput = "1"

        case .backward:
            pointRows = [
                DifferentiationPointDraft(
                    xText: "0",
                    yText: "0"
                ),
                DifferentiationPointDraft(
                    xText: "1",
                    yText: "1"
                ),
                DifferentiationPointDraft(
                    xText: "2",
                    yText: "4"
                )
            ]

            targetXInput = "1"

        case .central:
            pointRows = [
                DifferentiationPointDraft(
                    xText: "0",
                    yText: "0"
                ),
                DifferentiationPointDraft(
                    xText: "1",
                    yText: "1"
                ),
                DifferentiationPointDraft(
                    xText: "2",
                    yText: "4"
                )
            ]

            targetXInput = "1"
        }

        clearResult()
    }

    private func resetInputs() {
        pointRows = (0..<selectedMethod.minimumPointCount)
            .map { _ in
                DifferentiationPointDraft()
            }

        targetXInput = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The derivative calculation could not be completed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        differentiationResult = nil
        plottedPoints = []
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        NumericalDifferentiationView()
    }
}
