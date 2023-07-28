package main

import "C"

func HelloWorld() *C.char {
	return C.CString("Hello from Go!")
}

func main() {}
