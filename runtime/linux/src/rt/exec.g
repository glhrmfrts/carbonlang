import "rt/syscall" as syscall

macro wifexited(wife_status) = wtermsig(wife_status) == 0
macro wexitstatus(wexit_status) = (wexit_status & 0xff00) >> 8

macro wtermsig(wterm_status) = wterm_status & 0x7f
macro wifsignaled(wifsig_status) = (wifsig_status & 0xffff) - 1 < 0xff

error ( EXEC_CHILD_SIGNAL )

fun exec(cmd: string, args: array of string, exit_code: out int) => error = do
    let child = syscall.fork()
    if child == 0 then
        let bufs : array of array[PATH_MAX] of byte
        let argv : array of &pure byte
        resize(bufs, args.len + 1)

        append(argv, to_cstr(cmd, bufs[0]))

        for range 0, args.len do |i|
            append(argv, to_cstr(args[i], bufs[i + 1]))
        end
        append(argv, nil)

        syscall.execve(cmd.ptr, argv.ptr, nil)
        syscall.exit(0)
    else if child > 0 then
        let status : int
        syscall.wait4(child, &status, 0, nil)
        if wifexited(status) then
            exit_code = wexitstatus(status)
            return nil
        else if wifsignaled(status) then
            exit_code = wtermsig(status)
            return EXEC_CHILD_SIGNAL
        else
            syscall.exit(1)
        end
    else
        return errno_to_error(-child)
    end
end
