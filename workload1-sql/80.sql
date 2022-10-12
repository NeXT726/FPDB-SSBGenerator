select sum(lo_revenue), d_yearmonthnum, p_brand
from lineorder, date, part, supplier
where lo_orderdate = d_datekey
  and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey
  and p_brand = 'MFGR#2322'
  and s_region = 'ASIA'
  and (lo_quantity between 21 and 31)
  and (lo_orderdate between toDate('1995-01-01') and toDate('1995-12-31'))
group by d_yearmonthnum, p_brand
order by d_yearmonthnum, p_brand;
