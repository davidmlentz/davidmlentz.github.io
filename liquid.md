# Liquid.md
Liquid.md

The `case` logic tag can help you easily customize the content of the pages your users see. Combined with `when` and `else`, 
`case` allows you to present different messages in different circumstances. This can be useful, for example, when you want to 
tailor a message on the order status page of checkout to users based on their country.

Case functions as if...then logic. For example, ...

```liquid
{% assign country = 'GB' %}

{% case country %}

{% when 'AU' %}
        G'day.
{% when 'GB' %}
        Ello.
{% when 'US' %}
        Hi.
{% else %}
        Welcome, shopper from {{country}}!
{% endcase %}
```
