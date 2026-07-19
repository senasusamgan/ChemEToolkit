import Testing
@testable import ChemEToolkit
@Suite("Thomas Tridiagonal Solver Engine") struct ThomasTridiagonalSolverEngineTests {
    @Test("Solves a reference tridiagonal system") func reference() throws { let r = try ThomasTridiagonalSolverEngine().solve(.init(lowerDiagonal: [-1,-1], mainDiagonal: [2,2,2], upperDiagonal: [-1,-1], constants: [1,0,1])); for x in r.solution { #expect(abs(x-1) < 1e-10) } }
    @Test("Scaling the right side scales the solution") func trend() throws { let e = ThomasTridiagonalSolverEngine(); let a = try e.solve(.init(lowerDiagonal: [-1], mainDiagonal: [2,2], upperDiagonal: [-1], constants: [1,1])); let b = try e.solve(.init(lowerDiagonal: [-1], mainDiagonal: [2,2], upperDiagonal: [-1], constants: [2,2])); #expect(abs(b.solution[0]-2*a.solution[0]) < 1e-10) }
    @Test("Rejects a zero pivot") func invalid() { #expect(throws: ThomasTridiagonalSolverError.zeroPivot) { try ThomasTridiagonalSolverEngine().solve(.init(lowerDiagonal: [1], mainDiagonal: [0,1], upperDiagonal: [1], constants: [1,1])) } }
}
