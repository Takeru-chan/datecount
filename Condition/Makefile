all:
ifeq ($(shell uname),Linux)
	swiftc -D TEST -o test-ConditionDate ./ConditionDate.swift
else
	xcrun -sdk macosx swiftc -D TEST -o test-Condition ./Condition.swift
endif
