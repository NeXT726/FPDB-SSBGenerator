select c_name, sum(lo_extendedprice), sum(lo_ordtotalprice)
from customer, lineorder
where lo_custkey = c_custkey
  and c_city = 'INDIA    8'
  and (lo_discount < 6 or lo_discount > 7)
  and (lo_orderdate between toDate('1992-01-01') and toDate('1992-12-31'))
group by c_name;
