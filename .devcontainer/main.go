package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"regexp"
	"runtime"
	"strings"

	"github.com/cuonglm/gogi"
)

var homedir, _ = os.UserHomeDir()
var aquaBinPath = ".local/share/aquaproj-aqua/bin/aqua"
var aquaDesiredVersion, _ = os.LookupEnv("AQUA_VERSION")

func check(err error) {
	if err != nil {
		fmt.Printf("err: %s\n", err)
		panic(err)
	}
}

func setupPrecommit() {
	var cmd *exec.Cmd

	file, err := os.ReadFile("requirements.txt")
	check(err)
	requirementsArray := strings.Split(string(file), "\n")
	requirementsArray = requirementsArray[:len(requirementsArray)-1]
	for _, requirement := range requirementsArray {
		cmd := exec.Command("pipx", "install", "--force", requirement)
		err := cmd.Run()
		check(err)
	}

	cmd = exec.Command("pre-commit", "install")
	err = cmd.Run()
	check(err)
}

func installAqua() {

	var cmd *exec.Cmd
	var err error

	aquaURL := fmt.Sprint("https://github.com/aquaproj/aqua/releases/download/", aquaDesiredVersion, "/aqua_linux_", runtime.GOARCH, ".tar.gz")

	cmd = exec.Command(
		"curl",
		"-Lo",
		"aqua.tar.gz",
		aquaURL)
	cmd.Dir = homedir
	err = cmd.Run()
	check(err)

	cmd = exec.Command("tar", "-xvf", "aqua.tar.gz")
	cmd.Dir = homedir
	err = cmd.Run()
	check(err)

	cmd = exec.Command(
		"mv",
		"aqua",
		aquaBinPath,
	)
	cmd.Dir = homedir
	err = cmd.Run()
	check(err)
	log.Println("aqua version", aquaDesiredVersion, "installed")
}

func setupAqua() {

	var cmd *exec.Cmd

	cmd = exec.Command("aqua", "--version")
	stdout, err := cmd.Output()
	if err != nil {
		if strings.Contains(err.Error(), "executable file not found in $PATH") {
			log.Println("aqua not found, installing...")
			installAqua()
		} else {
			check(err)
		}
	}
	re := regexp.MustCompile(`\d+\.\d+\.\d+`)
	aquaCurrentVersion := re.FindString(string(stdout))
	if aquaDesiredVersion != fmt.Sprint("v", aquaCurrentVersion) {
		log.Println("aqua version mismatch.", "current:", aquaCurrentVersion, "desired:", aquaDesiredVersion, "installing...")
		installAqua()
	}

	aquaConfigDir := fmt.Sprint(homedir, "/.config/aquaproj-aqua")
	err = os.MkdirAll(aquaConfigDir, os.ModePerm)
	check(err)

	err = os.Symlink("../aqua.yaml", fmt.Sprint(aquaConfigDir, "/aqua.yaml"))
	if err != nil {
		if strings.Contains(err.Error(), "file exists") {
		} else {
			check(err)
		}
	}

	cmd = exec.Command("aqua", "install", "--all")
	cmd.Dir = "../"
	err = cmd.Run()
	check(err)
}

func setupGitginore() {
	gogiClient, _ := gogi.NewHTTPClient()
	data, err := gogiClient.Create("go,VisualStudioCode,JetBrains")
	if err != nil {
		log.Fatal(err)
	}
	os.WriteFile("../.gitignore", []byte(data), 0644)
}

func main() {
	setupPrecommit()
	setupAqua()
	setupGitginore()
}
