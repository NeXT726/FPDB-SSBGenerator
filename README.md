Fork from FlexPushdownDB
SSB负载生成器，随机生成

#编译
make
或者
mkdir build && cd build
cmake ..
make


#执行
./SQLgenerator.out <type> <size> <skewness> <selectivity>

·type 
    ·1 常规的倾斜负载，访问数据的orderdate按zipfian分布，每次query只会访问selectivity比例的数据量
    ·2 

·size: 生成的ssb query的数量
    其中，0-size/2 的为warmup query， size/2-size 的为execution query
    我们只需要统计执行 execution query 的信息作为最后系统的衡量标准
    warmup query 和 execution query 的内容是相同的，只是顺序不同（cpp std::shuffle打乱了顺序罢了）

·skewness
    对SSB数据中 lineorder 表的 orderdate 项数据进行倾斜
    该项数据共有七个年份1992-1998，对不同年份的数据访问进行倾斜
    访问不同年份的query语句的个数 按照Zipfian分布
    skewness越大，倾斜越严重，访问的数据分布越不均匀

·selectivity：数据倾斜比例
    默认为0.2，含义是每次查询都只涉及20%的数据
    但不同的query语句会在不同的20%数据中进行