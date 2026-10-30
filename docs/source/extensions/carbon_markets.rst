Carbon Markets
==============

Enable with ``extensions = ["carbon_markets"]`` in the config file.

cap_and_trade
-------------

Sets an annual operational-emissions limit (of one emission commodity) *per unit of capacity* for every process in
a region/technology. The cap can be relaxed by purchasing credits, up to a limit
per unit of capacity, at a fixed price. Processes emitting less than their cap are paid
the same credit price for the unused allowance.

Table ``clean_electricity_regulation``:

===============  ===========================================================
Column           Description
===============  ===========================================================
region           Region
period           Optimization period
tech             Technology
vintage          Vintage of the capped processes
emis_comm        Emission commodity that is capped
cap              Emissions allowed per unit capacity per period
credit_limit     Maximum credits purchasable per unit capacity
credit_cost      Fixed price per credit (paid when bought, received when sold)
===============  ===========================================================

For each process :math:`(r, t, v)`, with net credits :math:`CR`:

.. math::

   \sum_{i,o} EAC_e \cdot FO - CAP \cdot CAPACITY_{r,p,t,v} = \textbf{CR}_{r,p,t,v}
   \qquad
   \textbf{CR}_{r,p,t,v} \le CL \cdot CAPACITY_{r,p,t,v}

:math:`CC \cdot \textbf{CR}` (negative when credits are sold) is added to the discounted
objective. Only the table's emission commodity is counted.
