let
  keys = import ../public-keys.nix;
  all = [keys.stravinsky.system keys.stravinsky.brabier keys.bach.system];
in {
  "git.age".publicKeys = all;
}
