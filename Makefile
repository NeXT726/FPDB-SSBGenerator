main: GenerateSqlFile.cpp SqlGenerator.cpp SqlGenerator.h
	g++ -std=c++17 -o SQLgenerator.out GenerateSqlFile.cpp SqlGenerator.cpp -lfmt

clean:
	rm -rf SQLgenerator.out