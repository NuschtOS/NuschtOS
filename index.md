# NüschtOS

## Creating package

#### Example meta section

```nix
{
  meta = with stdenv.lib; {
    description = "A not to long description";
    longDescription = ''
      A bit more lengthy description
      convering multiple
      lines
    '';
    homepage = "nüschtos.de";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
```

#### Installing man pages and shell completion scripts

```nix
{ installShellFiles }:

rec {
  postInstall = ''
    installManPage man/man1/*
    installShellCompletion shellCompletion.sh
  '';
}
```

#### Using pytest

```nix
{
  checkInputs = [ pytestCheckHook ];

  disabledTests = [ "test_examples" "test_issue_22" ];
  
  pytestFlagsArray = [ "--ignore=Examples" ];
}
```

#### Move to seperate output

```nix
{
  outputs = [ "out" "dev" ]; # or meta

  postInstall = ''
    moveToOutput "bin/xmlsec1-config" "$dev"
  '';

meta = {
  outputsToInstall = [ "out" "dnsutils" "host" ];
}
```

#### Keeping a failed nix-build and changing into

```shell
nix-build --builders '' -K -A package
# path to the kept build directory under /tmp is shown
export out=/tmp/nix-build-package-1.0.0.drv-0
# the following might be required if you run into permission issues
sudo chown $USER:$USER -R $out
nix-shell -E --pure 'with import ./. { }; package'
bash --rcfile $out/env-vars
cd $out/
export TMP=$PWD TMPDIR=$PWD
# start debugging
buildPhase
...
```

#### breakpointHook

```nix
{
  buildInputs = [ breakpointHook ];
}
```

#### Compile a static package or link with musl

```shell
nix-build -A pkgsStatic.package
nix-build -A pkgsMusl.package
```

#### Rebase a branch on staging

Replace origin with the name of the remote pointing to NixOS/nixpkgs.

```ShellSession
$ git fetch origin
$ git rebase "$(git merge-base origin/master origin/staging)"
# maybe resolve conflicts
$ git push -f <your remote> <your branch>
```

## Commands

#### Build a package with an override

```shell
nix-build -E "with import ./nixpkgs {}; postfix.override { withMySQL = true; }"
```

#### Edit a package

```shell
nix edit -f . package
```

#### Show build log of a package

```shell
nix log -f . package
nix log nixpkgs.somafm-cli
```

#### Build all maintainer packages

```shell
nix-build maintainers/scripts/build.nix --argstr maintainer SuperSandro2000
```

#### Update all maintainer packages

```shell
nix-shell maintainers/scripts/update.nix --argstr maintainer SuperSandro2000 --argstr keep-going true
```

#### Mark package as broken

```shell
./pkgs/common-updater/scripts/mark-broken package
```

#### Browse dependencies interactively

```shell
nix-tree $(nix-instantiate -A package)
```

#### Evaluate default.nix in current directory for syntax or evaluation errors

```shell
nix-env -f . -qa
```

#### Do nix repl cross arch

```shell
nix-repl> (import ./. { system = "x86_64-darwin"; }).package
```

#### Update URLs which redirect to https

```shell
./maintainers/scripts/update_redirected_urls.sh
```

#### Convert double quoted strings in descriptions to single quotes

```shell
git ls-files | grep pkgs | xargs sed -i -e -E "s#description.*''(.*)''#description = \"\1\"#g"
```

#### Remove `enableParallelBuilding = true` if using cmake

```shell
ag -l "cmake" | xargs ag -l "enableParallelBuilding = true" > check.txt && wc -l check.txt
```

#### Check the amount of expected rebuilds

```shell
maintainers/scripts/rebuild-amount.sh
```

#### Test tree wide changes

```shell
nix-shell -p hydra-unstable --run "hydra-eval-jobs -I nixpkgs=$PWD nixos/release.nix"
nix-shell -p hydra-unstable --run "hydra-eval-jobs -I nixpkgs=$PWD pkgs/top-level/release.nix"
```
