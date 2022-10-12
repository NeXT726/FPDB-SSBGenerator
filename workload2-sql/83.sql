select c_name, sum(lo_revenue), sum(lo_supplycost), sum(lo_linenumber)
from customer, lineorder
where lo_custkey = c_custkey
  and c_city = 'INDIA    4'
  and lo_quantity = 26
  and (lo_orderdate between toDate('1997-01-01') and toDate('1997-12-31'))
group by c_name;
