from adiumentum.shell import (
    run,
    capture,
)
from pathlib import Path
import re
import subprocess


from .config import Config
from .datamodels import CommandList
from .utils import join_filtered


def export_nvim_info(task: str, cfg: Config) -> Path:
    name_segments = join_filtered("--", (task, cfg.g.DEVICE_NAME, cfg.g.CONFIG_NAME))
    destination = cfg.paths.info_dir / f"nvim-{name_segments}.txt"
    tmp_script = Path(f"/tmp/tmp_nvim_{task}.lua")
    print(destination)
    # os.system(f'nvim --headless -c "set columns=1000" -c "redir! > {destination}"   -c "verbose {task}"  -c "redir END" -c "q" > /dev/null')
    output_expression = (
        "vim.inspect(vim.opt.rtp)"
        if task == "rtp"
        else f'vim.api.nvim_exec2("verbose {task}", {{ output = true }}).output'
    )
    script_src = f"""
        local out = {output_expression}
        local f = io.open("{destination}", "w")
        f:write(out)
        f:close()
        """
    tmp_script.write_text(script_src)
    # main_command = (
    #     "lua print(vim.inspect(vim.opt.rtp))"
    #     if task == "rtp"
    #     else f"verbose {task}"
    # )
    # print(main_command)
    config = (
        ("-u", str(cfg.paths.nvim_config_init))
        if cfg.paths.nvim_config_init
        else tuple()
    )

    # def OLD_make_command(main_cmd: str,  dest: str) -> str:
    #     cmd_ = (
    #         f"'call writefile(split(execute(\"{main_cmd}\"), \"\\n\"),"
    #         f" \"{dest}\")'"
    #     )
    #     return cmd_

    # def make_command(main_cmd: str,  dest: str) -> str:
    #     cmd_ = (
    #         f"'lua local out = vim.api.nvim_exec2(\"{main_cmd}\", {{ output = true }}).output;"
    #         f" local f = io.open(\"{dest}\", \"w\"); f:write(out); f:close()'"
    #     )
    #     return cmd_

    # '''
    # alternative (TODO):
    # pde --headless \
    #     -c 'set columns=1000' \
    #     -lua 'local out = vim.api.nvim_exec2("verbose command", { output = true }).output; local f = io.open("/home/isaac/repos/nvim-config/data/snapshots/info/nvim-command--info--commands.txt", "w"); f:write(out); f:close()' \
    #     -c 'qa!'
    # '''

    # cmd = [
    #     cfg.g.NVIM_COMMAND,
    #     *config,
    #     "--headless",
    #     "-c",
    #     "'set columns=1000'",
    #     "-c",
    #     f"'redir! > {destination}'",
    #     "-c",
    #     main_command,
    #     "-c",
    #     "'redir END'",
    #     "-c",
    #     "'qa!'",
    # ]
    cmd = [
        "pde",
        *config,
        "--headless",
        "-c",
        "'set columns=1000 nomore'",
        "-l",
        str(tmp_script),
        "-c",
        "'qa!'",
    ]
    # cmd = [
    #     cfg.g.NVIM_COMMAND,
    #     *config,
    #     "--headless",
    #     "-c",
    #     "set columns=1000",
    #     "-c",
    #     f"redir! > {destination}",
    #     "-c",
    #     "verbose",
    #     "-c",
    #     main_command,
    #     "-c",
    #     "redir END",
    #     "-c",
    #     "qa!",
    # ]
    cmd = list(map(str, cmd))
    print(" ".join(cmd))
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    # tmp_script.unlink()
    return destination


def get_commit_info(path: Path) -> tuple[str, str]:
    if not (path / ".git").is_dir():
        return "AAAAAAAAAAAAAAAA", "1970-01-01"
    command_list = ["git", "-C", str(path), "log", "-1", "--format='%H %cI'"]
    output = subprocess.check_output(command_list).decode().strip()
    sha, date = output.split()
    return sha[1:], date[:10]


def get_executable_and_version(
    name: str, subcommand: str | None = None
) -> tuple[str, str]:
    executable = capture(["which", name])

    if not executable:
        return "", ""

    output = capture([executable, subcommand or "--version"])
    search = re.search(r"\bv?([\d\.]+)\b", output)
    return executable, (search.group(1) if search else "")


def check_for_updates(repo_path: Path, verbose: bool = False) -> bool:
    if not (repo_path / ".git").exists():
        print(f"Not a git directory: {repo_path}.")
        return False
    fetch_command: CommandList = [
        "git",
        "-C",
        repo_path,
        "fetch",
        "--dry-run",
        "origin",
    ]
    diff_command: CommandList = [
        "git",
        "-C",
        repo_path,
        "log",
        "HEAD..origin/HEAD",
        "--oneline",
    ]
    run(fetch_command)
    output = capture(diff_command)
    if verbose and output:
        print(output)
    return bool(output)
