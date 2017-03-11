all:
	cp -p datecount.swift main.swift
	xcrun -sdk macosx swiftc -o datecount main.swift ./Devices/Devices.swift ./Condition/Condition.swift ./CalendarDate/CalendarDate.swift
	rm main.swift
