import rt::x86_64

extern(C) fun __gamma_start := do
    import root
    main()
    exit(0)
end