select sum(lo_revenue), d_yearmonthnum, p_brand
from lineorder, date, part, supplier
where lo_orderdate = d_datekey
  and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey
  and p_category = 'MFGR#44'
  and s_region = 'ASIA'
  and (lo_discount between 1 and 3)
  and (lo_orderdate between toDate('1994-01-01') and toDate('1994-12-31'))
group by d_yearmonthnum, p_brand
order by d_yearmonthnum, p_brand;
