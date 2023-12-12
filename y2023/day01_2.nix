let
  pkgs = import <nixpkgs> { };
  strings = pkgs.lib.strings;
  lists = pkgs.lib.lists;

  filterNonEmptyString = builtins.filter
    (x: !(builtins.isList x && builtins.length x == 0) && !(x == ""));

  splitDigit = builtins.split "[^0-9]";

  calibrationValue = line:
    let
      replaced = builtins.replaceStrings [
        "oneight"
        "twone"
        "threeight"
        "fiveight"
        "sevenine"
        "eightwo"
        "eighthree"
        "nineight"
        "one"
        "two"
        "three"
        "four"
        "five"
        "six"
        "seven"
        "eight"
        "nine"
      ] [
        "18"
        "21"
        "38"
        "58"
        "79"
        "82"
        "83"
        "98"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
      ] line;
      rawNumbers = splitDigit replaced;
      numbers = filterNonEmptyString rawNumbers;
      joined = strings.concatStrings numbers;
      numberList = strings.stringToCharacters joined;
      firstAndLast = [ (builtins.head numberList) (lists.last numberList) ];
      calibrationValueStr = strings.concatStrings firstAndLast;

    in strings.toInt calibrationValueStr;
  # in [ line replaced ];

  file = builtins.readFile ./input/day01.input;
  raw_lines = builtins.split "\n" file;
  lines = filterNonEmptyString raw_lines;

in builtins.foldl' (acc: elem: acc + (calibrationValue elem)) 0 lines
# in builtins.map calibrationValue lines
