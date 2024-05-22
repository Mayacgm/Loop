//
//  LoopStatusCircleView.swift
//  LoopUI
//
//  Created by Arwain Karlin on 5/8/24.
//  Copyright © 2024 LoopKit Authors. All rights reserved.
//

import LoopKitUI
import SwiftUI

public struct LoopStatusCircleView: View {
    
    @Environment(\.guidanceColors) private var guidanceColors
    
    private enum Status {
        case closedLoopOn
        case closedLoopOff
        case closedLoopNotAllowed
        
        func color(from guidanceColors: GuidanceColors) -> Color {
            switch self {
            case .closedLoopOn:
                return guidanceColors.acceptable
            case .closedLoopOff:
                return guidanceColors.critical
            case .closedLoopNotAllowed:
                return guidanceColors.warning
            }
        }
    }
    
    /// Determines whether a full ring or broken ring will show and which color the ring will be
    ///   - a value of `false` will show a broken ring that'll appear red if ``isClosedLoopAllowed`` is `true` and yellow if ``isClosedLoopAllowed`` is `false`
    ///   - a value of `true` will show an unbroken ring that'll appear green if ``isClosedLoopAllowed`` is `true` and yellow if ``isClosedLoopAllowed`` is `false`
    @Binding private var closedLoop: Bool
    
    /// Determines whether the ring should be yellow to indicate the availability of closed loop
    /// - a value of `false` will always show a yellow ring (broken or unbroken)
    /// - a value of `true` will show green when ``closedLoop`` is `true` and red when ``closedLoop`` is `false`
    private var isClosedLoopAllowed: Bool
    
    /// The aggregated ``Status`` derived from ``closedLoop`` and ``isClosedLoopAllowed``
    @State private var loopStatus: Status
    
    
    /// Creates a LoopStatusCircleView
    /// - Parameters:
    ///   - closedLoop: Binding to the current state of the user's closed loop setting
    ///   - isClosedLoopAllowed: Binding to whether closed loop therapy is currently allowed
    public init(
        closedLoop: Binding<Bool>,
        isClosedLoopAllowed: Bool
    ) {
        self._closedLoop = closedLoop
        self.isClosedLoopAllowed = isClosedLoopAllowed
        self.loopStatus = !isClosedLoopAllowed ? .closedLoopNotAllowed : (closedLoop.wrappedValue ? .closedLoopOn : .closedLoopOff)
    }
    
    public var body: some View {
        Circle()
            .trim(from: closedLoop ? 0 : 0.25, to: 1)
            .rotation(.degrees(-135))
            .stroke(loopStatus.color(from: guidanceColors), lineWidth: 6)
            .frame(width: 30)
            .onChange(of: closedLoop) {
                if !isClosedLoopAllowed {
                    loopStatus = .closedLoopNotAllowed
                } else {
                    loopStatus = $0 ? .closedLoopOn : .closedLoopOff
                }
            }
            .onChange(of: isClosedLoopAllowed) {
                if !$0 {
                    loopStatus = .closedLoopNotAllowed
                } else {
                    loopStatus = closedLoop ? .closedLoopOn : .closedLoopOff
                }
            }
    }
}
