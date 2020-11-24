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
    license = licenses.gpl3plus;
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
nix-build -A ... -K
# path to the kept build is shown
cd /path/to/drv
bash --rcfile env-vars
# start debugging
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

#### Edit a package

```shell
nix edit -f . package
```

#### Show build log of a package

```shell
nix log -f . package
nix log nixpkgs.somafm-cli
```

#### Build all maintainer packets

```shell
nix-build maintainers/scripts/build.nix --argstr maintainer SuperSandro2000
```

#### Update all maintainer packets

```shell
nix-build maintainers/scripts/update.nix --argstr maintainer SuperSandro2000
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
