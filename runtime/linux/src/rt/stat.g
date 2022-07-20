import "rt/syscall" as syscall

extern(C) (

struct c_stat {
    unsigned long   st_dev;         --/* Device.  */
    unsigned long   st_ino;         --/* File serial number.  */
    unsigned int    st_mode;        --/* File mode.  */
    unsigned int    st_nlink;       --/* Link count.  */
    unsigned int    st_uid;         --/* User ID of the file's owner.  */
    unsigned int    st_gid;         --/* Group ID of the file's group. */
    unsigned long   st_rdev;        --/* Device number, if device.  */
    unsigned long   __pad1;
    long            st_size;        --/* Size of file, in bytes.  */
    int             st_blksize;     --/* Optimal block size for I/O.  */
    int             __pad2;
    long            st_blocks;      --/* Number 512-byte blocks allocated. */
    long            st_atime;       --/* Time of last access.  */
    unsigned long   st_atime_nsec;
    long            st_mtime;       --/* Time of last modification.  */
    unsigned long   st_mtime_nsec;
    long            st_ctime;       --/* Time of last status change.  */
    unsigned long   st_ctime_nsec;
    unsigned int    __unused3;
    unsigned int    __unused4;
    unsigned int    __unused5;
};

)

type stat_type = struct of
    size : int
end

fun stat(filename: string) ?=> stat_type = do
    let cstat : c_stat

    let res = syscall.stat(filename.ptr, &cstat)
    if res < 0 then
        raise errno_to_error(-res)
    end

    let buf : stat_type
    buf.size = cast(int) cstat.st_size
    return buf
end

fun stat(fd: file_handle) ?=> stat_type = do
    let cstat : c_stat

    let res = syscall.fstat(fd, &cstat)
    if res < 0 then
        raise errno_to_error(-res)
    end

    let buf : stat_type
    buf.size = cast(int) cstat.st_size
    return buf
end