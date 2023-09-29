//
//  TrainingStatus.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/29.
//

import SwiftUI


struct TrainingStatus: View {
    @Binding var isTraining: Bool
    
    var body: some View {

            VStack(spacing: 0) {
                Text("トレーニング")
                    .font(.system(.largeTitle, weight: .semibold))
                    .lineLimit(0)
                Text(isTraining ? "オン" : "オフ" )
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(2)
            }
            .foregroundColor(Color(.systemBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isTraining ? Color.green : Color.gray)
            }
        
    }
        
}

#Preview {

    GeometryReader { geometry in



    }
    
}
