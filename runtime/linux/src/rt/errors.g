fun errno_to_error(c : int) => error := do
    return errors[c]
end

local const ALIGNMENT := 16

local extern(C) let __error_array_start : uint8
local extern(C) let __error_array_end : uint8

local fun printbytes(ptr: &pure byte, sz: int) := do
    for i := range 0,sz do
        let b : byte = ptr[i]
        print(cast(int) b)
        print(",")
    end
    println("")
end

fun error_string(err: error) => String := do
    if not err then
        return "(error)nil"
    end

    -- Find the error name by traversing the ELF .error_array section
    -- TODO(maybe): cache this to a dict on initialization?

    let addr_begin := cast(uintptr) cast(&opaque) &__error_array_start
    let addr_end := cast(uintptr) cast(&opaque) &__error_array_end
    let addr := addr_begin

    let errcode := cast(int) err

    for addr < addr_end do
        -- imaginary error struct:
        -- ...16-byte alignment 
        -- {
        --     code : int32
        --     name : null-terminated-string
        -- }
        let codeptr := cast(&int32) cast(&opaque) addr
        addr := addr + sizeof(int32)

        let str := from_cstr(cast(&uint8) cast(&opaque) addr)

        if errcode = @codeptr then
            return str
        end

        addr := addr + str.len
        addr := align(addr, ALIGNMENT)
    end

    return "(Unknown error)"
end

error (
    UNIX_EPERM
    UNIX_ENOENT
    UNIX_ESRCH
    UNIX_EINTR		
    UNIX_EIO		    
    UNIX_ENXIO		
    UNIX_E2BIG		
    UNIX_ENOEXEC
    UNIX_EBADF		
    UNIX_ECHILD		
    UNIX_EAGAIN		
    UNIX_ENOMEM		
    UNIX_EACCES		
    UNIX_EFAULT		
    UNIX_ENOTBLK		
    UNIX_EBUSY		
    UNIX_EEXIST		
    UNIX_EXDEV		
    UNIX_ENODEV		
    UNIX_ENOTDIR		
    UNIX_EISDIR		
    UNIX_EINVAL		
    UNIX_ENFILE		
    UNIX_EMFILE		
    UNIX_ENOTTY		
    UNIX_ETXTBSY		
    UNIX_EFBIG		
    UNIX_ENOSPC		
    UNIX_ESPIPE		
    UNIX_EROFS		
    UNIX_EMLINK		
    UNIX_EPIPE		
    UNIX_EDOM		    
    UNIX_ERANGE		
    UNIX_EDEADLK		
    UNIX_ENAMETOOLONG	
    UNIX_ENOLCK		
    UNIX_ENOSYS		
    UNIX_ENOTEMPTY	
    UNIX_ELOOP		
    UNIX_ENOMSG		
    UNIX_EIDRM		
    UNIX_ECHRNG		
    UNIX_EL2NSYNC	    
    UNIX_EL3HLT		
    UNIX_EL3RST		
    UNIX_ELNRNG		
    UNIX_EUNATCH		
    UNIX_ENOCSI		
    UNIX_EL2HLT		
    UNIX_EBADE		
    UNIX_EBADR		
    UNIX_EXFULL		
    UNIX_ENOANO		
    UNIX_EBADRQC		
    UNIX_EBADSLT		
    UNIX_EBFONT		
    UNIX_ENOSTR		
    UNIX_ENODATA		
    UNIX_ETIME		
    UNIX_ENOSR		
    UNIX_ENONET		
    UNIX_ENOPKG		
    UNIX_EREMOTE		
    UNIX_ENOLINK		
    UNIX_EADV		    
    UNIX_ESRMNT		
    UNIX_ECOMM		
    UNIX_EPROTO		
    UNIX_EMULTIHOP	
    UNIX_EDOTDOT		
    UNIX_EBADMSG		
    UNIX_EOVERFLOW	
    UNIX_ENOTUNIQ	    
    UNIX_EBADFD		
    UNIX_EREMCHG		
    UNIX_ELIBACC		
    UNIX_ELIBBAD		
    UNIX_ELIBSCN		
    UNIX_ELIBMAX		
    UNIX_ELIBEXEC	    
    UNIX_EILSEQ		
    UNIX_ERESTART	    
    UNIX_ESTRPIPE	    
    UNIX_EUSERS		
    UNIX_ENOTSOCK	    
    UNIX_EDESTADDRREQ	
    UNIX_EMSGSIZE	    
    UNIX_EPROTOTYPE	
    UNIX_ENOPROTOOPT	
    UNIX_EPROTONOSUPPORT	
    UNIX_ESOCKTNOSUPPORT	
    UNIX_EOPNOTSUPP	
    UNIX_EPFNOSUPPORT	
    UNIX_EAFNOSUPPORT	
    UNIX_EADDRINUSE	
    UNIX_EADDRNOTAVAIL	
    UNIX_ENETDOWN	    
    UNIX_ENETUNREACH	
    UNIX_ENETRESET	
    UNIX_ECONNABORTED	
    UNIX_ECONNRESET	
    UNIX_ENOBUFS		
    UNIX_EISCONN		
    UNIX_ENOTCONN	
    UNIX_ESHUTDOWN	
    UNIX_ETOOMANYREFS	
    UNIX_ETIMEDOUT	
    UNIX_ECONNREFUSED	
    UNIX_EHOSTDOWN	
    UNIX_EHOSTUNREACH	
    UNIX_EALREADY	
    UNIX_EINPROGRESS	
    UNIX_ESTALE		
    UNIX_EUCLEAN		
    UNIX_ENOTNAM		
    UNIX_ENAVAIL		
    UNIX_EISNAM		
    UNIX_EREMOTEIO	
    UNIX_EDQUOT		
    UNIX_ENOMEDIUM	
    UNIX_EMEDIUMTYPE	
    UNIX_ECANCELED	
    UNIX_ENOKEY		
    UNIX_EKEYEXPIRED	
    UNIX_EKEYREVOKED	
    UNIX_EKEYREJECTED	
    UNIX_EOWNERDEAD	
    UNIX_ENOTRECOVERABLE	
    UNIX_ERFKILL		
    UNIX_EHWPOISON	
)

