PHDRS {
	headers PT_PHDR PHDRS;
	text PT_LOAD FILEHDR PHDRS;
	data PT_LOAD;
}
ENTRY(_start);
SECTIONS {
	. = 0x2000000;
	.text : {
		KEEP (*(.text))
		*(.text.*)
	} :text

	. = 0x8000000;

	.data : {
		KEEP (*(.data))
		*(.data.*)
	} :data

    .error_array : {
		PROVIDE_HIDDEN (__error_array_start = .);
		KEEP (*(.error_array))
		PROVIDE_HIDDEN (__error_array_end = .);
	} :data

	.bss : {
		KEEP (*(.bss))
		*(.bss.*)
	} :data
}
