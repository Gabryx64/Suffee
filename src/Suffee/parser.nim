import ast
import strutils

proc suffee_parse*(tokens: seq[string], i: ref int): SuffeeASTNode =
    i[] -= 1
    while(i[] < tokens.len):
        i[] += 1

        var token: string = tokens[i[]]
        if(token == "("):
            i[] += 1
            if(i[] >= tokens.len or tokens[i[]] == ")"):
                return SuffeeASTNode()
            var identifier: string = tokens[i[]]
            i[] += 1
            var args: seq[SuffeeASTNode] = @[]
            
            while(i[] < tokens.len and tokens[i[]] != ")"):
                args.add(suffee_parse(tokens, i))
                i[] += 1
            
            if(i[] >= tokens.len):
                stderr.write("Expected character ')'\n")
                quit(-1)

            return SuffeeFuncCallASTNode(identifier: identifier, args: args)

        if(token[0] == '"'):
            if(token[token.high] != '"'):
                stderr.write("Expected character '\"'\n")
                quit(-1)

            return SuffeeStringASTNode(value: token.substr(1, token.high - 1))

        try:
            return SuffeeIntegerASTNode(value: token.parseInt())
        except ValueError:
            try:
                return SuffeeFloatASTNode(value: token.parseFloat())
            except ValueError:
                return SuffeeIdentifierASTNode(value: token)

