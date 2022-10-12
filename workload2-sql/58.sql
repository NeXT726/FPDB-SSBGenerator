select s_name, sum(lo_extendedprice), sum(lo_ordtotalprice)
from supplier, lineorder
where lo_suppkey = s_suppkey
  and s_city = 'UNITED ST8'
  and (lo_discount < 3 or lo_discount > 4)
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by s_name;
