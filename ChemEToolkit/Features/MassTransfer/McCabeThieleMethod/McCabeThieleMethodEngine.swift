import Foundation

struct McCabeThieleMethodEngine: Sendable {
    private let tolerance = 1.0e-10

    func calculate(_ input: McCabeThieleMethodInput) throws -> McCabeThieleMethodResult {
        try validate(input)
        let geometry = try lineGeometry(input)
        guard input.refluxRatio > geometry.rmin * (1 + tolerance) else { throw McCabeThieleMethodError.refluxAtOrBelowMinimum }

        var currentY = input.distillateLightMoleFraction
        var previousX = input.distillateLightMoleFraction
        var stageXs: [Double] = []
        var feedStage: Int?
        var continuousStages: Double?
        var lastFraction = 1.0

        for stage in 1...200 {
            let xeq = inverseEquilibriumX(y: currentY, alpha: input.relativeVolatility)
            guard xeq.isFinite, xeq < previousX - tolerance else { throw McCabeThieleMethodError.nonConvergentStageStepping }
            stageXs.append(xeq)

            if xeq <= input.bottomsLightMoleFraction {
                let denominator = previousX - xeq
                guard denominator > tolerance else { throw McCabeThieleMethodError.nonConvergentStageStepping }
                lastFraction = min(1, max(0, (previousX - input.bottomsLightMoleFraction) / denominator))
                continuousStages = Double(stage - 1) + lastFraction
                break
            }

            if feedStage == nil, xeq < geometry.feedX { feedStage = stage }
            let nextY = xeq >= geometry.feedX
                ? geometry.mr * xeq + geometry.br
                : geometry.ms * xeq + geometry.bs
            guard nextY.isFinite, nextY > 0, nextY < 1 else { throw McCabeThieleMethodError.nonConvergentStageStepping }
            currentY = nextY
            previousX = xeq
        }

        guard let continuousStages, continuousStages > 0 else { throw McCabeThieleMethodError.nonConvergentStageStepping }
        let wholeStages = max(1, Int(ceil(continuousStages - 1e-12)))

        return .init(
            continuousTheoreticalStageCount: continuousStages,
            requiredWholeStageCount: wholeStages,
            feedStageNumber: feedStage ?? min(wholeStages, stageXs.count),
            minimumRefluxRatio: geometry.rmin,
            actualToMinimumRefluxRatio: input.refluxRatio / geometry.rmin,
            rectifyingSlope: geometry.mr,
            strippingSlope: geometry.ms,
            feedIntersectionLiquidMoleFraction: geometry.feedX,
            feedIntersectionVaporMoleFraction: geometry.feedY,
            finalStageFraction: lastFraction,
            stageLiquidCompositions: stageXs,
            countingConvention: "Stages include the partial reboiler and exclude the total condenser.",
            modelName: "Binary McCabe–Thiele method with constant relative volatility and constant molar overflow"
        )
    }

    private func validate(_ input: McCabeThieleMethodInput) throws {
        let values = [input.relativeVolatility, input.distillateLightMoleFraction, input.bottomsLightMoleFraction, input.feedLightMoleFraction, input.refluxRatio, input.feedQuality]
        guard values.allSatisfy(\.isFinite) else { throw McCabeThieleMethodError.nonFiniteInput }
        guard input.relativeVolatility > 1 else { throw McCabeThieleMethodError.relativeVolatilityNotGreaterThanOne }
        guard input.bottomsLightMoleFraction > 0,
              input.bottomsLightMoleFraction < input.feedLightMoleFraction,
              input.feedLightMoleFraction < input.distillateLightMoleFraction,
              input.distillateLightMoleFraction < 1 else {
            throw McCabeThieleMethodError.invalidCompositionOrdering
        }
        guard input.refluxRatio > 0 else { throw McCabeThieleMethodError.nonPositiveRefluxRatio }
        guard (-1...2).contains(input.feedQuality) else { throw McCabeThieleMethodError.feedQualityOutOfRange }
    }

    private func equilibriumY(x: Double, alpha: Double) -> Double {
        alpha * x / (1 + (alpha - 1) * x)
    }

    private func inverseEquilibriumX(y: Double, alpha: Double) -> Double {
        y / (alpha - (alpha - 1) * y)
    }

    private func lineGeometry(_ input: McCabeThieleMethodInput) throws -> (mr: Double, br: Double, feedX: Double, feedY: Double, ms: Double, bs: Double, rmin: Double) {
        let mr = input.refluxRatio / (input.refluxRatio + 1)
        let br = input.distillateLightMoleFraction / (input.refluxRatio + 1)
        let feedX: Double
        let feedY: Double

        if abs(input.feedQuality - 1) <= tolerance {
            feedX = input.feedLightMoleFraction
            feedY = mr * feedX + br
        } else {
            let mq = input.feedQuality / (input.feedQuality - 1)
            let bq = -input.feedLightMoleFraction / (input.feedQuality - 1)
            let denominator = mr - mq
            guard abs(denominator) > tolerance else { throw McCabeThieleMethodError.invalidOperatingLineIntersection }
            feedX = (bq - br) / denominator
            feedY = mr * feedX + br
        }

        guard feedX > input.bottomsLightMoleFraction,
              feedX < input.distillateLightMoleFraction,
              (0...1).contains(feedY) else {
            throw McCabeThieleMethodError.invalidOperatingLineIntersection
        }

        let ms = (feedY - input.bottomsLightMoleFraction) / (feedX - input.bottomsLightMoleFraction)
        let bs = input.bottomsLightMoleFraction * (1 - ms)
        guard ms.isFinite, ms > 0 else { throw McCabeThieleMethodError.invalidOperatingLineIntersection }

        let pinch = try pinchPoint(input)
        let mmin = (input.distillateLightMoleFraction - pinch.y) / (input.distillateLightMoleFraction - pinch.x)
        guard mmin > 0, mmin < 1 else { throw McCabeThieleMethodError.minimumRefluxUnavailable }
        return (mr, br, feedX, feedY, ms, bs, mmin / (1 - mmin))
    }

    private func pinchPoint(_ input: McCabeThieleMethodInput) throws -> (x: Double, y: Double) {
        if abs(input.feedQuality - 1) <= tolerance {
            let x = input.feedLightMoleFraction
            return (x, equilibriumY(x: x, alpha: input.relativeVolatility))
        }

        let a = input.feedQuality / (input.feedQuality - 1)
        let b = -input.feedLightMoleFraction / (input.feedQuality - 1)
        let alpha = input.relativeVolatility
        let qa = a * (alpha - 1)
        let qb = a + b * (alpha - 1) - alpha
        let qc = b
        var roots: [Double] = []

        if abs(qa) <= tolerance {
            guard abs(qb) > tolerance else { throw McCabeThieleMethodError.minimumRefluxUnavailable }
            roots = [-qc / qb]
        } else {
            let discriminant = qb * qb - 4 * qa * qc
            guard discriminant >= -tolerance else { throw McCabeThieleMethodError.minimumRefluxUnavailable }
            let root = sqrt(max(0, discriminant))
            roots = [(-qb + root) / (2 * qa), (-qb - root) / (2 * qa)]
        }

        let physical = roots.filter { $0.isFinite && $0 > input.bottomsLightMoleFraction && $0 < input.distillateLightMoleFraction }
        guard let x = physical.min(by: { abs($0 - input.feedLightMoleFraction) < abs($1 - input.feedLightMoleFraction) }) else {
            throw McCabeThieleMethodError.minimumRefluxUnavailable
        }
        return (x, equilibriumY(x: x, alpha: alpha))
    }
}
