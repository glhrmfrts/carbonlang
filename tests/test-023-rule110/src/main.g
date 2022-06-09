import "rt"

const BOARD_CAP = 30

fun main = do
    let board : array(BOARD_CAP) of int

    board[BOARD_CAP - 2] = 1

    for range 0, BOARD_CAP - 2 do |i|
        for range 0, BOARD_CAP do |j|
            write(" *"[board[j]])
        end
        write("\n")

        let pattern = (board[0] << 1) | board[1]
        for range 0, BOARD_CAP - 1 do |j|
            pattern = ((pattern << 1) & 7) | board[j + 1]
            board[j] = (110 >> pattern) & 1
        end
    end
end