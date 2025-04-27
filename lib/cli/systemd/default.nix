{ lib }:
let
  inherit (lib)
    concatMapStringsSep
    isDerivation
    isFloat
    isInt
    isPath
    isString
    replaceStrings
    ;
  inherit (lib.cli.systemd)
    escapeSystemdExecArg
    ;
  inherit (builtins)
    toJSON
    ;
in
{
  # Quotes an argument for use in Exec* service lines.
  # systemd accepts "-quoted strings with escape sequences, toJSON produces
  # a subset of these.
  # Additionally we escape % to disallow expansion of % specifiers. Any lone ;
  # in the input will be turned it ";" and thus lose its special meaning.
  # Every $ is escaped to $$, this makes it unnecessary to disable environment
  # substitution for the directive.
  escapeSystemdExecArg =
    arg:
    let
      s =
        if isPath arg then
          "${arg}"
        else if isString arg then
          arg
        else if isInt arg || isFloat arg || isDerivation arg then
          toString arg
        else
          throw "escapeSystemdExecArg only allows strings, paths, numbers and derivations";
    in
    replaceStrings [ "%" "$" ] [ "%%" "$$" ] (toJSON s);

  # Quotes a list of arguments into a single string for use in a Exec*
  # line.
  escapeSystemdExecArgs = concatMapStringsSep " " escapeSystemdExecArg;
}
