import Foundation

struct SokobanLevel {
    let grid: [[SokobanTile]]
    let playerStartPosition: Coordinate
    let boxPositions: Set<Coordinate>
    let targetPositions: Set<Coordinate>
    
    static let fixedLevel: SokobanLevel = {
        let simpleLevel = """
        #####
        #@  #
        # $ #
        #  .#
        #####
        """
        
        return parse(simpleLevel)
    }()
    
    static func parse(_ levelString: String) -> SokobanLevel {
        let lines = levelString.components(separatedBy: .newlines)
        var grid: [[SokobanTile]] = []
        var playerPos = Coordinate(x: 0, y: 0)
        var boxes = Set<Coordinate>()
        var targets = Set<Coordinate>()
        
        for (y, line) in lines.enumerated() {
            var row: [SokobanTile] = []
            for (x, char) in line.enumerated() {
                let coord = Coordinate(x: x, y: y)
                switch char {
                case "#":
                    row.append(.wall)
                case ".":
                    row.append(.target)
                    targets.insert(coord)
                case "@":
                    row.append(.floor)
                    playerPos = coord
                case "$":
                    row.append(.floor)
                    boxes.insert(coord)
                case "*":
                    row.append(.target)
                    targets.insert(coord)
                    boxes.insert(coord)
                case "+":
                    row.append(.target)
                    targets.insert(coord)
                    playerPos = coord
                default:
                    row.append(.floor)
                }
            }
            if !row.isEmpty {
                grid.append(row)
            }
        }
        
        return SokobanLevel(grid: grid, playerStartPosition: playerPos, boxPositions: boxes, targetPositions: targets)
    }
}
