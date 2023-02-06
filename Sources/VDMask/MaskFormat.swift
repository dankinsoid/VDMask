import Foundation

public extension Mask {
    
    func format(string: inout String) throws -> MaskOutput {
        try format(current: "", new: &string)
    }
    
    func format(current currentString: String, new newString: inout String) throws -> MaskOutput {
//        let differences = newString.difference(from: currentString).joined()
//        var ranges: [Range<String.Index>] = []
//        var start = newString.startIndex
//
//        "+7 (ddd) ddd-dd-dd"
//
//        "1" "d"
//        "10" "dd"
//        "100" "ddd"
//        "1000" "d ddd"
//        "1 000" + "0" "dd ddd"
//
//        var old = ""
//        let new = "9"
//
//        var index = startIndex
//        var clear = ""
//
//        var offset = 0
//        var removedDifs
//
//        for char in old {
//            if !symbolsAllowedFor(offset: offset, input: old).isExactly(char) {
//                clear += char
//            } else {
//                for i in oldDifs.indecies where oldDifs[i].offset >= offset {
//                    newDifs[i].offset -= 1
//                }
//            }
//            offset += 1
//        }
//
//        for dif in newDifs {
//
//        }
//
//        "+7 (___) ___-__-__"
//        "10 000 000 000.00"
//        "4111 1111 1111 1111"
//        "Danil Voidilov"
//        "1234 AB 1233"
//
//        return try output(from: newString, startAt: &start)
        throw MaskError.invalidString("", message: "")
    }
}

private struct IncorrectIndex: Error {
}

func mask() {
    let mask = Mask {
        "+7 ("
        Repeat("0"..."9", 3)
        ") "
        Repeat("0"..."9", 3)
        "-"
        Repeat("0"..."9", 2)
        "-"
        OneOf {
            Repeat(2) {
                "0"..."9"
            }
            Repeat("0"..."9", 2)
        }
    }
}
