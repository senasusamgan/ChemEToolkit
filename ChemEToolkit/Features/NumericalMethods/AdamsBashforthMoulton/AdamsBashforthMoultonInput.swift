import Foundation
enum AdamsBashforthMoultonEquation: String, CaseIterable, Equatable, Sendable { case exponentialGrowth, linearForcing }
struct AdamsBashforthMoultonInput: Equatable, Sendable { let equation:AdamsBashforthMoultonEquation;let initialX:Double;let initialY:Double;let finalX:Double;let stepSize:Double
 init(equation:AdamsBashforthMoultonEquation,initialX:Double,initialY:Double,finalX:Double,stepSize:Double=0.1){self.equation=equation;self.initialX=initialX;self.initialY=initialY;self.finalX=finalX;self.stepSize=stepSize}
}
