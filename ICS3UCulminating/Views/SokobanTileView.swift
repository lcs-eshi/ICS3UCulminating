import SwiftUI

struct SokobanTileView: View {
    
    // MARK: - Stored properties
    
    let tile: SokobanTile
    let entity: SokobanEntity?
    let isTarget: Bool
    
    // MARK: - Computed properties
    
    var body: some View {
        ZStack {
            // Background Tile
            baseTileView
            
            // Entity (Player or Box)
            if let entity = entity {
                entityView(for: entity)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var baseTileView: some View {
        Rectangle()
            .fill(tileColor)
            .overlay(
                Rectangle()
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
            .overlay(
                targetMarker
            )
    }
    
    private var tileColor: Color {
        switch tile {
        case .wall:
            return .gray
        case .floor, .target:
            return .white.opacity(0.8)
        }
    }
    
    @ViewBuilder
    private var targetMarker: some View {
        if isTarget {
            Circle()
                .fill(Color.green.opacity(0.3))
                .padding(10)
        }
    }
    
    @ViewBuilder
    private func entityView(for entity: SokobanEntity) -> some View {
        switch entity {
        case .player:
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.blue)
                .padding(4)
        case .box:
            RoundedRectangle(cornerRadius: 4)
                .fill(boxColor)
                .overlay(
                    Image(systemName: "shippingbox.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(8)
                )
                .padding(2)
        }
    }
    
    private var boxColor: Color {
        if isTarget {
            return .green
        } else {
            return .brown
        }
    }
}

#Preview {
    HStack {
        SokobanTileView(tile: .wall, entity: nil, isTarget: false)
        SokobanTileView(tile: .floor, entity: .player, isTarget: false)
        SokobanTileView(tile: .floor, entity: .box, isTarget: false)
        SokobanTileView(tile: .target, entity: .box, isTarget: true)
    }
    .frame(height: 50)
    .padding()
}
