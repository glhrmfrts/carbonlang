func paruser.root.lex_token._Aptr__TToken._Ainout__TLexer -> ptr__TToken
    arg #0 $cb_agg_ret: ptr__TToken;
    arg #1 l: inout__TLexer;
    local #0 $ast_temp11: pure__TToken;
    local #1 $ast_temp12: pure__TToken;
    local #2 $ast_temp13: pure__TToken;
    local #3 $ast_temp14: pure__TToken;
    local #4 $ast_temp15: pure__TToken;
    local #5 $ast_temp21: array__Tpure__Tbyte;
    local #6 $ast_temp16: pure__TToken;
    local #7 $ast_temp22: array__Tpure__Tbyte;
    local #8 $ast_temp23: array__Tpure__Tbyte;
    local #9 $irtemp10: ptr__TToken;
    local #10 $irtemp11: ptr__TToken;
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_call paruser.rt.writeln._Abyte POP();
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_jmp_neq POP() #34 .if_false_7681;
    :: .if_true_7681;
    ir_deref A0; (push)
    ir_load_addr L0; (push)
    ir_call paruser.root.lex_string_literal._Aptr__TToken._Ainout__TLexer POP() A1;
    ir_copy POP() L0 64;
    ir_return A0;
    ir_jmp .if_end_7681;
    :: .if_false_7681;
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_jmp_neq POP() #40 .if_false_7680;
    :: .if_true_7680;
    ir_deref A0; (push)
    ir_load_addr L1; (push)
    ir_call paruser.root.lex_char._Aptr__TToken._Ainout__TLexer POP() A1;
    ir_copy POP() L1 64;
    ir_return A0;
    ir_jmp .if_end_7680;
    :: .if_false_7680;
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_jmp_neq POP() #41 .if_false_7679;
    :: .if_true_7679;
    ir_deref A0; (push)
    ir_load_addr L2; (push)
    ir_call paruser.root.lex_char._Aptr__TToken._Ainout__TLexer POP() A1;
    ir_copy POP() L2 64;
    ir_return A0;
    ir_jmp .if_end_7679;
    :: .if_false_7679;
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_jmp_neq POP() #123 .if_false_7678;
    :: .if_true_7678;
    ir_deref A0; (push)
    ir_load_addr L3; (push)
    ir_call paruser.root.lex_char._Aptr__TToken._Ainout__TLexer POP() A1;
    ir_copy POP() L3 64;
    ir_return A0;
    ir_jmp .if_end_7678;
    :: .if_false_7678;
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_call paruser.root.is_numeric._Abyte POP(); (push)
    ir_jmp_eq POP() 0 .if_false_7677;
    :: .if_true_7677;
    ir_load_addr STR3; (push)
    ir_load [L5 . 0] POP();
    ir_load [L5 . 1] 10;
    ir_load [L5 . 2] 11;
    ir_load_addr L5; (push)
    ir_call paruser.rt.writeln._Ain__Tstring POP();
    ir_deref A0; (push)
    ir_load_addr L4; (push)
    ir_call paruser.root.lex_number._Aptr__TToken._Ainout__TLexer POP() A1;
    ir_copy POP() L4 64;
    ir_return A0;
    ir_jmp .if_end_7677;
    :: .if_false_7677;
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_call paruser.root.is_identifier_starter._Abyte POP(); (push)
    ir_jmp_eq POP() 0 .if_false_7676;
    :: .if_true_7676;
    ir_deref A0; (push)
    ir_load_addr L6; (push)
    ir_call paruser.root.lex_identifier._Aptr__TToken._Ainout__TLexer POP() A1;
    ir_copy POP() L6 64;
    ir_return A0;
    ir_jmp .if_end_7676;
    :: .if_false_7676;
    ir_deref A1; (push)
    ir_load_addr [POP() . 0]; (push)
    ir_deref [POP() . 0]; (push)
    ir_deref A1; (push)
    ir_index POP() [POP() . 1]; (push)
    ir_call paruser.root.is_whitespace._Abyte POP(); (push)
    ir_jmp_eq POP() 0 .if_false_7675;
    :: .if_true_7675;
    ir_load_addr STR4; (push)
    ir_load [L7 . 0] POP();
    ir_load [L7 . 1] 14;
    ir_load [L7 . 2] 15;
    ir_load_addr L7; (push)
    ir_call paruser.rt.writeln._Ain__Tstring POP();
    ir_call paruser.root.lex_whitespace._Ainout__TLexer A1;
    ir_load L9 A0;
    ir_return A0;
    ir_jmp .if_end_7675;
    :: .if_false_7675;
    ir_load_addr STR5; (push)
    ir_load [L8 . 0] POP();
    ir_load [L8 . 1] 7;
    ir_load [L8 . 2] 8;
    ir_load_addr L8; (push)
    ir_call paruser.rt.writeln._Ain__Tstring POP();
    ir_load L10 A0;
    ir_return A0;
    :: .if_end_7675;
    :: .if_end_7676;
    :: .if_end_7677;
    :: .if_end_7678;
    :: .if_end_7679;
    :: .if_end_7680;
    :: .if_end_7681;
endf