typealias file_handle := int

extern(C) fun GetStdHandle(nStdHandle: int): &opaque

const STD_INPUT_HANDLE  := -10
const STD_OUTPUT_HANDLE := -11
const STD_ERROR_HANDLE  := -12

fun stdout() := GetStdHandle(STD_OUTPUT_HANDLE)