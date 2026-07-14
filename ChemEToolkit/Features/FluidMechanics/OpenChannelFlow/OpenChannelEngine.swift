import Foundation

struct OpenChannelEngine {

    func solve(
        input: OpenChannelInput
    ) throws -> OpenChannelResult {

        try validate(input)

        let crossSectionalArea =
            input.channelWidth
            * input.flowDepth

        let wettedPerimeter =
            input.channelWidth
            + 2 * input.flowDepth

        let hydraulicRadius =
            crossSectionalArea
            / wettedPerimeter

        let volumetricFlowRate =
            1
            / input.manningCoefficient
            * crossSectionalArea
            * pow(
                hydraulicRadius,
                2.0 / 3.0
            )
            * sqrt(input.bedSlope)

        let averageVelocity =
            volumetricFlowRate
            / crossSectionalArea

        guard
            crossSectionalArea.isFinite,
            wettedPerimeter.isFinite,
            hydraulicRadius.isFinite,
            volumetricFlowRate.isFinite,
            averageVelocity.isFinite
        else {
            throw OpenChannelError
                .nonFiniteResult
        }

        return OpenChannelResult(
            channelWidth:
                input.channelWidth,
            flowDepth:
                input.flowDepth,
            bedSlope:
                input.bedSlope,
            manningCoefficient:
                input.manningCoefficient,
            crossSectionalArea:
                crossSectionalArea,
            wettedPerimeter:
                wettedPerimeter,
            hydraulicRadius:
                hydraulicRadius,
            volumetricFlowRate:
                volumetricFlowRate,
            averageVelocity:
                averageVelocity
        )
    }

    private func validate(
        _ input: OpenChannelInput
    ) throws {

        guard
            input.channelWidth.isFinite,
            input.channelWidth > 0
        else {
            throw OpenChannelError
                .invalidChannelWidth
        }

        guard
            input.flowDepth.isFinite,
            input.flowDepth > 0
        else {
            throw OpenChannelError
                .invalidFlowDepth
        }

        guard
            input.bedSlope.isFinite,
            input.bedSlope > 0
        else {
            throw OpenChannelError
                .invalidBedSlope
        }

        guard
            input.manningCoefficient
                .isFinite,
            input.manningCoefficient > 0
        else {
            throw OpenChannelError
                .invalidManningCoefficient
        }
    }
}
