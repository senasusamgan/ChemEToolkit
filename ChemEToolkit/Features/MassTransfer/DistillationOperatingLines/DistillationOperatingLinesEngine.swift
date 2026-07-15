import Foundation

struct DistillationOperatingLinesEngine: Sendable {
    private let tolerance = 1.0e-10

    func calculate(_ input: DistillationOperatingLinesInput) throws -> DistillationOperatingLinesResult {
        try validate(input)

        let mr = input.refluxRatio / (input.refluxRatio + 1)
        let br = input.distillateLightMoleFraction / (input.refluxRatio + 1)

        let qSlope: Double?
        let feedX: Double
        let feedY: Double
        let feedDescription: String

        if abs(input.feedQuality - 1) <= tolerance {
            qSlope = nil
            feedX = input.feedLightMoleFraction
            feedY = mr * feedX + br
            feedDescription = "Saturated-liquid feed: vertical q-line at x = zF."
        } else {
            let mq = input.feedQuality / (input.feedQuality - 1)
            let bq = -input.feedLightMoleFraction / (input.feedQuality - 1)
            let denominator = mr - mq
            guard abs(denominator) > tolerance else { throw DistillationOperatingLinesError.invalidOperatingLineIntersection }
            qSlope = mq
            feedX = (bq - br) / denominator
            feedY = mr * feedX + br

            if abs(input.feedQuality) <= tolerance {
                feedDescription = "Saturated-vapor feed: horizontal q-line at y = zF."
            } else if input.feedQuality > 1 {
                feedDescription = "Subcooled-liquid feed: q-line slope exceeds one."
            } else if input.feedQuality > 0 {
                feedDescription = "Partially vaporized feed: negative q-line slope."
            } else {
                feedDescription = "Superheated-vapor feed: q-line slope lies between zero and one."
            }
        }

        guard feedX.isFinite, feedY.isFinite,
              feedX > input.bottomsLightMoleFraction,
              feedX < input.distillateLightMoleFraction,
              (0...1).contains(feedY) else {
            throw DistillationOperatingLinesError.invalidOperatingLineIntersection
        }

        let ms = (feedY - input.bottomsLightMoleFraction) / (feedX - input.bottomsLightMoleFraction)
        let bs = input.bottomsLightMoleFraction * (1 - ms)
        guard ms.isFinite, bs.isFinite, ms > 0 else { throw DistillationOperatingLinesError.invalidOperatingLineIntersection }

        let pinch = try pinchPoint(input)
        let mmin = (input.distillateLightMoleFraction - pinch.y) / (input.distillateLightMoleFraction - pinch.x)
        guard mmin > 0, mmin < 1 else { throw DistillationOperatingLinesError.minimumRefluxUnavailable }
        let rmin = mmin / (1 - mmin)
        guard input.refluxRatio > rmin * (1 + tolerance) else { throw DistillationOperatingLinesError.refluxAtOrBelowMinimum }

        return .init(
            rectifyingSlope: mr,
            rectifyingIntercept: br,
            feedLineSlope: qSlope,
            feedLineDescription: feedDescription,
            feedIntersectionLiquidMoleFraction: feedX,
            feedIntersectionVaporMoleFraction: feedY,
            strippingSlope: ms,
            strippingIntercept: bs,
            minimumRefluxRatio: rmin,
            actualToMinimumRefluxRatio: input.refluxRatio / rmin,
            minimumRefluxPinchLiquidMoleFraction: pinch.x,
            minimumRefluxPinchVaporMoleFraction: pinch.y,
            modelName: "Constant-molar-overflow binary distillation operating lines"
        )
    }

    private func validate(_ input: DistillationOperatingLinesInput) throws {
        let values = [input.relativeVolatility, input.distillateLightMoleFraction, input.bottomsLightMoleFraction, input.feedLightMoleFraction, input.refluxRatio, input.feedQuality]
        guard values.allSatisfy(\.isFinite) else { throw DistillationOperatingLinesError.nonFiniteInput }
        guard input.relativeVolatility > 1 else { throw DistillationOperatingLinesError.relativeVolatilityNotGreaterThanOne }
        guard input.bottomsLightMoleFraction > 0,
              input.bottomsLightMoleFraction < input.feedLightMoleFraction,
              input.feedLightMoleFraction < input.distillateLightMoleFraction,
              input.distillateLightMoleFraction < 1 else {
            throw DistillationOperatingLinesError.invalidCompositionOrdering
        }
        guard input.refluxRatio > 0 else { throw DistillationOperatingLinesError.nonPositiveRefluxRatio }
        guard (-1...2).contains(input.feedQuality) else { throw DistillationOperatingLinesError.feedQualityOutOfRange }
    }

    private func equilibriumY(x: Double, alpha: Double) -> Double {
        alpha * x / (1 + (alpha - 1) * x)
    }

    private func pinchPoint(_ input: DistillationOperatingLinesInput) throws -> (x: Double, y: Double) {
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
            guard abs(qb) > tolerance else { throw DistillationOperatingLinesError.minimumRefluxUnavailable }
            roots = [-qc / qb]
        } else {
            let discriminant = qb * qb - 4 * qa * qc
            guard discriminant >= -tolerance else { throw DistillationOperatingLinesError.minimumRefluxUnavailable }
            let root = sqrt(max(0, discriminant))
            roots = [(-qb + root) / (2 * qa), (-qb - root) / (2 * qa)]
        }

        let physical = roots.filter {
            $0.isFinite && $0 > input.bottomsLightMoleFraction && $0 < input.distillateLightMoleFraction
        }
        guard let x = physical.min(by: { abs($0 - input.feedLightMoleFraction) < abs($1 - input.feedLightMoleFraction) }) else {
            throw DistillationOperatingLinesError.minimumRefluxUnavailable
        }
        let y = equilibriumY(x: x, alpha: alpha)
        guard y < input.distillateLightMoleFraction else { throw DistillationOperatingLinesError.minimumRefluxUnavailable }
        return (x, y)
    }
}
