select sum(lo_revenue), d_yearmonthnum, p_brand
from lineorder, date, part, supplier
where lo_orderdate = d_datekey
  and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey
  and (p_brand between 'MFGR#3520' and 'MFGR#3527')
  and s_region = 'MIDDLE EAST'
  and (lo_quantity between 12 and 22)
  and (lo_orderdate between toDate('1995-01-01') and toDate('1995-12-31'))
group by d_yearmonthnum, p_brand
order by d_yearmonthnum, p_brand;
