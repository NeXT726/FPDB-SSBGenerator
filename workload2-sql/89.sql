select s_name, sum(lo_revenue), sum(lo_supplycost), sum(lo_linenumber)
from supplier, lineorder
where lo_suppkey = s_suppkey
  and s_city = 'RUSSIA   1'
  and lo_quantity = 22
  and (lo_orderdate between toDate('1994-01-01') and toDate('1994-12-31'))
group by s_name;
