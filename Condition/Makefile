all:
	cp -p test-Condition.swift main.swift
ifeq ($(shell uname),Linux)
	swiftc -o test-Condition ./main.swift ./Condition.swift
else
	xcrun -sdk macosx swiftc -o test-Condition ./main.swift ./Condition.swift
endif
	rm main.swift
