from .datamodels import PluginSpecs, SinglePluginSpec, GitSource
from .nix_strings import (
    flake_foot,
    flake_head,
    flake_neck,
    expression_foot,
    expression_head,
    expression_neck,
)

lbrace = "{"
rbrace = "}"
indent_size = 2


def level(i: int) -> str:
    return " " * i * indent_size


plugin_expr_template = """{name} = pkgs.vimUtils.buildVimPlugin {lbrace}
        pname = "{nix_name}";
        version = "{version}";
        src = pkgs.fetchgit {lbrace}
          url = "{url}";
          rev = "{rev}";
          hash = "{nix_hash}";
        {rbrace};
        doCheck = false;
        meta = {lbrace}
          homepage = "{url}";
          description = "";
        {rbrace};
      {rbrace};"""


plugin_expr_template_gh = """{name} = pkgs.vimUtils.buildVimPlugin {lbrace}
        pname = "{nix_name}";
        version = "{version}";
        src = pkgs.fetchFromGitHub {lbrace}
          owner = "{owner}";
          repo = "{repo}";
          rev = "{rev}";
          hash = "{nix_hash}";
        {rbrace};
        doCheck = false;
        meta = {lbrace}
          homepage = "{url}";
          description = "";
        {rbrace};
      {rbrace};"""


def make_expression(ps: SinglePluginSpec) -> str:
    try:
        source = GitSource(ps.source)
        base = {
            GitSource.GH: "https://github.com",
            GitSource.GL: "https://gitlab.com",
            GitSource.CB: "https://codeberg.org",
        }.get(source, "")
        if ps.source == "gh":
            template = plugin_expr_template_gh
            owner, repo = ps.id.split("/")
        else:
            template = plugin_expr_template
            owner, repo = "", ""

        ret = template.format(
            name=ps.name,
            nix_name=ps.nixName,
            version=ps.lastCommit or "1970-01-01",
            url="/".join((base, ps.id)).strip("/"),
            rev=ps.rev,
            nix_hash=ps.hash,
            lbrace="{",
            rbrace="}",
            owner=owner,
            repo=repo,
        )
        # print(ret)
        return ret
    except Exception as e:
        print(e)
        print(ps)
        raise e


def make_name(ps: SinglePluginSpec) -> str:
    attrset = ps.attrset
    nix_name = ps.nixName
    return f"{attrset}.{nix_name}"


def make_nixpkgs_set(ps: SinglePluginSpec) -> str:
    nix_name = (
        ps.nixName if ps.attrset == "pkgs.vimPlugins" else f"{ps.attrset}.{ps.nixName}"
    )
    return f'{lbrace}\n{level(4)}name = "{ps.name}";\n{level(4)}path = {nix_name};\n{level(3)}{rbrace}'


def _split_plugins(nix_data: PluginSpecs) -> tuple:
    custom_data = [d for d in nix_data if d.attrset.startswith("custom")]
    nixpkgs_data = [d for d in nix_data if d.attrset.startswith("pkgs")]
    other_data = [
        d for d in nix_data if (d not in custom_data) and (d not in nixpkgs_data)
    ]
    if other_data:
        raise ValueError
    return custom_data, nixpkgs_data


def build_flake_source(nix_data: PluginSpecs) -> str:
    custom_data, nixpkgs_data = _split_plugins(nix_data)
    custom = "\n      ".join(map(make_expression, custom_data))
    nixpkgs_list = "\n      ".join(map(make_nixpkgs_set, nixpkgs_data))
    return "".join((flake_head, custom, flake_neck, nixpkgs_list, flake_foot))


def build_plugins_derivation_source(nix_data: PluginSpecs) -> str:
    custom_data, nixpkgs_data = _split_plugins(nix_data)
    custom = "\n      ".join(map(make_expression, custom_data))
    nixpkgs_list = "\n      ".join(map(make_nixpkgs_set, nixpkgs_data))
    return "".join(
        (expression_head, custom, expression_neck, nixpkgs_list, expression_foot)
    )
