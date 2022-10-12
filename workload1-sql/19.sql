select c_nation, s_nation, d_yearmonthnum, sum(lo_revenue) as revenue
from customer, lineorder, supplier, date
where lo_custkey = c_custkey
  and lo_suppkey = s_suppkey
  and lo_orderdate = d_datekey
  and c_region = 'EUROPE'
  and s_region = 'EUROPE'
  and (lo_discount between 3 and 5)
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by c_nation, s_nation, d_yearmonthnum
order by d_yearmonthnum asc, revenue desc;
