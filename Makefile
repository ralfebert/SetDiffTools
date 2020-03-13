FORMATTER_OPTIONS = --swiftversion 5.1 --stripunusedargs unnamed-only --self insert --disable blankLinesAtStartOfScope,blankLinesAtEndOfScope

format:
	swiftformat --header "Copyright © 2020 Ralf Ebert\nLicensed under MIT license." $(FORMATTER_OPTIONS) Sources Tests
