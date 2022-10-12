select s_name, sum(lo_extendedprice), sum(lo_ordtotalprice)
from supplier, lineorder
where lo_suppkey = s_suppkey
  and s_city = 'CHINA    4'
  and (lo_discount < 6 or lo_discount > 7)
  and (lo_orderdate between toDate('1993-01-01') and toDate('1993-12-31'))
group by s_name;
