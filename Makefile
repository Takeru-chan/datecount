all:
	cp -p datecount.swift main.swift
ifeq ($(shell uname),Linux)
	swiftc -o datecount main.swift ./Devices/Devices.swift ./Condition/Condition.swift ./CalendarDate/CalendarDate.swift
else
	xcrun -sdk macosx swiftc -o datecount main.swift ./Devices/Devices.swift ./Condition/Condition.swift ./CalendarDate/CalendarDate.swift
endif
	rm main.swift
