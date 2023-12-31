
/*
Description : 
-------------------------------------------------------------------------------------
Author      : Talan
Version     : 1.0
Created     : 20210125_1623
RequestId   : JIRA
------------------------------------------------------------------------------------
Modified    : 24/07/2023
By          : AMAI
RequestId   : Mettre le Ticket de la JIRA
Comment     : Premier model de la DIM_CUSTOMER
*/

{{ config(
  enabled=true
) }}

with customers as (
    select * from {{ ref('stg_customers')}}
),
orders as (
    select * from {{ ref('fct_orders')}} 
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value
    from customers
    left join customer_orders using (customer_id)
)
select * from final
------------------TEST DE DEPLOIEMENT EN PRD/UAT AMAI le 25/07/2023  --------------
    {% if target.name == 'prd' %}
     where NUMBER_OF_ORDERS>'1'
    
    {% elif target.name == 'uat' %}
     where NUMBER_OF_ORDERS>'2'

    {% endif %}
------------------FIN DE TEST ------------------------------------------------------