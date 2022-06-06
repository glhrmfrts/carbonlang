import "rt"

const BOARD_CAP := 30

fun main := do
    let board : array(BOARD_CAP) of int

    board[BOARD_CAP - 2] := 1

    for i := range 0, BOARD_CAP - 2 do
        for j := range 0, BOARD_CAP do
            write(" *"[board[j]])
        end
        write("\n")

        let pattern := (board[0] << 1) | board[1]
        for j := range 0, BOARD_CAP - 1 do
            pattern := ((pattern << 1) & 7) | board[j + 1]
            board[j] := (110 >> pattern) & 1
        end
    end
end