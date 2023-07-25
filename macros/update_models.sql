{% macro update_models(model,column_name) %}

   update {{ ref('model')}}
	set {{ column_name }} ='PICKUP'

{% endmacro %}