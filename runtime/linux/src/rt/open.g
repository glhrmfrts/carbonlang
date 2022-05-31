import rt::syscall as syscall

#define O_ACCMODE       00000003                                                                                                                                                                                                              
#define O_RDONLY        00000000                                                                                                                                                                                                              
#define O_WRONLY        00000001                                                                                                                                                                                                              
#define O_RDWR          00000002                                                                                                                                                                                                                                                                                                                
#define O_CREAT         00000100        -- /* not fcntl */                                                                                                                                                                                                                                                                                                                                                                                                                      
#define O_EXCL          00000200        -- /* not fcntl */                                                                                                                                                                                                                                                                                                                                                                                                                  
#define O_NOCTTY        00000400        -- /* not fcntl */                                                                                                                                                                                                                                                                                                                                                                                                              
#define O_TRUNC         00001000        -- /* not fcntl */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
#define O_APPEND        00002000                                                                                                                                                                                                              
#define O_NONBLOCK      00004000                                                                                                                                                                                                              
#define O_DSYNC         00010000        -- /* used to be O_SYNC, see below */                                                                                                                                                                    
#define FASYNC          00020000        -- /* fcntl, for BSD compatibility */                                                                                                                                                                    
#define O_DIRECT        00040000        -- /* direct disk access hint */                                                                                                                                                                         
#define O_LARGEFILE     00100000                                                                                                                                                                                                              
#define O_DIRECTORY     00200000        -- /* must be a directory */                                                                                                                                                                             
#define O_NOFOLLOW      00400000        -- /* don't follow links */                                                                                                                                                                              
#define O_NOATIME       01000000                                                                                                                                                                                                              
#define O_CLOEXEC       02000000        -- /* set close_on_exec */

type open_flags := enumflags (
    read
    write
    create
    append
    truncate
)

fun to_kernel_flags(flags : open_flags) => int := do
    let lflags : int

    if flags & (open_flags::read | open_flags::write) then
        lflags := O_RDWR
    else if flags & open_flags::write then
        lflags := O_WRONLY
    else if flags & open_flags::read then
        lflags := O_RDONLY
    end

    if flags & open_flags::create then
        lflags := lflags | O_CREAT
    end

    if flags & open_flags::append then
        lflags := lflags | O_APPEND
    end

    if flags & open_flags::truncate then
        lflags := lflags | O_TRUNC
    end

    return lflags
end

fun open(
    file    : out file_handle,
    path    : string,
    flags   : open_flags,
    mode    : int
) => error := do
    const PATH_MAX := 4096
    let buf : array(PATH_MAX) of byte
    let bufview := array of byte{ &buf[0], sizeof(buf), sizeof(buf) }

    let path_cstr := to_cstr(path, bufview)
    if path_cstr = nil then
        return UNIX_ENAMETOOLONG
    end

    let fd := syscall::open(path_cstr, to_kernel_flags(flags), mode)
    if fd < 0 then
        return errno_to_error(-fd)
    end

    file := fd
    return nil
end

fun close(fd : file_handle) => error := do
    let res := syscall::close(fd)
    if res < 0 then
        return errno_to_error(-fd)
    end
    putln("close ", fd)
    return nil
end