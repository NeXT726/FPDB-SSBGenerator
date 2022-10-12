select c_name, sum(lo_revenue), sum(lo_supplycost), sum(lo_linenumber)
from customer, lineorder
where lo_custkey = c_custkey
  and c_city = 'RUSSIA   7'
  and lo_quantity = 32
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by c_name;
