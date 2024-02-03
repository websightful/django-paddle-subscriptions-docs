# Customization

## Conditional Showing of the Pricing Widget

You can restrict the showing of pricing widget to specific IPs by setting the `PADDLE_SUBSCRIPTIONS["RESTRICTED_TO_IPS"]` setting:

```python
PADDLE_SUBSCRIPTIONS["RESTRICTED_TO_IPS"] = ["1.2.3.4"]
```

Then in the templates of use the `request.show_paddle_subscriptions` to check whether the pricing widget needs to be included:

```django
{% if request.show_paddle_subscriptions %}
    {% load paddle_subscriptions_tags %}{% paddle_subscriptions_pricing %}
{% endif %}
```

## Free and Custom Plan Call-to-action URLs

If you have a free plan, set the `PADDLE_SUBSCRIPTIONS["FREE_PLAN_CTA_URL"]` to a URL path name, path, or a URL of the signup or waitlist page.

If you have a custom plan, set the `PADDLE_SUBSCRIPTIONS["CUSTOM_PRICING_PLAN_CTA_URL"]` to a URL path name, path, or a URL of the page with information about it.

## Display Mode

Set the `PADDLE_SUBSCRIPTIONS["CHECKOUT_DISPLAY_MODE"]` to `"overlay"` (default) or `"inline"` to display the checkout widget as a dialog box or as part of the layout.

If your display mode is `"inline"`, the following settings are required too:

- `PADDLE_SUBSCRIPTIONS["CHECKOUT_FRAME_TARGET"]`
- `PADDLE_SUBSCRIPTIONS["CHECKOUT_FRAME_STYLE"]`
- `PADDLE_SUBSCRIPTIONS["CHECKOUT_FRAME_INITIAL_HEIGHT"]`

