let
  # Function to split a string on any numeric character
  splitOnNumbers = str: builtins.split "[^0-9]" str;

  # Your list of strings
  myStrings =
    [ "string1with2numbers" "another3string4example" "text5with6digits" ];

  # Apply splitOnNumbers to each element of myStrings
  splittedStrings = builtins.map splitOnNumbers myStrings;
in builtins.deepSeq splittedStrings splittedStrings
