select c_city, s_city, d_yearmonthnum, sum(lo_revenue) as revenue
from customer, lineorder, supplier, date
where lo_custkey = c_custkey
  and lo_suppkey = s_suppkey
  and lo_orderdate = d_datekey
  and (c_city = 'RUSSIA   9' or c_city = 'INDIA    1')
  and (s_city = 'RUSSIA   9' or s_city = 'INDIA    1')
  and (lo_quantity between 28 and 38)
  and (lo_orderdate between toDate('1994-01-01') and toDate('1994-12-31'))
group by c_city, s_city, d_yearmonthnum
order by d_yearmonthnum asc, revenue desc;
