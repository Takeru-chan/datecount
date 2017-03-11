all:
	cp -p test-Devices.swift main.swift
ifeq ($(shell uname),Linux)
	swiftc -o test-Devices.rpi main.swift Devices.swift
else
	xcrun -sdk macosx swiftc -o test-Devices main.swift Devices.swift
endif
	rm main.swift
