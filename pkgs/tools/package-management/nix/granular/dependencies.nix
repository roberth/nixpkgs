# These overrides are applied to the dependencies of the Nix components.

{
  # The raw Nixpkgs, not affected by this scope
  pkgs,

  stdenv,
  version,
  src,
}:
let
  inherit (pkgs) lib;

  root = ./.;

  resolveRelPath = p: lib.path.removePrefix root p;

  resolvePath = p: src + "/${resolveRelPath p}";

  # fileset filtering is not possible without IFD on src, so we ignore the fileset
  # and produce a path containing _more_, but the extra files generally won't be
  # accessed.
  filesetToSource = { root, fileset }: src + "/${resolvePath root}";

  fetchedSourceLayer = finalAttrs: prevAttrs:
    let
      workDirPath =
        # Ideally we'd pick finalAttrs.workDir, but for now `mkDerivation` has
        # the requirement that everything except passthru and meta must be
        # serialized by mkDerivation, which doesn't work for this.
        prevAttrs.workDir;

      workDirSubpath = resolveRelPath workDirPath;
      # sources = assert prevAttrs.fileset._type == "fileset"; prevAttrs.fileset;
      # src = lib.fileset.toSource { fileset = sources; inherit root; };

    in
    {
      sourceRoot = "${src.name}/" + workDirSubpath;
      inherit src;

      # Clear what `derivation` can't/shouldn't serialize; see prevAttrs.workDir.
      fileset = null;
      workDir = null;
    };

in
scope: {
  inherit stdenv version;

  libseccomp = pkgs.libseccomp.overrideAttrs (_: rec {
    version = "2.5.5";
    src = pkgs.fetchurl {
      url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
      hash = "sha256-JIosik2bmFiqa69ScSw0r+/PnJ6Ut23OAsHJqiX7M3U=";
    };
  });

  boehmgc = pkgs.boehmgc.override {
    enableLargeConfig = true;
  };

  # FIXME
  libgit2 = pkgs.libgit2.overrideAttrs (attrs: {
    cmakeFlags = attrs.cmakeFlags or []
      ++ [ "-DUSE_SSH=exec" ];
  });

  busybox-sandbox-shell = pkgs.busybox-sandbox-shell or (pkgs.busybox.override {
    useMusl = true;
    enableStatic = true;
    enableMinimal = true;
    extraConfig = ''
      CONFIG_FEATURE_FANCY_ECHO y
      CONFIG_FEATURE_SH_MATH y
      CONFIG_FEATURE_SH_MATH_64 y

      CONFIG_ASH y
      CONFIG_ASH_OPTIMIZE_FOR_SIZE y

      CONFIG_ASH_ALIAS y
      CONFIG_ASH_BASH_COMPAT y
      CONFIG_ASH_CMDCMD y
      CONFIG_ASH_ECHO y
      CONFIG_ASH_GETOPTS y
      CONFIG_ASH_INTERNAL_GLOB y
      CONFIG_ASH_JOB_CONTROL y
      CONFIG_ASH_PRINTF y
      CONFIG_ASH_TEST y
    '';
  });

  inherit resolvePath filesetToSource;

  mkMesonDerivation = f: stdenv.mkDerivation (lib.extends fetchedSourceLayer f);
}
