package main

import "os"

func runCommand(command string, args ...string) (string, error) {

}

func main() {
	command := "id"
	//args := []string{"-la"}

	output, err := runCommand(command)

	if err != nil {
		fmt.Prinln("Error:", err)
		os.Exit(1)
	}
}
