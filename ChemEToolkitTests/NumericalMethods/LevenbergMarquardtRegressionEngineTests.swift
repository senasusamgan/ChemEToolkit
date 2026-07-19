import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Levenberg-Marquardt Regression Engine") struct LevenbergMarquardtRegressionEngineTests {
    @Test("Recovers exact exponential parameters") func reference() throws { let xs = [0.0,1,2,3]; let ys = xs.map { 2 * exp(0.5*$0) }; let r = try LevenbergMarquardtRegressionEngine().solve(.init(xValues: xs, yValues: ys, model: .exponential, initialParameters: [1.5,0.4])); #expect(abs(r.parameters[0]-2) < 1e-7); #expect(abs(r.parameters[1]-0.5) < 1e-7) }
    @Test("Fit reduces error from the initial model") func trend() throws { let xs = [0.0,1,2,3]; let ys = xs.map { 2 * exp(0.5*$0) }; let initialSSE = zip(ys, xs.map { 1.5 * exp(0.4*$0) }).reduce(0.0) { let d=$1.0-$1.1; return $0+d*d }; let r = try LevenbergMarquardtRegressionEngine().solve(.init(xValues: xs, yValues: ys, model: .exponential, initialParameters: [1.5,0.4])); #expect(r.sumSquaredErrors < initialSSE) }
    @Test("Rejects mismatched data") func invalid() { #expect(throws: LevenbergMarquardtRegressionError.invalidData) { try LevenbergMarquardtRegressionEngine().solve(.init(xValues: [0,1,2], yValues: [1,2], model: .exponential, initialParameters: [1,1])) } }
}
