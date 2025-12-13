//
//  TodoItem.swift
//  ToDo_Click
//
//  Created by A'zamjon Abdumuxtorov on 12/12/25.
//

import SwiftUI

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var notes: String?
    var category: Int = 0
    var priority: Int = 1
}

enum TodoCategory: Int, Codable, CaseIterable {
    case personal = 0
    case work = 1
    case shopping = 2
    case others = 3
    
    var imageName: String {
        switch self {
        case .personal:
            return "person.fill"
        case .work:
            return "briefcase.fill"
        case .shopping:
            return "cart.fill"
        case .others:
            return "tag.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .personal:
            return .blue
        case .work:
            return .orange
        case .shopping:
            return .green
        case .others:
            return .gray
        }
    }

}

enum TodoPriority: Int, Codable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    
    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}
