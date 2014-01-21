# Sudoku solver
# Based on Peter Norvig"s work
# http://norvig.com/sudoku.html

import tables

# Cross product of elements in A and elements in B
proc echoSeqStr(seqStr: seq[string]) =
  for theStr in seqStr:
    echo theStr

proc cross(A: string, B: string): seq[string] =
  result = @[]
  for i in A:
    for j in B:
      result.add(i & j)

proc strCharCross(A: string, B: char): seq[string] =
  result = @[]
  for i in A:
    result.add(i & B)

proc charStrCross(A: char, B: string): seq[string] =
  result = @[]
  for j in B:
    result.add(A & j)

proc getPuzzle(fname: string): string =
  let puzzStr = readFile(fname)
  return puzzStr

proc seqStrToStr(inSeq: seq[string]): string =
  result = "["
  for i in countup(0, len(inSeq) - 2):
    result &= inSeq[i]
    result &= ", "
  result &= inSeq[len(inSeq) - 1]
  result &= "]"

proc seqSeqStrToStr(inSeq: seq[seq[string]]): string =
  result = "[\n "
  for i in countup(0, len(inseq) - 2):
    result &= seqStrToStr(inSeq[i])
    result &= ",\n "
  result &= seqStrToStr(inSeq[len(inSeq) - 1])
  result &= "\n]"

let digits = "123456789"
let rows = "ABCEDFGHI"
let cols = digits
let squares = cross(rows, cols)

# Initialize unitlist
var unitlist: seq[seq[string]] = @[]

for c in cols:
  unitlist.add(strCharCross(rows, c))
for r in rows:
  unitlist.add(charStrCross(r, cols))
for rs in ["ABC", "DEF", "GHI"]:
  for cs in ["123", "456", "789"]:
    unitlist.add(cross(rs, cs))

# Initialize units
var units = initTable[string, seq[string]]()
for s in squares:
  var entry: seq[string] = @[]
  for unit in unitlist:
    if s in unit:
      entry.add(unit)
  units[s] = entry

# Initialize peers
# var peers = initTable[string, seq[string]]()
# for s in squares:
#   var entry: seq[string] = @[]
#   for unit in units[s]:
#     for peer in unit:
#       echo peer
#       echo unit
#   peers[s] = entry

echo seqSeqStrToStr(@[@["1", "2", "3"],@["a", "bc", "de"]])

# A set of unit tests
proc test() =
  # Correct number of squares
  assert len(squares) == 81
  # Correct number of units
  assert len(unitlist) == 27
  # Each square is in three units
  var assertvar = true
  for s in squares:
    assertvar = assertvar and len(units[s]) == 3
  #assert assertvar



test()