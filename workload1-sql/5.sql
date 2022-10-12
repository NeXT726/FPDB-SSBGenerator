select sum(lo_revenue), d_yearmonthnum, p_brand
from lineorder, date, part, supplier
where lo_orderdate = d_datekey
  and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey
  and (p_brand between 'MFGR#2123' and 'MFGR#2130')
  and s_region = 'AMERICA'
  and (lo_quantity between 19 and 29)
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by d_yearmonthnum, p_brand
order by d_yearmonthnum, p_brand;