Read about them at [Paddle Billing documentation](https://developer.paddle.com/build/checkout/build-branded-inline-checkout#pass-settings).

## Checkout Theme

Set the `PADDLE_SUBSCRIPTIONS["CHECKOUT_THEME"]` to `"light"` (default) or `"dark"` to display light or dark user interface.

In addition, you can pass a function accepting a `request` parameter which would return the `"light"` or `"dark"` based on user settings or other values:

```python
def get_paddle_subscriptions_theme(request):
    if request.user.is_authenticated and request.user.theme == request.user.ThemeChoices.DARK:
        return "dark"
    return "light"

PADDLE_SUBSCRIPTIONS["CHECKOUT_THEME"] = get_paddle_subscriptions_theme
```

## Other Checkout Settings

The `PADDLE_SUBSCRIPTIONS["CHECKOUT_SHOW_ADD_TAX_ID"]` setting defines whether the field for a tax number should be shown at checkout (default: True).

The `PADDLE_SUBSCRIPTIONS["CHECKOUT_SHOW_DISCOUNTS"]` setting defines whether the field for a discount code should be shown at checkout (default: True).

Use the `PADDLE_SUBSCRIPTIONS["CHECKOUT_SUCCESS_URL_FOR_AUTHENTICATED"]` to redirect an authenticated user who has just subscribed to a custom success page. Set the URL path name, path, or URL of that page.

If you allow the anonymous visitors to subscribe before signing up, set the `PADDLE_SUBSCRIPTIONS["CHECKOUT_SUCCESS_URL_FOR_ANONYMOUS"]` to your signup page that handles the connecting the subscription by `paddle_transaction_id` cookie to the newly registered user (default: `"/signup/"`).

## Pausing and Cancelling Subscriptions

Set whether subscriptions pausing must happen before the next billing period or immediately with `PADDLE_SUBSCRIPTIONS["WHEN_TO_PAUSE_SUBSCRIPTIONS"]` and `PADDLE_SUBSCRIPTIONS["WHEN_TO_CANCEL_SUBSCRIPTIONS"]` settings. Set them to  `"next_billing_period"` (default) or `"immediately"`.

## Administration

All Paddle Billing models can be fetched to your Django project via management commands, but not all of them are valuable for introspection. Below are the settings of what to show in administration.

Settings for Paddle Billing models:

- `PADDLE_SUBSCRIPTIONS["SHOW_PRODUCT_ADMIN"]` (default: True) - show products.
- `PADDLE_SUBSCRIPTIONS["SHOW_PRICE_ADMIN"]` (default: True) - show prices.
- `PADDLE_SUBSCRIPTIONS["SHOW_DISCOUNT_ADMIN"]` (default: False) - show discounts.
- `PADDLE_SUBSCRIPTIONS["SHOW_CUSTOMER_ADMIN"]` (default: True) - show customers.
- `PADDLE_SUBSCRIPTIONS["SHOW_ADDRESS_ADMIN"]` (default: False) - show addresses.
- `PADDLE_SUBSCRIPTIONS["SHOW_BUSINESS_ADMIN"]` (default: False) - show businesses.
- `PADDLE_SUBSCRIPTIONS["SHOW_TRANSACTION_ADMIN"]` (default: True) - show transactions.
- `PADDLE_SUBSCRIPTIONS["SHOW_SUBSCRIPTION_ADMIN"]` (default: True) - show subscriptions.
- `PADDLE_SUBSCRIPTIONS["SHOW_ADJUSTMENT_ADMIN"]` (default: False) - show adjustments.
- `PADDLE_SUBSCRIPTIONS["SHOW_EVENT_TYPE_ADMIN"]` (default: False) - show event types.
- `PADDLE_SUBSCRIPTIONS["SHOW_NOTIFICATION_SETTING_ADMIN"]` (default: True) - show notification settings (your webhook URLs).
- `PADDLE_SUBSCRIPTIONS["SHOW_NOTIFICATION_ADMIN"]` (default: False) - show notifications.
- `PADDLE_SUBSCRIPTIONS["SHOW_EVENT_ADMIN"]` (default: True) - show events.

Settings for extra Paddle Subscriptions models:

- `PADDLE_SUBSCRIPTIONS["SHOW_WEB_PROJECT_ADMIN"]` (default: True) - show web projects when you have more than one SaaS projects using the same Paddle seller's account.
- `PADDLE_SUBSCRIPTIONS["SHOW_PRODUCT_CATEGORY_ADMIN"]` (default: True) - show product categories to group your products when you have upsells.
- `PADDLE_SUBSCRIPTIONS["SHOW_SUBSCRIPTION_PLAN_ADMIN"]` (default: True) - show subscription plans.
- `PADDLE_SUBSCRIPTIONS["SHOW_SUBSCRIBER_ADMIN"]` (default: True) - show subscribers.

## Templates and CSS

The default templates are styled using TailwindCSS. To use them, it is recommended to copy them from site-packages into your project, build your CSS and collect translatable strings, and modify them as necessary.

You can replace the CSS classes and markup to Bootstrap, Foundation, Bulma, other CSS framwork, or your custom CSS too.

These are the Django Paddle Subscription templates:

- `paddle_subscriptions/`
    - `includes/`
        - `billing_dates.html` - information about the next billing dates.
        - `js.html` - the JavaScripts included for Paddle Billing checkouts.
        - `pagination.html` - pagination widget for billing history.
        - `pricing.html` - list of all plans.
        - `paid_plans.html` - list of paid plans.
        - `plan_overview.html` - single plan overview.
    - `base.html` - base page for subscriptions with the tab navigation.
    - `billing_history.html` - billing history with downloadable invoices.
    - `subscribe.html` - subscribing to a single plan.
    - `subscription_success.html` - success page after successful subscription.
    - `subscription_details.html` - main subscription page for registered users showing info about subscription plans or info about the current subscription.

## Using Content-Security-Policy with Django-CSP

The Django Paddle Subscriptions app is compatible with Content-Security-Policy via Django-CSP app. To use it, enable nonces for script tags in the project's settings:

```python
CSP_INCLUDE_NONCE_IN = ["script-src", "style-src"]
```

## Support for Upsells

Business-oriented SaaS projects allow you to buy extras after a chosen subscription is made. To implement that, you would create extra Products and Prices at Paddle Billing, link the Buy buttons to them, and handle the transactions.

Use Django signals to add your custom logic to the Django Paddle Subscriptions app. You can either use the builtin [`post_save`](https://docs.djangoproject.com/en/5.0/ref/signals/#post-save) signal for that Transaction model, or use the custom `webhook_triggered` signal that is sent when any successful request from Paddle is sent to the webhook view.

Here is an example of `webhook_triggered` signal receiver which logs JSON objects received from Paddle:

```python
# myproject/apps/misc/apps.py
from django.apps import AppConfig
from django.utils.translation import gettext_lazy as _


def log_webhook_data(sender, **kwargs):
    import os
    from django.conf import settings
    from django.utils.timezone import now

    api_event = kwargs.get("api_event")

    with open(os.path.join(settings.BASE_DIR, "logs", "webhook_data.log"), "a") as f:
        f.write(
f"""{now():%Y-%m-%d %H:%M:%S} {api_event.event_type}
{api_event.data.json()}

"""
        )


class MiscConfig(AppConfig):
    name = "myproject.apps.misc"
    verbose_name = _("Miscellaneous")

    def ready(self):
        from paddle_subscriptions.signals import webhook_triggered

        webhook_triggered.connect(log_webhook_data)
```

Note that you will receive many notifications for a single transaction to become completed, starting with the one with the status "ready" and ending with the one with the status "completed."

In addition, you can set the JavaScript callback functions at `PADDLE_SUBSCRIPTIONS["CHECKOUT_JS_EVENT_CALLBACK"]` to handle [Paddle.js events](https://developer.paddle.com/paddlejs/events/overview), or `PADDLE_SUBSCRIPTIONS["CHECKOUT_JS_TRANSACTION_COMPLETED_CALLBACK"]` to handle successful transaction in the frontend.
