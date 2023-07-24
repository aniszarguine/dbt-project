
    select  MOD(ORDERID,2) as champ,* from {{ source('stripe', 'payment') }}
    --where MOD(ORDERID,2) = 1;