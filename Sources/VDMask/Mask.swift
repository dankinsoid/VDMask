import Foundation

public struct Mask<MaskOutput>: CustomMaskComponent {
    
    public let editableCharacters: CharacterSet
    public let fixedCharacters: CharacterSet
    
    private let _allowedCharacters: (_ offset: Int, _ input: String, _ index: String.Index, _ outOfRange: (Int) -> CharacterSet) -> CharacterSet
    private let _output: (_ input: String, _ index: inout String.Index) throws -> MaskOutput
    private let _pattern: (_ placeholder: Character) -> String?
    
    init(
        editableCharacters: CharacterSet,
        fixedCharacters: CharacterSet,
        _allowedCharacters: @escaping (_ offset: Int, _ input: String, _ index: String.Index, _ outOfRange: (Int) -> CharacterSet) -> CharacterSet,
        _pattern: @escaping (_ placeholder: Character) -> String?,
        _output: @escaping (String, inout String.Index) throws -> MaskOutput
    ) {
        self.editableCharacters = editableCharacters
        self.fixedCharacters = fixedCharacters
        self._allowedCharacters = _allowedCharacters
        self._output = _output
        self._pattern = _pattern
    }
    
    public var mask: Mask<MaskOutput> {
        self
    }
    
    public func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet {
        _allowedCharacters(offset, input, index, outOfRange)
    }
    
    public func output(from input: String, startAt index: inout String.Index) throws -> MaskOutput {
        try _output(input, &index)
    }
    
    public func pattern(placeholder: Character) -> String? {
        _pattern(placeholder)
    }
}

public extension Mask<[String]> {
    
    func joined() -> Mask<String> { map { $0.joined() } }
}

public extension Mask<[Character]> {
    
    func joined() -> Mask<String> { map { String($0) } }
}

public extension Mask<(String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)" } }
}

public extension Mask<(String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)" } }
}

public extension Mask<(String, String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)\($3)" } }
}

public extension Mask<(String, String, String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)\($3)\($4)" } }
}

public extension Mask<(String, String, String, String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)\($3)\($4)\($5)" } }
}

public extension Mask<(String, String, String, String, String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)\($3)\($4)\($5)\($6)" } }
}

public extension Mask<(String, String, String, String, String, String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)\($3)\($4)\($5)\($6)\($7)" } }
}

public extension Mask<(String, String, String, String, String, String, String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)\($3)\($4)\($5)\($6)\($7)\($8)" } }
}

public extension Mask<(String, String, String, String, String, String, String, String, String, String)> {
    
    func joined() -> Mask<String> { map { "\($0)\($1)\($2)\($3)\($4)\($5)\($6)\($7)\($8)\($9)" } }
}

public extension Mask {
    
    init(_ maskFormatter: some CustomMaskComponent<MaskOutput>) {
        self.init(
            editableCharacters: maskFormatter.editableCharacters,
            fixedCharacters: maskFormatter.fixedCharacters,
            _allowedCharacters: maskFormatter.allowedCharacters,
            _pattern: maskFormatter.pattern,
            _output: maskFormatter.output
        )
    }
    
    init(@MaskBuilder _ build: () -> Mask) {
        self = build()
    }
}

public extension Mask {
    
    func map<T>(_ transform: @escaping (MaskOutput) throws -> T) -> Mask<T> {
        let mask = self.mask
        return Mask<T>(
            editableCharacters: mask.editableCharacters,
            fixedCharacters: mask.fixedCharacters,
            _allowedCharacters: mask.allowedCharacters,
            _pattern: mask.pattern
        ) { [mask] input, index in
            try transform(mask.output(from: input, startAt: &index))
        }
    }
    
    var erased: Mask<String> {
        let mask = self.mask
        return Mask<String>(
            editableCharacters: mask.editableCharacters,
            fixedCharacters: mask.fixedCharacters,
            _allowedCharacters: mask.allowedCharacters,
            _pattern: mask.pattern
        ) { [mask] input, index in
            let start = index
            _ = try mask.output(from: input, startAt: &index)
            return String(input[start..<index])
        }
    }
}

public extension Mask<String> {
        
    init(_ mask: String, _ placeholders: [Character: CharacterSet] = ["#": .any]) {
        var masks: [Mask<String>] = []
        var string = ""
        var count: UInt = 0
        var lastSet: CharacterSet?
        
        for char in mask {
            if let set = placeholders[char] {
                if !string.isEmpty {
                    masks.append(string.mask.map { "" })
                    string = ""
                }
                if let lastSet, lastSet != set {
                    masks.append(Repeat(lastSet, count).mask)
                    count = 0
                }
                count += 1
                lastSet = set
            } else {
                if let lastSet {
                    masks.append(Repeat(lastSet, count).mask)
                    count = 0
                }
                lastSet = nil
                string.append(char)
            }
        }
        if !string.isEmpty {
            masks.append(string.mask.map { "" })
        }
        if let lastSet {
            masks.append(Repeat(lastSet, count).mask)
        }
        if masks.isEmpty {
            self = Constant("").mask
        } else {
            self = masks.dropFirst().reduce(masks[0]) { partialResult, mask in
                SequenceMask(first: partialResult, second: mask, map: +).mask
            }
        }
    }
}
