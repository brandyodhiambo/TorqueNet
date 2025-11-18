//
//  HistoryEventData.swift
//  TorqueNet
//
//  Created by MAC on 18/11/2025.
//
import Foundation

struct HistoryEventData: Identifiable {
    let id = UUID()
    var date: String
    var event: String
    var details: String
}
