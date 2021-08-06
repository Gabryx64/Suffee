import ast

import sets
import hashes

type
    SuffeeBaseType* = enum
        SUFFEE_TYPE_VOID, SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT, SUFFEE_TYPE_STRING, SUFFEE_TYPE_ID, SUFFEE_TYPE_FUNC, SUFFEE_TYPE_TYPENAME, SUFFEE_TYPE_ANY

    SuffeeType* = object
        base_type*: seq[SuffeeBaseType]
        array_level*: int
        is_inf*: bool

    SuffeeVisitorState* = object
        error*: string
        vars*: HashSet[(SuffeeType, string, bool)]
        funcs*: HashSet[(SuffeeType, string, seq[SuffeeType], bool)]

proc hash[T: SuffeeType](x: T): Hash =
    var ret: Hash = 0
    for a in x.base_type:
        ret = ret !& hash([(int)a, x.array_level].toOpenArray(0, 1))
    return !$ret

var visitor_state: SuffeeVisitorState =
    SuffeeVisitorState(
        error: "",
        vars:
        [
            # Built In Variables
            (SuffeeType(base_type: @[ SUFFEE_TYPE_STRING ], array_level: 1), "args", true),
        ].toHashSet(),
        funcs:
        [
            # Built In Functions
            (SuffeeType(), "def",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_ID, SUFFEE_TYPE_FUNC ]), SuffeeType(base_type: @[ SUFFEE_TYPE_TYPENAME ]), SuffeeType(base_type: @[ SUFFEE_TYPE_ANY ]) ], true),

            (SuffeeType(), "set",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_ID ]), SuffeeType(base_type: @[ SUFFEE_TYPE_ANY ]) ], true),

            (SuffeeType(), "print",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_ANY ], is_inf: true) ], true),

            (SuffeeType(), "println",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_ANY ], is_inf: true) ], true),

            # Operators
            (SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT, SUFFEE_TYPE_STRING ]), "+",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT, SUFFEE_TYPE_STRING ], is_inf: true) ], true),

            (SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]), "-",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ], is_inf: true) ], true),

            (SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]), "*",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ], is_inf: true) ], true),

            (SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]), "/",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ], is_inf: true) ], true),

            (SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]), "%",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]), SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]) ], true),

            (SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]), "**",
             @[ SuffeeType(base_type: @[ SUFFEE_TYPE_INT, SUFFEE_TYPE_FLOAT ]), SuffeeType(base_type: @[ SUFFEE_TYPE_INT ]) ], true),
        ].toHashSet())

var default_visitor_state: SuffeeVisitorState = visitor_state

proc suffee_reset_visitor*(): void =
    visitor_state = default_visitor_state

proc suffee_visit*(root: SuffeeCompoundASTNode): string =
    var ret: string = ""

    for node in root.nodes:
        if(not (node of SuffeeFuncCallASTNode)):
            stderr.write("Expected expression\n")
            quit(-1)

    return ret
