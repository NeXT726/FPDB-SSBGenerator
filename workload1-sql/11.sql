select sum(lo_revenue), d_yearmonthnum, p_brand
from lineorder, date, part, supplier
where lo_orderdate = d_datekey
  and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey
  and p_category = 'MFGR#43'
  and s_region = 'AFRICA'
  and (lo_discount between 0 and 2)
  and (lo_orderdate between toDate('1996-01-01') and toDate('1996-12-31'))
group by d_yearmonthnum, p_brand
order by d_yearmonthnum, p_brand;
