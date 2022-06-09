import "rt/syscall"

extern(C) fun __gamma_start = do
    import "root"
    main()
    exit(0)
end