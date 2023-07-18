import subprocess

subprocess.run("pip install -r .devcontainer/requirements.txt", shell=True)
subprocess.run("pre-commit install", shell=True)
