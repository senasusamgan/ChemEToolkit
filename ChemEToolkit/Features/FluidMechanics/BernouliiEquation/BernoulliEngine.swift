struct BernoulliEngine {

    func solve(
        input: BernoulliInput
    ) throws -> BernoulliResult {

        try validate(input)

        let density = input.density
        let gravity = input.gravity

        let inletPressureHead =
            input.inlet.pressure
            / (density * gravity)

        let inletVelocityHead =
            input.inlet
                .kineticEnergyCorrectionFactor
            * input.inlet.velocity
            * input.inlet.velocity
            / (2 * gravity)

        let inletElevationHead =
            input.inlet.elevation

        let outletVelocityHead =
            input
                .outletKineticEnergyCorrectionFactor
            * input.outletVelocity
            * input.outletVelocity
            / (2 * gravity)

        let outletElevationHead =
            input.outletElevation

        let inletTotalHead =
            inletPressureHead
            + inletVelocityHead
            + inletElevationHead
            + input.pumpHead

        let outletPressureHead =
            inletTotalHead
            - outletVelocityHead
            - outletElevationHead
            - input.turbineHead
            - input.headLoss

        let outletPressure =
            outletPressureHead
            * density
            * gravity

        guard outletPressure.isFinite,
              outletPressureHead.isFinite else {
            throw BernoulliError
                .nonFiniteResult
        }

        let outletTotalHead =
            outletPressureHead
            + outletVelocityHead
            + outletElevationHead
            + input.turbineHead
            + input.headLoss

        return BernoulliResult(
            inletPressure:
                input.inlet.pressure,
            outletPressure:
                outletPressure,
            inletPressureHead:
                inletPressureHead,
            inletVelocityHead:
                inletVelocityHead,
            inletElevationHead:
                inletElevationHead,
            outletPressureHead:
                outletPressureHead,
            outletVelocityHead:
                outletVelocityHead,
            outletElevationHead:
                outletElevationHead,
            pumpHead:
                input.pumpHead,
            turbineHead:
                input.turbineHead,
            headLoss:
                input.headLoss,
            inletTotalHead:
                inletTotalHead,
            outletTotalHead:
                outletTotalHead
        )
    }

    private func validate(
        _ input: BernoulliInput
    ) throws {

        guard input.density.isFinite,
              input.density > 0 else {
            throw BernoulliError
                .invalidDensity
        }

        guard input.gravity.isFinite,
              input.gravity > 0 else {
            throw BernoulliError
                .invalidGravity
        }

        guard input.inlet
            .pressure.isFinite else {
            throw BernoulliError
                .invalidInletPressure
        }

        guard input.inlet
            .velocity.isFinite,
              input.inlet.velocity >= 0 else {
            throw BernoulliError
                .invalidInletVelocity
        }

        guard input.inlet
            .elevation.isFinite else {
            throw BernoulliError
                .invalidInletElevation
        }

        guard input.inlet
            .kineticEnergyCorrectionFactor
            .isFinite,
              input.inlet
                .kineticEnergyCorrectionFactor
                > 0 else {
            throw BernoulliError
                .invalidInletCorrectionFactor
        }

        guard input.outletVelocity
            .isFinite,
              input.outletVelocity >= 0 else {
            throw BernoulliError
                .invalidOutletVelocity
        }

        guard input.outletElevation
            .isFinite else {
            throw BernoulliError
                .invalidOutletElevation
        }

        guard input
            .outletKineticEnergyCorrectionFactor
            .isFinite,
              input
                .outletKineticEnergyCorrectionFactor
                > 0 else {
            throw BernoulliError
                .invalidOutletCorrectionFactor
        }

        guard input.pumpHead.isFinite,
              input.pumpHead >= 0 else {
            throw BernoulliError
                .invalidPumpHead
        }

        guard input.turbineHead.isFinite,
              input.turbineHead >= 0 else {
            throw BernoulliError
                .invalidTurbineHead
        }

        guard input.headLoss.isFinite,
              input.headLoss >= 0 else {
            throw BernoulliError
                .invalidHeadLoss
        }
    }
}
