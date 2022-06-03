fun test(data: in out array of byte) := do

end

fun main := do
    let data : array of byte
    let pdata := &data
    test(@pdata)
end