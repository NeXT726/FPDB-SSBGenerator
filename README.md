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
    ·2 不同pushdown成本的负载，用于测试WLFU缓存替换策略
        但这个负载下的query筛选条件都比较严苛，查询涉及到的数据量较少
        相比负载1，增加的筛选条件为：
            增加city=*（筛选后只有1/45的数据量）或p_brand=*（筛选后只有1/500的数据量）
            还增加一个随机的查询条件（8/10或1/50）
    ·3 按照SSB的10条查询（不包含q1）的顺序，依次重复生成size个query
        访问的orderdate按zipfian分布：
            但其实只在第一次生成10条query的时候倾斜，后续query都是在复制前十条指令，访问的数据很重复
            并且生成10条query的时候7个年份的访问按zipfian分布，query太少其实并没有很好的均匀分布
        selectivity的筛选也是有的，所以其实真正访问到的数据量并不多，并且还重复查询
    ·4 One Hot Workload 
            将size*skewness条query生成为同一条指令
            其他query遍历q2 q3 q4生成均匀的负载
            两种情况下都是 查询某一年 并且进行selectivity后 的查询（数据量不大）
            两种特征的查询打乱顺序后写入sql文件
    ·5 ./SQLgenerator.out  double<hitRatio> double<rowPer> int<nCol>
        ·hitRatio 表示查询两年（19920101-19931231）中的hitRatio比例的日期的数据
        ·rowPer 表示查询lo_quantity列中的rowPer比例的行的数据
        ·nCol 表示查询返回结果是lineorder表的几列数据（共17列）
        该负载没怎么看懂，共三条查询语句：
            同时筛选date和quantity -- 只筛选quantity -- 都不进行筛选
        可能是模拟第一次查询进行部分缓存，后面两次都是部分缓存、部分下推的场景


·size: 生成的ssb query的数量
    其中，0-size/2 的为warmup query， size/2-size 的为execution query
    我们只需要统计执行 execution query 的信息作为最后系统的衡量标准
    warmup query 和 execution query 的内容是相同的，只是顺序不同（cpp std::shuffle打乱了顺序罢了）

·skewness
    对SSB数据中 lineorder 表的 orderdate 项数据进行倾斜
    该项数据共有七个年份1992-1998，对不同年份的数据访问进行倾斜
    访问不同年份的query语句的个数 按照Zipfian分布
    skewness越大，倾斜越严重，访问的数据分布越不均匀

·selectivity：数据选择比例
    默认为0.2，含义是每次查询都只涉及20%的数据
    但不同的query语句会在不同的20%数据中进行
    对 lineorder 表中的 discount（1-10） 或 quantity（1-50） 项进行筛选



问题：
·下面的sql运行失败：一直在99%，也不报错，不终止：
select s_city, p_brand, sum(lo_revenue - lo_supplycost) as profit
from date, customer, supplier, part, lineorder
where lo_custkey = c_custkey
  and lo_suppkey = s_suppkey
  and lo_partkey = p_partkey
  and lo_orderdate = d_datekey
  and s_nation = 'INDIA'
  and p_category = 'MFGR#34'
  and (lo_discount between 5 and 7)
  and (lo_orderdate between toDate('1998-01-01') and toDate('1998-12-31'))
group by s_city, p_brand
order by s_city, p_brand;
