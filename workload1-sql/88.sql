select sum(lo_revenue), d_yearmonthnum, p_brand
from lineorder, date, part, supplier
where lo_orderdate = d_datekey
  and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey
  and (p_brand between 'MFGR#2119' and 'MFGR#2126')
  and s_region = 'MIDDLE EAST'
  and (lo_quantity between 5 and 15)
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by d_yearmonthnum, p_brand
order by d_yearmonthnum, p_brand;
