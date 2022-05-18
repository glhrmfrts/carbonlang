import rt::x86_64

extern(C) let __init_array_start : &fun() => ()
extern(C) let __init_array_end : &fun() => ()

extern(C) let __fini_array_start : &fun() => ()
extern(C) let __fini_array_end : &fun() => ()

extern(C) fun __gamma_start := do
    let init_ptr := __init_array_start
    for init_ptr < __init_array_end do
        (@init_ptr)()
        init_ptr := '' + 1
    end

    import root
    main()

    let end_ptr := __fini_array_start
    for end_ptr < __fini_array_end do
        (@end_ptr)()
        end_ptr := '' + 1
    end

    exit(42)
end