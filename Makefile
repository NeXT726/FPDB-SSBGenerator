main: GenerateSqlFile.cpp SqlGenerator.cpp SqlGenerator.h
	g++ -std=c++17 GenerateSqlFile.cpp SqlGenerator.cpp -lfmt