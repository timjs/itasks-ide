default:
	cpm main.prj

run: default
	./main.exe

force:
	cpm main.prj --force

clean:
	rm -rv $(find . -name "Clean System Files")
	rm -rv main.exe main-data sapl

.PHONY: run force clean