-- An array mapping from errno codes to error symbols
local let errors := array(...) of error {
    nil,
    UNIX_EPERM,
    UNIX_ENOENT,
    UNIX_ESRCH	,	
    UNIX_EINTR	,	
    UNIX_EIO	,	    
    UNIX_ENXIO	,	
    UNIX_E2BIG	,	
    UNIX_ENOEXEC,		
    UNIX_EBADF	,	
    UNIX_ECHILD	,	
    UNIX_EAGAIN	,	
    UNIX_ENOMEM	,	
    UNIX_EACCES	,	
    UNIX_EFAULT	,	
    UNIX_ENOTBLK,		
    UNIX_EBUSY	,	
    UNIX_EEXIST	,	
    UNIX_EXDEV	,	
    UNIX_ENODEV	,	
    UNIX_ENOTDIR,		
    UNIX_EISDIR	,	
    UNIX_EINVAL	,	
    UNIX_ENFILE	,	
    UNIX_EMFILE	,	
    UNIX_ENOTTY	,	
    UNIX_ETXTBSY,		
    UNIX_EFBIG	,	
    UNIX_ENOSPC	,	
    UNIX_ESPIPE	,	
    UNIX_EROFS	,	
    UNIX_EMLINK	,	
    UNIX_EPIPE	,	
    UNIX_EDOM	,	    
    UNIX_ERANGE	,	
    UNIX_EDEADLK,		
    UNIX_ENAMETOOLONG	,
    UNIX_ENOLCK		,
    UNIX_ENOSYS		,
    UNIX_ENOTEMPTY	,
    UNIX_ELOOP		,
    UNIX_ENOMSG		,
    UNIX_EIDRM		,
    UNIX_ECHRNG		,
    UNIX_EL2NSYNC	 ,   
    UNIX_EL3HLT		,
    UNIX_EL3RST		,
    UNIX_ELNRNG		,
    UNIX_EUNATCH	,	
    UNIX_ENOCSI		,
    UNIX_EL2HLT		,
    UNIX_EBADE		,
    UNIX_EBADR		,
    UNIX_EXFULL		,
    UNIX_ENOANO		,
    UNIX_EBADRQC	,	
    UNIX_EBADSLT	,	
    UNIX_EBFONT		,
    UNIX_ENOSTR		,
    UNIX_ENODATA	,	
    UNIX_ETIME		,
    UNIX_ENOSR		,
    UNIX_ENONET		,
    UNIX_ENOPKG		,
    UNIX_EREMOTE	,	
    UNIX_ENOLINK	,	
    UNIX_EADV		 ,   
    UNIX_ESRMNT		,
    UNIX_ECOMM		,
    UNIX_EPROTO		,
    UNIX_EMULTIHOP	,
    UNIX_EDOTDOT	,	
    UNIX_EBADMSG	,	
    UNIX_EOVERFLOW	,
    UNIX_ENOTUNIQ	 ,   
    UNIX_EBADFD		,
    UNIX_EREMCHG	,	
    UNIX_ELIBACC	,	
    UNIX_ELIBBAD	,	
    UNIX_ELIBSCN	,	
    UNIX_ELIBMAX	,	
    UNIX_ELIBEXEC	 ,   
    UNIX_EILSEQ		,
    UNIX_ERESTART	 ,   
    UNIX_ESTRPIPE	  ,  
    UNIX_EUSERS		,
    UNIX_ENOTSOCK	 ,   
    UNIX_EDESTADDRREQ,	
    UNIX_EMSGSIZE	  ,  
    UNIX_EPROTOTYPE	,
    UNIX_ENOPROTOOPT,	
    UNIX_EPROTONOSUPPORT	,
    UNIX_ESOCKTNOSUPPORT	,
    UNIX_EOPNOTSUPP	,
    UNIX_EPFNOSUPPORT,	
    UNIX_EAFNOSUPPORT,	
    UNIX_EADDRINUSE	,
    UNIX_EADDRNOTAVAIL	,
    UNIX_ENETDOWN	  ,  
    UNIX_ENETUNREACH	,
    UNIX_ENETRESET	,
    UNIX_ECONNABORTED,	
    UNIX_ECONNRESET	,
    UNIX_ENOBUFS	,	
    UNIX_EISCONN	,	
    UNIX_ENOTCONN	,
    UNIX_ESHUTDOWN	,
    UNIX_ETOOMANYREFS,	
    UNIX_ETIMEDOUT	,
    UNIX_ECONNREFUSED,	
    UNIX_EHOSTDOWN	,
    UNIX_EHOSTUNREACH,	
    UNIX_EALREADY	,
    UNIX_EINPROGRESS,	
    UNIX_ESTALE		,
    UNIX_EUCLEAN	,	
    UNIX_ENOTNAM	,	
    UNIX_ENAVAIL	,	
    UNIX_EISNAM		,
    UNIX_EREMOTEIO	,
    UNIX_EDQUOT		,
    UNIX_ENOMEDIUM	,
    UNIX_EMEDIUMTYPE,	
    UNIX_ECANCELED	,
    UNIX_ENOKEY		,
    UNIX_EKEYEXPIRED,	
    UNIX_EKEYREVOKED,	
    UNIX_EKEYREJECTED,	
    UNIX_EOWNERDEAD	,
    UNIX_ENOTRECOVERABLE	,
    UNIX_ERFKILL		,
    UNIX_EHWPOISON	
}