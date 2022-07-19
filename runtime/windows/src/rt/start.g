extern(C) fun __gamma_windows_main => int = do
    import "root"

    let main_context : context_type
    let context = &main_context

    main()
    return 42
end