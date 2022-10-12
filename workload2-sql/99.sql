select c_name, sum(lo_extendedprice), sum(lo_ordtotalprice)
from customer, lineorder
where lo_custkey = c_custkey
  and c_city = 'INDIA    1'
  and (lo_discount < 4 or lo_discount > 5)
  and (lo_orderdate between toDate('1994-01-01') and toDate('1994-12-31'))
group by c_name;
