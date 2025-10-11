//
//  DiscountStackFeature.swift
//  LogoREGIUI
//
//  Created by MASUDA Keito on 2025/10/11.
//

import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct DiscountStackFeature {
    @ObservableState
    public struct State: Equatable {
        var discounts: [Discount] = []
    }
    
    public enum Action {
        case onAppear
        case fetchDiscounts
        case fetchedDiscounts(TaskResult<[Discount]>)
        case onTapDiscount(Discount)
        case delegate(Delegate)
        public enum Delegate{
            case onSelectDiscount(Discount)
        }
    }
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchDiscounts)
            case .fetchDiscounts:
                return .run{send in
                    await send(.fetchedDiscounts(
                        TaskResult{
                            await GetDiscounts().Execute()
                        }
                    ))
                }
            case let .fetchedDiscounts(.success(discounts)):
                state.discounts = discounts
                return .none
            case let .onTapDiscount(discount):
                return .send(.delegate(.onSelectDiscount(discount)))
            case .delegate:
                return .none
            default: return .none
            }
        }
    }
}
