import strutils

proc suffee_tokenize*(src: string): seq[string] =
    var ret: seq[string] = @[]

    var i: int = -1
    while(true):
        i += 1
        if(i >= src.len):
            break

        var ch: char = src[i]
        case(ch):
            of Whitespace:
                continue

            of '[', ']', '{', '}', '(', ')', '\'', '`', '~', '^', '@',:
                if(ch == '~' and i + 1 < src.len and src[i + 1] == '@'):
                    i += 1
                    ret.add("~@")
                else:
                    ret.add($ch)
            
            of '"':
                var str: string = "\""
                i += 1
                while(i < src.len and src[i] != '"'):
                    str.add(src[i])
                    if(i + 1 < src.len and src[i] == '\\'):
                        i += 1
                        str.add(src[i])
                    i += 1
                ret.add(str & "\"")

            of ';':
                while(i < src.len and not (src[i] in Newlines)):
                    i += 1

            else:
                var str: string = ""
                while(i < src.len and not (src[i] in "[]{}()'`~^@\"" or src[i] in Whitespace)):
                    str.add(src[i])
                    i += 1
                i -= 1
                ret.add(str)

    return ret
