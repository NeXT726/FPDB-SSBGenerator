select sum(lo_revenue), d_yearmonthnum, p_brand
from lineorder, date, part, supplier
where lo_orderdate = d_datekey
  and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey
  and p_brand = 'MFGR#3222'
  and s_region = 'EUROPE'
  and (lo_quantity between 10 and 20)
  and (lo_orderdate between toDate('1998-01-01') and toDate('1998-12-31'))
group by d_yearmonthnum, p_brand
order by d_yearmonthnum, p_brand;
