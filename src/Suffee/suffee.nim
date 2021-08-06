import tokenizer
import parser
import ast
import visitor

proc suffee_compile*(src: string): string =
    let tokens: seq[string] = suffee_tokenize(src)

    var i: ref int = new int
    i[] = 0
    var root: SuffeeCompoundASTNode = SuffeeCompoundASTNode(nodes: @[])
    while(i[] < tokens.len):
        root.nodes.add(suffee_parse(tokens, i))
        i[] += 1

    suffee_reset_visitor()
    return suffee_visit(root)
