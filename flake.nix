{
  description = "Development shell for Ultimate";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  inputs.nixpkgsIntelDarwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

  outputs = { nixpkgs, nixpkgsIntelDarwin, ... }: {
    devShells = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ] (system:
      let
        pkgs = if system == "x86_64-darwin" then import nixpkgsIntelDarwin {
          inherit system;
          config.allowDeprecatedx86_64Darwin = true;
        } else nixpkgs.legacyPackages.${system};
        pnpm = pkgs.pnpm_11.override {
          nodejs-slim = pkgs.nodejs_26;
          version = nixpkgs.lib.removePrefix "pnpm@" (builtins.fromJSON (builtins.readFile ./package.json)).packageManager;
          hash = "sha512-wfXnxMskHI8XS3Q4UdgvQrgCMkr8iw8Ra5atsVqgZmSUjd42lgo7oQebpbSyndAUATW5S1tfUmNZIknWjlVfJg==";
        };
      in {
        default = pkgs.mkShellNoCC { packages = [ pkgs.nodejs_26 pnpm ]; };
      });
  };
}
