import Foundation

public struct Repeat<Element, MaskOutput>: CustomMaskComponent {
    
    private let range: Range<UInt>
    private let element: Mask<Element>
    private let map: ([Element]) -> MaskOutput
    
    public var editableCharacters: CharacterSet {
        range.upperBound < 2 ? CharacterSet() : element.editableCharacters
    }
    
    public var fixedCharacters: CharacterSet {
        range.lowerBound < 2 ? CharacterSet() : element.fixedCharacters
    }
    
    public func allowedCharacters(
        offset: Int,
        for input: String,
        startAt index: String.Index,
        outOfRange: (Int) -> CharacterSet
    ) -> CharacterSet {
        var wasOut = false
        var count: Int?
        let fullOffset = offset
        func chars(offset: Int, i: UInt) -> CharacterSet {
            guard range.upperBound > i else {
                wasOut = true
                return outOfRange(offset)
            }
            return element.allowedCharacters(
                offset: offset,
                for: input,
                startAt: index
            ) { offset in
                if count == nil, i >= range.lowerBound {
                    count = fullOffset - offset
                }
                return chars(offset: offset, i: i + 1)
            }
        }
        var result = chars(offset: offset, i: 1)
        if !wasOut, let count {
            result = result.union(outOfRange(offset % count))
        }
        return result
    }
    
    public func output(from input: String, startAt index: inout String.Index) throws -> MaskOutput {
        let initalIndex = index
        var outputs: [Element] = []
        var err: Error?
        while UInt(outputs.count) < range.upperBound, err == nil {
            do {
                let value = try element.output(from: input, startAt: &index)
                outputs.append(value)
            } catch {
                err = error
            }
        }
        guard range.contains(UInt(outputs.count)) else {
            index = initalIndex
            throw err ?? MaskError.countOutOfRange(outputs.count, range)
        }
        return map(outputs)
    }
    
    public func pattern(placeholder: Character) -> String? {
        if range.count == 1 {
            return element.pattern(placeholder: placeholder)
        }
        return nil
    }
}

public extension Repeat {
    
    init<R: RangeExpression>(
        _ range: R,
        @MaskBuilder _ mask: () -> Mask<Element>,
        map: @escaping ([Element]) -> MaskOutput
    ) where R.Bound == UInt {
        self.init(
            range: range.relative(to: AllUInt()),
            element: mask(),
            map: map
        )
    }
    
    init(
        _ count: UInt,
        @MaskBuilder _ mask: () -> Mask<Element>,
        map: @escaping ([Element]) -> MaskOutput
    ) {
        self.init(
            range: count..<(count + 1),
            element: mask(),
            map: map
        )
    }
}

public extension Repeat where Element == Character, MaskOutput == String {
    
    init<R: RangeExpression>(
        _ range: R,
        @MaskBuilder _ mask: () -> Mask<Element>
    ) where R.Bound == UInt {
        self.init(range, mask) {
            String($0)
        }
    }
    
    init(
        _ count: UInt,
        @MaskBuilder _ mask: () -> Mask<Element>
    ) {
        self.init(count, mask) {
            String($0)
        }
    }
    
    init<R: RangeExpression>(
        _ characterSet: CharacterSet,
        _ range: R
    ) where R.Bound == UInt {
        self.init(range) {
            characterSet
        } map: {
            String($0)
        }
    }
    
    init(
        _ characterSet: CharacterSet,
        _ count: UInt
    ) {
        self.init(count) {
            characterSet
        } map: {
            String($0)
        }
    }
}

public extension Repeat where Element == String, MaskOutput == String {
    
    init<R: RangeExpression>(
        _ range: R,
        @MaskBuilder _ mask: () -> Mask<Element>
    ) where R.Bound == UInt {
        self.init(range, mask) {
            $0.joined()
        }
    }
    
    init(
        _ count: UInt,
        @MaskBuilder _ mask: () -> Mask<Element>
    ) {
        self.init(count, mask) {
            $0.joined()
        }
    }
}

private struct AllUInt: Collection {
    
    var startIndex: UInt { 0 }
    var endIndex: UInt { .max }
    
    subscript(position: UInt) -> UInt {
        position
    }
    
    func index(after i: UInt) -> UInt {
        i + 1
    }
}
