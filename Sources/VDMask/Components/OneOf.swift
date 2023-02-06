import Foundation

public struct OneOf<MaskOutput>: CustomMaskComponent {
    
    public var masks: [Mask<MaskOutput>]
    
    public var editableCharacters: CharacterSet {
        masks.reduce(CharacterSet()) { $0.union($1.editableCharacters) }
    }
    
    public var fixedCharacters: CharacterSet {
        masks.reduce(CharacterSet()) { $0.union($1.fixedCharacters) }
    }
    
    public func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet {
        masks.map {
            matches(input: input, startAt: index, outOfRange: outOfRange, maxOffset: offset, mask: $0)
        }.filter {
            $0.0 == offset
        }.reduce(CharacterSet()) { partialResult, tuple in
            partialResult.union(tuple.1)
        }
    }
    
    public func pattern(placeholder: Character) -> String? {
        if masks.count == 1 {
            return masks[0].pattern(placeholder: placeholder)
        }
        return nil
    }
    
    public func output(from input: String, startAt index: inout String.Index) throws -> MaskOutput {
        var err: Error?
        for mask in masks where matches(input: input, startAt: index, mask: mask).0 > 0 {
            do {
                return try output(from: input, startAt: &index)
            } catch {
                err = error
            }
        }
        throw masks.count == 1 ? (err ?? MaskError.noValidValues) : MaskError.noValidValues
    }
    
    private func matches(
        input: String,
        startAt index: String.Index,
        outOfRange: (Int) -> CharacterSet = { _ in CharacterSet() },
        maxOffset: Int? = nil,
        mask: Mask<MaskOutput>
    ) -> (Int, CharacterSet) {
        var offset = 0
        var i = input.index(index, offsetBy: offset)
        var set = mask.allowedCharacters(offset: offset, for: input, startAt: index, outOfRange: outOfRange)
        while
            input.indices.contains(i),
            set.contains(input[i]),
            offset <= (maxOffset ?? offset)
        {
            offset += 1
            set = mask.allowedCharacters(offset: offset, for: input, startAt: index, outOfRange: outOfRange)
            i = input.index(index, offsetBy: offset)
        }
        return (offset, set)
    }
}

public extension OneOf {
    
    init(@OneOfBuilder<MaskOutput> _ masks: () -> [Mask<MaskOutput>]) {
        self.init(masks: masks())
    }
}

@resultBuilder
public enum OneOfBuilder<Output> {
    
    @inlinable
    public static func buildPartialBlock<Output>(first content: [Mask<Output>]) ->  [Mask<Output>] {
        content
    }
    
    @inlinable
    public static func buildPartialBlock(accumulated: [Mask<Output>], next: [Mask<Output>]) -> [Mask<Output>] {
        accumulated + next
    }
    
    @inlinable
    public static func buildArray(_ components: [[Mask<Output>]]) -> [Mask<Output>] {
        Array(components.joined())
    }
    
    @inlinable
    public static func buildOptional(_ component: [Mask<Output>]?) -> [Mask<Output>] {
        component ?? []
    }
    
    @inlinable
    public static func buildEither(first component: [Mask<Output>]) -> [Mask<Output>] {
        component
    }
    
    @inlinable
    public static func buildEither(second component: [Mask<Output>]) -> [Mask<Output>] {
        component
    }
    
    @inlinable
    public static func buildLimitedAvailability(_ component: [Mask<Output>]) -> [Mask<Output>] {
        component
    }
    
    @inlinable
    public static func buildExpression(_ expression: some MaskComponent<Output>) -> [Mask<Output>] {
        [expression.mask]
    }
}
