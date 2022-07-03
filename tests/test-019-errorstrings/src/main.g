import "rt"

fun main = do
    let err : error
    putln(err)
    putln(UNIX_ENAMETOOLONG)
    putln(FileNotFound)
    putln(UNIX_EPERM)
    putln(UNIX_EFAULT)
end