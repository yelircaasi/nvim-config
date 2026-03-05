"""
Utility script to install plugins on non-nix systems.

On Nix-enabled systems, serves to check that all plugins are correctly installed.
"""
from dataclasses import dataclass
from pathlib import Path
from enum import StrEnum, auto
import subprocess

IS_NIX: bool = ...


class Source(StrEnum):
    GH = auto()
    CB = auto()
    GL = auto()


@dataclass
class Spec:
    id: str
    lua_name: str
    source: Source
    custom_url: str | None = None
    version: str | None = None

    @property
    def url(self) -> str:
        return self.custom_url or f"{self.url_base}/{self.id}"
    
    @property
    def url_base(self) -> str:
        return {
            Source.GH: "https://github.com/",
            Source.GL: "https://gitlab.com/",
            Source.CB: "https://codeberg.org/",
        }[self.source]


PLUGINS: tuple[Spec, ...] = (
    Spec(lua_name="plenary", id="nvim-lua/plenary.nvim", source=Source.GH),
    Spec(lua_name="nio", id="nvim-neotest/nvim-nio", source=Source.GH),
)


for spec in PLUGINS:
    print(f"{spec.lua_name:<20} {spec.url}")