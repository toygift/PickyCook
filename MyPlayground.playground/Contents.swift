//: Playground - noun: a place where people can play



import UIKit

var str:NSString = "한글테스트"

var _out:NSString = ""
for i in 0 ..< 1 {
    var oneChar:UniChar = str.character(at: i)
    if (oneChar >= 0xAC00 && oneChar <= 0xD7A3){
        var firstCodeValue = ((oneChar - 0xAC00)/28)/21
        firstCodeValue += 0x1100;
        _out = _out.appendingFormat("%C", firstCodeValue)
        print(_out)
    }
}
