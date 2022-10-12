select c_nation, s_nation, d_yearmonthnum, sum(lo_revenue) as revenue
from customer, lineorder, supplier, date
where lo_custkey = c_custkey
  and lo_suppkey = s_suppkey
  and lo_orderdate = d_datekey
  and c_region = 'AFRICA'
  and s_region = 'AFRICA'
  and (lo_quantity between 15 and 25)
  and (lo_orderdate between toDate('1993-01-01') and toDate('1993-12-31'))
group by c_nation, s_nation, d_yearmonthnum
order by d_yearmonthnum asc, revenue desc;
