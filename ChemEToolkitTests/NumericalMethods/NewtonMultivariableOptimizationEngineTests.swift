import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Newton Multivariable Optimization Engine") struct NewtonMultivariableOptimizationEngineTests{
 @Test("Finds the quadratic minimum")func reference()throws{let r=try NewtonMultivariableOptimizationEngine().solve(.init(objective:.quadratic,initialPoint:[0,0]));#expect(abs(r.optimum[0]-3)<1e-12);#expect(abs(r.optimum[1]+2)<1e-12)}
 @Test("Coupled quartic reduces objective")func trend()throws{let r=try NewtonMultivariableOptimizationEngine().solve(.init(objective:.coupledQuartic,initialPoint:[3,-3]));#expect(r.objectiveValue<8)}
 @Test("Rejects invalid controls")func invalid(){#expect(throws:NewtonMultivariableOptimizationError.invalidControls){try NewtonMultivariableOptimizationEngine().solve(.init(objective:.quadratic,initialPoint:[0,0],tolerance:0))}}
}
