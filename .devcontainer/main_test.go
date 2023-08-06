package main

import (
	"os/exec"
	"testing"
)

func TestSetupPrecommit(t *testing.T) {
	setupPrecommit()
	cmd := exec.Command("pre-commit", "--version")
	err := cmd.Run()
	if err != nil {
		t.Errorf("pre-commit failed to be installed")
	}
}

func TestSetupAqua(t *testing.T) {
	setupAqua()
	cmd := exec.Command("aqua", "--version")
	err := cmd.Run()
	if err != nil {
		t.Errorf("aqua failed to be installed")
	}
}

func TestGitignore(t *testing.T) {
	setupGitginore()
}
