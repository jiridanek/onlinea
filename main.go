package main

import (
    "os"
    "fmt"
)

func Onlinea(args []string) {
        fmt.Println("Onlinea")
}

func Help(args []string) {
        fmt.Println("Help")
}

func main() {
    args := os.Args
    if len(args) <= 1 {
        Onlinea(args)
        return
    }
    switch args[1] {
    case "duolingo":
        Duolingo(args[2:])
    default:
        Help(args)
    }
}