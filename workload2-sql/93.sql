select c_name, sum(lo_revenue), sum(lo_supplycost), sum(lo_linenumber)
from customer, lineorder
where lo_custkey = c_custkey
  and c_city = 'INDIA    3'
  and lo_quantity = 22
  and (lo_orderdate between toDate('1993-01-01') and toDate('1993-12-31'))
group by c_name;
