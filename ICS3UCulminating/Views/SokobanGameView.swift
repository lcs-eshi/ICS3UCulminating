import SwiftUI

struct SokobanGameView: View {
    
    // MARK: - Stored properties
    
    @State private var viewModel = SokobanViewModel()
    
    // MARK: - Computed properties
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            
            boardView
            
            if viewModel.isGameWon {
                winMessageView
            } else {
                controlsView
            }
            
            Spacer()
            
            resetButton
        }
        .padding()
        .navigationTitle("Sokoban")
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    private var headerView: some View {
        VStack {
            Text("Push all boxes to the targets!")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var boardView: some View {
        VStack(spacing: 0) {
            ForEach(0..<viewModel.level.grid.count, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.level.grid[y].count, id: \.self) { x in
                        let coord = Coordinate(x: x, y: y)
                        SokobanTileView(
                            tile: viewModel.level.grid[y][x],
                            entity: entity(at: coord),
                            isTarget: viewModel.level.targetPositions.contains(coord)
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 5)
        .padding()
    }
    
    private var controlsView: some View {
        VStack(spacing: 10) {
            Button(action: { viewModel.move(to: .up) }) {
                controlButton(systemName: "chevron.up")
            }
            
            HStack(spacing: 20) {
                Button(action: { viewModel.move(to: .left) }) {
                    controlButton(systemName: "chevron.left")
                }
                
                Button(action: { viewModel.move(to: .right) }) {
                    controlButton(systemName: "chevron.right")
                }
            }
            
            Button(action: { viewModel.move(to: .down) }) {
                controlButton(systemName: "chevron.down")
            }
        }
    }
    
    private func controlButton(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.title.bold())
            .padding()
            .frame(width: 60, height: 60)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(Circle())
            .shadow(radius: 2)
    }
    
    private var winMessageView: some View {
        VStack {
            Text("Congratulations!")
                .font(.largeTitle.bold())
                .foregroundStyle(.green)
            
            Text("You've solved the puzzle!")
                .font(.headline)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 10)
    }
    
    private var resetButton: some View {
        Button(action: { viewModel.reset() }) {
            Label("Reset Level", systemImage: "arrow.counterclockwise")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper functions
    
    private func entity(at coordinate: Coordinate) -> SokobanEntity? {
        if viewModel.playerPosition == coordinate {
            return .player
        }
        if viewModel.boxPositions.contains(coordinate) {
            return .box
        }
        return nil
    }
}

#Preview {
    NavigationStack {
        SokobanGameView()
    }
}
