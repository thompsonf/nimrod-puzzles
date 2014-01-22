# Sudoku solver
# Based on Peter Norvig's Python solver
# http://norvig.com/sudoku.html

import tables
import algorithm
import strutils

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

proc `$` (inSeq: seq[string]): string =
  result = "["
  for i in countup(0, len(inSeq) - 2):
    result &= inSeq[i]
    result &= ", "
  result &= inSeq[len(inSeq) - 1]
  result &= "]"

proc `$` (inSeq: seq[seq[string]]): string =
  result = "[\n "
  for i in countup(0, len(inseq) - 2):
    result &= $inSeq[i]
    result &= ",\n "
  result &= $inSeq[len(inSeq) - 1]
  result &= "\n]"

let digits = "123456789"
let rows = "ABCDEFGHI"
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
var units = initTable[string, seq[seq[string]]]()
for s in squares:
  var entry: seq[seq[string]] = @[]
  for unit in unitlist:
    if s in unit:
      entry.add(unit)
  units[s] = entry

# Initialize peers
var peers = initTable[string, seq[string]]()
for s in squares:
  var entry: seq[string] = @[]
  for unit in units[s]:
    for peer in unit:
      if not (peer in entry) and peer != s:
        entry.add(peer)
  peers[s] = entry

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
  assert assertvar
  # Units of C2
  assert units["C2"] == @[@["A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2", "I2"],
                          @["C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9"],
                          @["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"]]
  assert peers["C2"] == @["A2", "B2", "D2", "E2", "F2", "G2", "H2", "I2", "C1", "C3",
                         "C4", "C5", "C6", "C7", "C8", "C9", "A1", "A3", "B1", "B3"]
  echo "All tests pass."

proc load_grid(fname: string): string =
  result = readFile(fname)

proc grid_values(grid: string): TTable[string, char] =
  result = initTable[string, char]()
  var temp = squares
  reverse(temp)
  for c in grid:
    case c
    of '0','1','2','3','4','5','6','7','8','9':
      result[pop(temp)] = c
    of '.':
      result[pop(temp)] = '0'
    else: nil
  assert len(result) == 81

proc eliminate(values: var TTable[string, string], square: string, digit: char): bool =
  if not digit in values[square]:
    


# proc assign(values: var TTable[string, string], square: string, digit: char): bool =



# proc parse_grid(grid: string): TTable[string, string] =
#   result = initTable[string, string]()
#   for square, digit in grid_values(grid):
#     if digit != '0':
#       if not assign(values, square, digit):
#         return nil

proc test(tbl: var TTable[string, string]) =
  echo "in test"
  tbl["A2"] = ""
  echo tbl["A2"]

let grid_str = load_grid("simple.txt")
#let pg = parse_grid(grid_str)
#echo pg["A5"]