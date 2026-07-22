import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Numerical Jacobian Engine") struct NumericalJacobianEngineTests{
 @Test("Recovers a linear Jacobian")func reference()throws{let r=try NumericalJacobianEngine().solve(.init(system:.linear,point:[4,-2]));#expect(abs(r.jacobian[0][0]-2)<1e-9);#expect(abs(r.jacobian[0][1]-3)<1e-9);#expect(abs(r.jacobian[1][0]-1)<1e-9);#expect(abs(r.jacobian[1][1]+1)<1e-9)}
 @Test("Nonlinear Jacobian changes with point")func trend()throws{let e=NumericalJacobianEngine();let a=try e.solve(.init(system:.nonlinear,point:[1,1]));let b=try e.solve(.init(system:.nonlinear,point:[2,1]));#expect(b.jacobian[0][0]>a.jacobian[0][0])}
 @Test("Rejects wrong dimension")func invalid(){#expect(throws:NumericalJacobianError.invalidPoint){try NumericalJacobianEngine().solve(.init(system:.linear,point:[1]))}}
}
