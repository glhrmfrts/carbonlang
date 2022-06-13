import "rt/syscall"

local let args : array of string

fun arguments() => array of string = do
    return args
end

extern(C) fun __gamma_start(argc: int, argv: & &byte) = do
    import "root"

if false then
    for range 0, argc do |i|
        let cstr = argv[i]
        append(args, from_cstr(cstr))
    end
end

    main()
    exit(0)
end