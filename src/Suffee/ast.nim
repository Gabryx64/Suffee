type
    SuffeeASTNode* = ref object of RootObj

    SuffeeFuncCallASTNode* = ref object of SuffeeASTNode
        identifier*: string
        args*: seq[SuffeeASTNode]

    SuffeeIntegerASTNode* = ref object of SuffeeASTNode
        value*: int

    SuffeeFloatASTNode* = ref object of SuffeeASTNode
        value*: float

    SuffeeStringASTNode* = ref object of SuffeeASTNode
        value*: string

    SuffeeIdentifierASTNode* = ref object of SuffeeASTNode
        value*: string

    SuffeeCompoundASTNode* = ref object of SuffeeASTNode
        nodes*: seq[SuffeeASTNode]

proc print*(node: SuffeeASTNode, prefix: string = ""): void =
    var next_prefix = ""
    if(prefix == ""):
        next_prefix = "»   "
    else:
        next_prefix = "»   " & prefix

    if(node of SuffeeFuncCallASTNode):
        echo(prefix, "FUNC_CALL:`", ((SuffeeFuncCallASTNode)node).identifier, '`')
        for arg in ((SuffeeFuncCallASTNode)node).args:
            arg.print(next_prefix)
    elif(node of SuffeeIntegerASTNode):
        echo(prefix, "INT:`", ((SuffeeIntegerASTNode)node).value, '`')
    elif(node of SuffeeFloatASTNode):
        echo(prefix, "FLOAT:`", ((SuffeeFloatASTNode)node).value, '`')
    elif(node of SuffeeStringASTNode):
        echo(prefix, "STR:\"", ((SuffeeStringASTNode)node).value, '"')
    elif(node of SuffeeIdentifierASTNode):
        echo(prefix, "ID:`", ((SuffeeIdentifierASTNode)node).value, '`')
    elif(node of SuffeeCompoundASTNode):
        echo(prefix, "COMPOUND:\n{")
        for i in 0 ..< ((SuffeeCompoundASTNode)node).nodes.len:
            ((SuffeeCompoundASTNode)node).nodes[i].print(next_prefix)
            if(i != ((SuffeeCompoundASTNode)node).nodes.high):
                echo()
        echo(prefix, "}")
    else:
        echo(prefix, "NOOP")
