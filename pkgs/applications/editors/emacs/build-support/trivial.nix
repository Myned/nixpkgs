# trivial builder for Emacs packages

{ callPackage, lib, ... }@envargs:

let
  libBuildHelper = import ./lib-build-helper.nix { inherit lib; };
in

libBuildHelper.extendMkDerivation { } (callPackage ./generic.nix envargs) (finalAttrs:

{ pname
, version
, src
, ...
}@args:

{
  buildPhase = args.buildPhase or ''
    runHook preBuild

    emacs -L . --batch -f batch-byte-compile *.el

    runHook postBuild
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    LISPDIR=$out/share/emacs/site-lisp
    install -d $LISPDIR
    install *.el *.elc $LISPDIR

    runHook postInstall
  '';
}

)
