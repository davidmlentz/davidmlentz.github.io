# Displaying custom messages with the case tag

The `case` tag can help you easily customize your content. Combined with `when` and `else`, `case` allows you to present different messages in different circumstances. This can be useful, for example, when you want to tailor a message to a shopper based on their country.

In the example below, the page displays a custom greeting based on the value of the `country` variable. 

```liquid
{% assign country = 'GB' %}

{% case country %}

{% when 'AU' %}
        G'day.
{% when 'GB' %}
        'Ello.
{% when 'US' %}
        Hi.
{% else %}
        Welcome, shopper from {{country}}!
{% endcase %}
```
