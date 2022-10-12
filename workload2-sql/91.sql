select s_name, sum(lo_revenue), sum(lo_supplycost), sum(lo_linenumber)
from supplier, lineorder
where lo_suppkey = s_suppkey
  and s_city = 'UNITED ST2'
  and lo_quantity = 25
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by s_name;
