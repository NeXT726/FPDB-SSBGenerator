//
// Created by Yifei Yang on 8/16/20.
//


#include <filesystem>
#include <fstream>
#include "SqlGenerator.h"
#include <iostream>

using namespace ssb;

void writeFile(const std::string& content, std::filesystem::path &filePath) {
  std::ofstream file(filePath.string());
  file << content;
}

std::vector<std::string> readFileByLine(std::filesystem::path &filePath) {
  std::ifstream inFile(filePath.string());
  std::vector<std::string> lines;
  std::string line;
  while (std::getline(inFile, line)) {
    lines.emplace_back(line);
  }
  return lines;
}

std::filesystem::path makeDirPath(const std::string &relPath) {
  auto path = std::filesystem::current_path().append(relPath);
  if (!std::filesystem::exists(path)) {
    std::filesystem::create_directory(path);
  }
  return path;
}

void generateSqlFile(int argc, char **argv, std::filesystem::path &sql_file_dir_path) {
  // Parameters
  auto type = atoi(argv[1]);
  auto size = atoi(argv[2]);
  auto skewness = atof(argv[3]);
  SqlGenerator sqlGenerator;
  if (argc >= 5) {
    sqlGenerator.setLineorderRowSelectivity(atof(argv[4]));
  }
  std::random_device rd;
  std::mt19937 g(rd());

  // Workload
  switch (type) {
    // Basic workload
    case 1: {
      auto warmupBatch = sqlGenerator.generateSqlBatchSkew(skewness, size / 2);
      std::vector<std::string> executionBatch(warmupBatch);
      std::shuffle(warmupBatch.begin(), warmupBatch.end(), g);
      std::shuffle(executionBatch.begin(), executionBatch.end(), g);
      for (int index = 0; index < size; index++) {
        auto sql = (index < warmupBatch.size()) ? warmupBatch[index] : executionBatch[index - warmupBatch.size()];
        auto sql_file_path = sql_file_dir_path.append(fmt::format("{}.sql", (index + 1)));
        writeFile(sql, sql_file_path);
        sql_file_dir_path = sql_file_dir_path.parent_path();
      }
      break;
    }

    // Weighted workload
    case 2: {
      auto warmupBatch = sqlGenerator.generateSqlBatchSkewWeight(skewness, size / 2);
      std::vector<std::string> executionBatch(warmupBatch);
      std::shuffle(warmupBatch.begin(), warmupBatch.end(), g);
      std::shuffle(executionBatch.begin(), executionBatch.end(), g);
      for (int index = 0; index < size; index++) {
        auto sql = (index < warmupBatch.size()) ? warmupBatch[index] : executionBatch[index - warmupBatch.size()];
        auto sql_file_path = sql_file_dir_path.append(fmt::format("{}.sql", (index + 1)));
        writeFile(sql, sql_file_path);
        sql_file_dir_path = sql_file_dir_path.parent_path();
      }
      break;
    }

    // Recurring workload in SSB order
    case 3: {
      auto recurBatch = sqlGenerator.generateSqlBatchSkewRecurring(skewness);
      for (int index = 0; index < size; index++) {
        auto sql = recurBatch[index % recurBatch.size()];
        auto sql_file_path = sql_file_dir_path.append(fmt::format("{}.sql", (index + 1)));
        writeFile(sql, sql_file_path);
        sql_file_dir_path = sql_file_dir_path.parent_path();
      }
      break;
    }

    // One-hot workload
    case 4: {
      auto hotPercentage = skewness;
      auto batch = sqlGenerator.generateSqlBatchHotQuery(hotPercentage, size);
      std::shuffle(batch.begin(), batch.end(), g);
      for (int index = 0; index < size; index++) {
        auto sql = batch[index];
        auto sql_file_path = sql_file_dir_path.append(fmt::format("{}.sql", (index + 1)));
        writeFile(sql, sql_file_path);
        sql_file_dir_path = sql_file_dir_path.parent_path();
      }
      break;
    }

    // Math model queries
    case 5: {
      auto hitRatio = strtod(argv[2], nullptr);
      auto rowPer = strtod(argv[3], nullptr);
      auto nCol = strtod(argv[4], nullptr);
      auto batch = sqlGenerator.generateSqlForMathModel(hitRatio, rowPer, nCol);
      for (size_t index = 0; index < batch.size(); index++) {
        auto sql = batch[index];
        auto sql_file_path = sql_file_dir_path.append(fmt::format("{}.sql", (index + 1)));
        writeFile(sql, sql_file_path);
        sql_file_dir_path = sql_file_dir_path.parent_path();
      }
      break;
    }

    default:
      throw std::runtime_error("Workload type not found, type: " + std::to_string(type));
  }
}


int main(int argc, char **argv) {
  // Directory
  auto sql_file_dir_path = makeDirPath("sql/");

  generateSqlFile(argc, argv, sql_file_dir_path);

  return 0;
}
