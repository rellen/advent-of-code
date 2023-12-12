let
  pkgs = import <nixpkgs> { };
  strings = pkgs.lib.strings;
  lists = pkgs.lib.lists;

  filterNonEmptyString = builtins.filter
    (x: !(builtins.isList x && builtins.length x == 0) && !(x == ""));
  splitDigit = builtins.split "[^0-9]";

  file = builtins.readFile ./input/day01.input;
  raw_lines = builtins.split "\n" file;
  lines = filterNonEmptyString raw_lines;

  calibrationValue = line:
    let
      rawNumbers = splitDigit line;
      numbers = filterNonEmptyString rawNumbers;
      joined = strings.concatStrings numbers;
      numberList = strings.stringToCharacters joined;
      firstAndLast = [ (builtins.head numberList) (lists.last numberList) ];
      calibrationValueStr = strings.concatStrings firstAndLast;

    in strings.toInt calibrationValueStr;

in builtins.foldl' (acc: elem: acc + (calibrationValue elem)) 0 lines
# in builtins.map calibrationValue lines
