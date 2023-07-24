with orders as (
    
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from {{source('jaffle_shop','orders')}}

------------------TEST DE DEPLOIEMENT EN PRD --------------
    {% if target.name == 'dev' %}
     where status='completed'
    {% endif %}
------------------FIN DE TEST ------------------------------
)

select * from orders