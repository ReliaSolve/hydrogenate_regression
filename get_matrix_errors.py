import re, sys
from os import walk

# Contains a regular expression to run on the error file and a Boolean that tells
# whether to ignore the files that match this regular expression.
BehaviorTable = [
  [ re.compile(r".*'<' not supported between instances of.*",flags=re.DOTALL), False ],
  [ re.compile(r".*KeyError:.*",flags=re.DOTALL), False ],
  [ re.compile(r".*One or more rotation matrices is not proper.*",flags=re.DOTALL), False ],
  [ re.compile(r".*Unknown chemical element type.*",flags=re.DOTALL), True ],
  [ re.compile(r".*CCTBX_ASSERT\(j_sym >= 0\) failure.*",flags=re.DOTALL), False ],
  [ re.compile(r".*Conflicting bond_simple restraints.*",flags=re.DOTALL), False ],
  [ re.compile(r".*Unit cell volume is incompatible with number of atoms.*",flags=re.DOTALL), True ],
  [ re.compile(r".*0 model\(s\) found.*",flags=re.DOTALL), False ],
  [ re.compile(r".*It looks like angle restraints involving.*",flags=re.DOTALL), False ],
  [ re.compile(r".*number of groups of duplicate atom labels.*",flags=re.DOTALL), False ],
  [ re.compile(r".*Conflicting angle restraints.*",flags=re.DOTALL), False ],
  [ re.compile(r".*'place_hydrogens' object has no attribute 'sl_removed'.*",flags=re.DOTALL), False ],
  [ re.compile(r".*bond_simple = gpr.bond_simple.proxies\[i_seqs\[k\]\].*",flags=re.DOTALL), False ],
  [ re.compile(r".*Use 'allow_polymer_cross_special_position=True' to keep going.*",flags=re.DOTALL), False ],
  [ re.compile(r".*'NoneType' object has no attribute 'h_parameterization'.*",flags=re.DOTALL), False ],
  [ re.compile(r".*Bad helix length. Check HELIX records.*",flags=re.DOTALL), False ],
  [ re.compile(r".*assert cs.space_group\(\) is not None.*",flags=re.DOTALL), False ],
  [ re.compile(r".*Don't know how to deal with helices with multiple chain IDs.*",flags=re.DOTALL), False ],
]

BASEDIR = "outputs_stored_9_10_2021"

def main():

  # Get the list of files in the outputs directory
  outFiles = next(walk(BASEDIR), (None, None, []))[2]  # [] if no file

  # Get the files with "_error" in their names.
  errFiles = [f for f in outFiles if "_error" in f]

  # Make a dictionary of sets with an entry for -1 and all indices.
  groups = {}
  groups[-1] = set()
  for i in range(len(BehaviorTable)):
    groups[i] = set()

  # Find the index of each file in the BehaviorTable, storing -1 for no match.
  # Add all results into each group.
  indices = {}
  data = {}
  for f in errFiles:
    inFile = open(BASEDIR+"/"+f, "r")
    data[f] = inFile.read()
    indices[f] = -1
    for i,e in enumerate(BehaviorTable):
      if e[0].match(data[f]):
        indices[f] = i
        break
    groups[indices[f]].add(f)
    if indices[f] == 2:
      print(f[:4])

main()
