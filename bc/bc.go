package bc

import (
	"bytes"
	"fmt"
	"io"
	"os/exec"
	"sort"
	"strings"
	"text/scanner"
	"unicode"
)

func eval(in io.Reader, out io.Writer) error {
	c := exec.Command("bc", "-l")
	c.Stdin = in
	c.Stdout = out
	if err := c.Start(); err != nil {
		return err
	}
	if err := c.Wait(); err != nil {
		return err
	}
	return nil
}

func Eval(exp string) (string, error) {
	in := strings.NewReader(exp + "\n")
	var out bytes.Buffer

	err := eval(in, &out)

	return strings.TrimSpace(out.String()), err
}

func Run(program string, variables map[string]string) (string, error) {
	var in bytes.Buffer
	for k, v := range variables {
		fmt.Fprintf(&in, "%s = %s\n", k, v)
	}
	fmt.Fprintf(&in, "%s\n", program)

	var out bytes.Buffer

	err := eval(&in, &out)
	return out.String(), err
}

func isAlphaNum(r rune) bool {
	return unicode.IsLetter(r) || unicode.IsNumber(r)
}

func isVariable(tok string) bool {
	if tok == "" {
		return false
	}
	if !unicode.IsLetter([]rune(tok)[0]) {
		return false
	}
	for _, r := range tok {
		if !isAlphaNum(r) && r != '_' {
			return false
		}
	}
	switch tok {
	case "if", "else", "for", "while", "define", "scale", "auto", "return", "print":
		return false
	}
	return true
}

// Variables returns list of variable names in a bc program
// it is expected to have some false positives but no false negatives
func Variables(program string) []string {
	variables := make(map[string]struct{}, 0)

	var s scanner.Scanner
	s.Init(strings.NewReader(program))
	var tok rune
	newWord := true
	for tok != scanner.EOF {
		tok = s.Scan()
		text := strings.TrimSpace(s.TokenText())
		if newWord && tok == scanner.Ident && isVariable(text) {
			variables[text] = struct{}{}
		}
		newWord = tok != scanner.Int // e.g. program = "42a"
	}

	i := 0
	list := make([]string, len(variables))
	for k, _ := range variables {
		list[i] = k
		i++
	}
	sort.Strings(list)

	return list
}
