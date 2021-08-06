import Suffee/suffee
import Suffee/ast
import strformat
import os

when(isMainModule):
  if(paramCount() != 1):
    stderr.write(fmt"Usage: { paramStr(0) } <filename>{ '\n' }")
    quit(-1)
  
  echo(suffee_compile(readFile(paramStr(1))))
