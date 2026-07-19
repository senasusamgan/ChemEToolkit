struct ThomasTridiagonalSolverInput: Equatable, Sendable {
    let lowerDiagonal: [Double]
    let mainDiagonal: [Double]
    let upperDiagonal: [Double]
    let constants: [Double]
    let pivotTolerance: Double
    init(lowerDiagonal: [Double], mainDiagonal: [Double], upperDiagonal: [Double], constants: [Double], pivotTolerance: Double = 1e-12) {
        self.lowerDiagonal = lowerDiagonal; self.mainDiagonal = mainDiagonal
        self.upperDiagonal = upperDiagonal; self.constants = constants; self.pivotTolerance = pivotTolerance
    }
}
