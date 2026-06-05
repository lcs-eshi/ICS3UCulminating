import Foundation
import Observation

@Observable
class SokobanViewModel {
    
    // MARK: - Stored properties
    
    var playerPosition: Coordinate
    var boxPositions: Set<Coordinate>
    let level: SokobanLevel
    var isGameWon: Bool = false
    
    // MARK: - Initializer
    
    init(level: SokobanLevel = SokobanLevel.fixedLevel) {
        self.level = level
        self.playerPosition = level.playerStartPosition
        self.boxPositions = level.boxPositions
        checkWinCondition()
    }
    
    // MARK: - Functions
    
    func move(to direction: Direction) {
        if isGameWon {
            return
        }
        
        let newPlayerPosition = calculateNewPosition(from: playerPosition, direction: direction)
        
        // Check if move is valid
        if isWall(at: newPlayerPosition) {
            return
        }
        
        if isBox(at: newPlayerPosition) {
            let newBoxPosition = calculateNewPosition(from: newPlayerPosition, direction: direction)
            
            if canPushBox(to: newBoxPosition) {
                pushBox(from: newPlayerPosition, to: newBoxPosition)
                playerPosition = newPlayerPosition
            }
        } else {
            playerPosition = newPlayerPosition
        }
        
        checkWinCondition()
    }
    
    func reset() {
        playerPosition = level.playerStartPosition
        boxPositions = level.boxPositions
        isGameWon = false
    }
    
    private func calculateNewPosition(from position: Coordinate, direction: Direction) -> Coordinate {
        var newPosition = position
        switch direction {
        case .up:
            newPosition.y -= 1
        case .down:
            newPosition.y += 1
        case .left:
            newPosition.x -= 1
        case .right:
            newPosition.x += 1
        }
        return newPosition
    }
    
    private func isWall(at position: Coordinate) -> Bool {
        if position.y < 0 || position.y >= level.grid.count {
            return true
        }
        let row = level.grid[position.y]
        if position.x < 0 || position.x >= row.count {
            return true
        }
        return row[position.x] == .wall
    }
    
    private func isBox(at position: Coordinate) -> Bool {
        return boxPositions.contains(position)
    }
    
    private func canPushBox(to position: Coordinate) -> Bool {
        return !isWall(at: position) && !isBox(at: position)
    }
    
    private func pushBox(from oldPosition: Coordinate, to newPosition: Coordinate) {
        boxPositions.remove(oldPosition)
        boxPositions.insert(newPosition)
    }
    
    private func checkWinCondition() {
        var allTargetsCovered = true
        
        for targetPosition in level.targetPositions {
            if !boxPositions.contains(targetPosition) {
                allTargetsCovered = false
                break
            }
        }
        
        isGameWon = allTargetsCovered
    }
}
