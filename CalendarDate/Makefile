all:
ifeq ($(shell uname),Linux)
	swiftc -D TEST -o test-CalendarDate ./CalendarDate.swift
else
	xcrun -sdk macosx swiftc -D TEST -o test-CalendarDate ./CalendarDate.swift
endif
