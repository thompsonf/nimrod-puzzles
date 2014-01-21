proc getPuzzle(fname: string): string =
  let puzzStr = readFile(fname)
  return puzzStr

echo getPuzzle("simple.txt")