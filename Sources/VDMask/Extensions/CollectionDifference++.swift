import Foundation

extension CollectionDifference<String.Element> {
    
    func joined() -> [CollectionDifference<String>.Change] {
        reduce(into: []) { result, dif in
            switch (result.last, dif) {
            case let (.insert(lastOffset, lastElement, lastAssociatedWith), .insert(offset, element, associatedWith)):
                if lastOffset + lastElement.count == offset {
                    result[result.endIndex - 1] = .insert(offset: lastOffset, element: lastElement + String(element), associatedWith: lastAssociatedWith)
                } else if offset + 1 == lastOffset {
                    result[result.endIndex - 1] = .insert(offset: offset, element: String(element) + lastElement, associatedWith: associatedWith)
                } else {
                    result.append(.insert(offset: offset, element: String(element), associatedWith: associatedWith))
                }
                
            case let (.remove(lastOffset, lastElement, lastAssociatedWith), .remove(offset, element, associatedWith)):
                if offset + 1 == lastOffset {
                    result[result.endIndex - 1] = .remove(offset: offset, element: String(element) + lastElement, associatedWith: associatedWith)
                } else if lastOffset + lastElement.count == offset {
                    result[result.endIndex - 1] = .remove(offset: lastOffset, element: lastElement + String(element), associatedWith: lastAssociatedWith)
                } else {
                    result.append(.remove(offset: offset, element: String(element), associatedWith: associatedWith))
                }
                
            case let (_, .insert(offset, element, associatedWith)):
                result.append(.insert(offset: offset, element: String(element), associatedWith: associatedWith))
                
            case let (_, .remove(offset, element, associatedWith)):
                result.append(.remove(offset: offset, element: String(element), associatedWith: associatedWith))
            }
        }
    }
}

extension CollectionDifference.Change {
    
    var offset: Int {
        get {
            switch self {
            case let .insert(offset, _, _), let .remove(offset, _, _):
                return offset
            }
        }
        set {
            switch self {
            case let .insert(_, element, associatedWith):
                self = .insert(offset: newValue, element: element, associatedWith: associatedWith)
            case let .remove(_, element, associatedWith):
                self = .remove(offset: newValue, element: element, associatedWith: associatedWith)
            }
        }
    }
    
    var element: ChangeElement {
        get {
            switch self {
            case let .insert(_, element, _), let .remove(_, element, _):
                return element
            }
        }
        set {
            switch self {
            case let .insert(offset, _, associatedWith):
                self = .insert(offset: offset, element: newValue, associatedWith: associatedWith)
            case let .remove(offset, _, associatedWith):
                self = .remove(offset: offset, element: newValue, associatedWith: associatedWith)
            }
        }
    }
    
    var associatedWith: Int? {
        get {
            switch self {
            case let .insert(_, _, associatedWith), let .remove(_, _, associatedWith):
                return associatedWith
            }
        }
        set {
            switch self {
            case let .insert(offset, element, _):
                self = .insert(offset: offset, element: element, associatedWith: newValue)
            case let .remove(offset, element, _):
                self = .remove(offset: offset, element: element, associatedWith: newValue)
            }
        }
    }
    
    var type: CollectionDifference.ChangeType {
        get {
            switch self {
            case .insert: return .insert
            case .remove: return .remove
            }
        }
        set {
            switch newValue {
            case .remove:
                self = .remove(offset: offset, element: element, associatedWith: associatedWith)
            case .insert:
                self = .insert(offset: offset, element: element, associatedWith: associatedWith)
            }
        }
    }
}

extension CollectionDifference {
    
    enum ChangeType {
        
        case insert, remove
    }
    
    func union(with other: CollectionDifference) -> CollectionDifference {
        other
    }
}
