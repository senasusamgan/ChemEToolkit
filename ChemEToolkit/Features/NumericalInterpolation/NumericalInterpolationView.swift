import SwiftUI
import Charts

private struct InterpolationPointDraft:
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

struct NumericalInterpolationView: View {
    @State
    private var selectedMethod:
        NumericalInterpolationMethod = .linear

    @State
    private var pointRows: [InterpolationPointDraft] = [
        InterpolationPointDraft(),
        InterpolationPointDraft()
    ]

    @State private var targetXInput = ""

    @State
    private var interpolationResult:
        NumericalInterpolationResult?

    @State
    private var plottedPoints:
        [InterpolationPoint] = []

    @State
    private var curvePoints:
        [InterpolationPoint] = []

    @State private var errorMessage = ""

    private let engine =
        NumericalInterpolationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.xyaxis.line",
                    title:
                        "Numerical Interpolation",
                    subtitle:
                        "Linear and Lagrange interpolation",
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
            "Numerical Interpolation"
        )
        .onChange(
            of: selectedMethod
        ) { _, newMethod in
            synchronizePointRows(
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
            Text("Interpolation Method")
                .font(.headline)

            Picker(
                "Interpolation Method",
                selection: $selectedMethod
            ) {
                ForEach(
                    NumericalInterpolationMethod
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
                title: "Target Value",
                symbol: "x",
                unit: "",
                placeholder:
                    "Enter the target x value",
                text: $targetXInput
            )

            PrimaryActionButton(
                title: "Interpolate",
                systemImage:
                    "chart.xyaxis.line",
                action: calculateInterpolation
            )

            if let interpolationResult {
                resultSection(
                    interpolationResult
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
                    .minimumScaleFactor(0.7)

                Text(
                    selectedMethod.explanation
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

                Text(pointRequirementMessage)
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

    private var pointRequirementMessage:
        String {
        switch selectedMethod {
        case .linear:
            return
                "Exactly two data points are required."

        case .lagrange:
            return
                "At least two unique data points are required."
        }
    }

    private var dataPointsHeader: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text("Known Data Points")
                    .font(.headline)

                Text(
                    "Each point must have a unique x value."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
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
                selectedMethod == .linear ||
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
                InterpolationPointDraft()
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
        .disabled(
            selectedMethod == .linear
        )
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
            NumericalInterpolationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Interpolated Value",
                        value:
                            numberFormatter.format(
                                result.interpolatedY
                            ),
                        unit:
                            "f(\(numberFormatter.format(result.targetX)))"
                    )
                ]
            )

            if result.isExtrapolation {
                extrapolationWarning(result)
            }

            interpolationChart(result)

            resultInformationCard(result)
        }
    }

    private func extrapolationWarning(
        _ result:
            NumericalInterpolationResult
    ) -> some View {
        CalculatorInfoCard(tint: .orange) {
            HStack(
                alignment: .top,
                spacing: AppSpacing.small
            ) {
                Image(
                    systemName:
                        "exclamationmark.triangle.fill"
                )
                .foregroundStyle(.orange)
                .accessibilityHidden(true)

                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.xxSmall
                ) {
                    Text("Extrapolation")
                        .font(.headline)

                    Text(
                        "The target x value lies outside the known data range [\(numberFormatter.format(result.lowerBound)), \(numberFormatter.format(result.upperBound))]. Extrapolated results may be less reliable."
                    )
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                }
            }
        }
    }

    private func interpolationChart(
        _ result:
            NumericalInterpolationResult
    ) -> some View {
        Chart {
            ForEach(
                curvePoints,
                id: \.x
            ) { point in
                LineMark(
                    x: .value(
                        "x",
                        point.x
                    ),
                    y: .value(
                        "Interpolated curve",
                        point.y
                    )
                )
                .interpolationMethod(.linear)
            }

            ForEach(
                plottedPoints,
                id: \.x
            ) { point in
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
                .symbolSize(70)
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

            PointMark(
                x: .value(
                    "Target x",
                    result.targetX
                ),
                y: .value(
                    "Interpolated value",
                    result.interpolatedY
                )
            )
            .symbolSize(110)
            .annotation(position: .top) {
                Text(
                    "f(x) = \(numberFormatter.format(result.interpolatedY))"
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
            "Interpolation graph showing known data points and the interpolated target value"
        )
    }

    private func resultInformationCard(
        _ result:
            NumericalInterpolationResult
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
                    title: "Data Points",
                    value:
                        "\(result.pointCount)"
                )

                informationRow(
                    title: "Polynomial Degree",
                    value:
                        "\(result.polynomialDegree)"
                )

                informationRow(
                    title: "Known Range",
                    value:
                        "[\(numberFormatter.format(result.lowerBound)), \(numberFormatter.format(result.upperBound))]"
                )

                informationRow(
                    title: "Calculation Type",
                    value:
                        result.isExtrapolation
                        ? "Extrapolation"
                        : "Interpolation"
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
                .multilineTextAlignment(
                    .trailing
                )
        }
    }

    private func calculateInterpolation() {
        clearResult()

        do {
            let input = try makeInput()

            let result =
                try engine.interpolate(
                    method: selectedMethod,
                    input: input
                )

            interpolationResult = result

            plottedPoints =
                input.points.sorted {
                    $0.x < $1.x
                }

            curvePoints = makeCurvePoints(
                input: input,
                result: result
            )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> NumericalInterpolationInput {
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

                return InterpolationPoint(
                    x: xValue,
                    y: yValue
                )
            }

        let targetX =
            try InputValidator.parseNumber(
                targetXInput,
                fieldName: "Target x"
            )

        return NumericalInterpolationInput(
            points: points,
            targetX: targetX
        )
    }

    private func makeCurvePoints(
        input: NumericalInterpolationInput,
        result: NumericalInterpolationResult
    ) -> [InterpolationPoint] {
        let lowerChartBound = min(
            result.lowerBound,
            result.targetX
        )

        let upperChartBound = max(
            result.upperBound,
            result.targetX
        )

        guard upperChartBound >
                lowerChartBound else {
            return plottedPoints
        }

        let sampleCount = 80
        let interval =
            upperChartBound -
            lowerChartBound

        return (0...sampleCount)
            .compactMap { sampleIndex in
                let fraction =
                    Double(sampleIndex) /
                    Double(sampleCount)

                let sampleX =
                    lowerChartBound +
                    interval * fraction

                let sampleInput =
                    NumericalInterpolationInput(
                        points: input.points,
                        targetX: sampleX
                    )

                guard
                    let sampleResult =
                        try? engine.interpolate(
                            method:
                                selectedMethod,
                            input: sampleInput
                        )
                else {
                    return nil
                }

                return InterpolationPoint(
                    x: sampleX,
                    y:
                        sampleResult
                            .interpolatedY
                )
            }
    }

    private func removePoint(
        _ rowID: UUID
    ) {
        guard
            selectedMethod == .lagrange,
            pointRows.count >
                selectedMethod
                    .minimumPointCount
        else {
            return
        }

        pointRows.removeAll {
            $0.id == rowID
        }

        clearResult()
    }

    private func synchronizePointRows(
        for method:
            NumericalInterpolationMethod
    ) {
        switch method {
        case .linear:
            if pointRows.count > 2 {
                pointRows =
                    Array(pointRows.prefix(2))
            }

            while pointRows.count < 2 {
                pointRows.append(
                    InterpolationPointDraft()
                )
            }

        case .lagrange:
            while pointRows.count <
                    method.minimumPointCount {
                pointRows.append(
                    InterpolationPointDraft()
                )
            }
        }
    }

    private func loadExample() {
        switch selectedMethod {
        case .linear:
            pointRows = [
                InterpolationPointDraft(
                    xText: "0",
                    yText: "0"
                ),
                InterpolationPointDraft(
                    xText: "10",
                    yText: "20"
                )
            ]

            targetXInput = "5"

        case .lagrange:
            pointRows = [
                InterpolationPointDraft(
                    xText: "0",
                    yText: "0"
                ),
                InterpolationPointDraft(
                    xText: "1",
                    yText: "1"
                ),
                InterpolationPointDraft(
                    xText: "2",
                    yText: "4"
                )
            ]

            targetXInput = "1.5"
        }

        clearResult()
    }

    private func resetInputs() {
        let pointCount: Int

        switch selectedMethod {
        case .linear:
            pointCount = 2

        case .lagrange:
            pointCount =
                selectedMethod
                    .minimumPointCount
        }

        pointRows = (0..<pointCount).map { _ in
            InterpolationPointDraft()
        }

        targetXInput = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The interpolation could not be completed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        interpolationResult = nil
        plottedPoints = []
        curvePoints = []
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        NumericalInterpolationView()
    }
}
