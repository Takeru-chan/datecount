all:
	cp -p test-CalendarDate.swift main.swift
ifeq ($(shell uname),Linux)
	swiftc -o test-CalendarDate ./main.swift ./CalendarDate.swift
else
	xcrun -sdk macosx swiftc -o test-CalendarDate ./main.swift ./CalendarDate.swift
endif
	rm main.swift
