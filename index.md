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
nix-build -A package -K
# path to the kept build is shown
nix-shell -E "with import <nixpkgs> {}; callPackage /path/to/package.nix {}" --pure
export out=/tmp/path/to/some.drv-0
# start debugging
set -x
buildPhase
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
