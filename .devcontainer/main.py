import os
import platform
import re
import shutil
import subprocess
from pathlib import Path

subprocess.run(
    "pip install -r .devcontainer/requirements.txt",
    shell=True,
)
subprocess.run("pre-commit install", shell=True)

if platform.machine() == "x86_64":
    machine = "amd64"


aqua_desired_version = os.environ["AQUA_VERSION"].strip("v")


def install_aqua():
    subprocess.run(
        f"curl -Lo aqua.tar.gz https://github.com/aquaproj/aqua/releases/download/v{aqua_desired_version}/aqua_linux_{machine}.tar.gz",
        cwd=Path.home(),
        shell=True,
    )
    subprocess.run("tar -xzf aqua.tar.gz", cwd=Path.home(), shell=True)
    shutil.move(
        Path.home() / "aqua", Path.home() / ".local/share/aquaproj-aqua/bin/aqua"
    )


aqua_path = Path.home() / ".local/share/aquaproj-aqua/bin/aqua"
if aqua_path.is_file():
    aqua_version = subprocess.run("aqua --version", shell=True, capture_output=True)
    aqua_version = re.search(
        r"\d+\.\d+\.\d+", aqua_version.stdout.decode("utf-8")
    ).group(0)
    if aqua_version == aqua_desired_version:
        print(f"Aqua version {aqua_version} is already installed")
    else:
        install_aqua()
else:
    install_aqua()

aqua_config_dir = Path.home() / ".config/aquaproj-aqua"
aqua_config_dir.mkdir(exist_ok=True)
shutil.copy("aqua.yaml", aqua_config_dir / "aqua.yaml")
subprocess.run("aqua install --all", shell=True)
