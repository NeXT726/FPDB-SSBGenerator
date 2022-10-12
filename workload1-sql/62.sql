select c_city, s_city, d_yearmonthnum, sum(lo_revenue) as revenue
from customer, lineorder, supplier, date
where lo_custkey = c_custkey
  and lo_suppkey = s_suppkey
  and lo_orderdate = d_datekey
  and (c_city = 'CHINA    2' or c_city = 'INDIA    3')
  and (s_city = 'CHINA    2' or s_city = 'INDIA    3')
  and (lo_quantity between 0 and 10)
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by c_city, s_city, d_yearmonthnum
order by d_yearmonthnum asc, revenue desc;
