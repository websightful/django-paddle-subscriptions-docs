# Getting Started

## How to Install

### 1. Download and install the package with pip

[Get Django Paddle Subscriptions from Gumroad](https://websightful.gumroad.com/l/django-paddle-subscriptions).

Create a directory `private_wheels/` in your project's repository and add the wheel file of the app there.

Link to this file in your `requirements.txt`:

```
Django==4.2
file:./private_wheels/django_paddle_subscriptions-2.4.0-py2.py3-none-any.whl
```

Install the pip requirements from the `requirements.txt` file into your project's virtual environment:

```shell
(venv)$ pip install -r requirements.txt
```

Alternatively to start quickly, install the wheel file into your Django project's virtual environment right from the shell:

```shell
(venv)$ pip install /path/to/django_paddle_subscriptions-2.4.0-py2.py3-none-any.whl
```

### 2. Add the app to `INSTALLED_APPS` of your project settings

```python
INSTALLED_APPS = [
    # ...
    "paddle_subscriptions",
]
```

### 3. Add `SubscriptionMiddleware` to the `MIDDLEWARE` setting

```python
MIDDLEWARE = [
    # ...
    "paddle_subscriptions.middleware.SubscriptionMiddleware",
]
```

It will allow to access the current subscriber's data at `request.subscriber`.

### 4. Add `PADDLE_SUBSCRIPTIONS` settings

```python
PADDLE_SUBSCRIPTIONS = {
    "API_KEY": "...",
    "PUBLIC_KEY": "...",
    "CLIENT_SIDE_TOKEN": "...",
    "ENVIRONMENT": "sandbox",
    "WEBSITE_URL": "https://example.com",
    # ...
}
```

__Important note!__ Don't commit the keys and tokens to the version control for security reasons!

Set the setting `PADDLE_SUBSCRIPTIONS['RESTRICTED_TO_IPS'] = ['...']` to show pricing or other  subscription-related widgets only to visitors from those IPs.

### 5. Add settings for PayPal

If you use PayPal as one of the alowed payment gateways, add these settings:

```python
MIDDLEWARE = [
    # ...
    "django.middleware.security.SecurityMiddleware",
]
SECURE_CROSS_ORIGIN_OPENER_POLICY = "unsafe-none"
```

### 6. Add paths to urlpatterns

```python
from django.urls import path, include

urlpatterns = [
    # ...
    # Common views, such as webhook
    path("paddle/", include("paddle_subscriptions.urls")),
    # Subscription-related views
    path("subscriptions/", include("paddle_subscriptions.urls.subscriptions")),
    # Non-recurring-purchase-related views
    path("purchases/", include("paddle_subscriptions.urls.purchases")),
]
```

### 7. Create Paddle data

In your Django project, create subscription plans with benefits for pricing widgets. If you have a free plan, set the call-to-action URL name at `PADDLE_SUBSCRIPTIONS['FREE_PLAN_CTA_URL']`, for example, the sign up or waitlist form.

For subscriptions, create Products at Paddle for each paid subscription plan, and monthly and yearly prices for each product. You can skip monthly or yearly pricing if you want, but then you will need to modify the overwritten templates to exclude them there too.

For other digital purchases, create Products at Paddle Billing for each digital good, and a price for each product. Later you will be able to group your products under product categories at your Django website.

Deploy the data to a publicly accessible staging or production website. Paddle will send events to that website.

### 8. Link Paddle with your website

Run the management command to fetch Paddle Billing data and install the webhook:

```shell
(venv)$ python manage.py set_up_paddle_subscriptions
```

The webhook at `https://example.com/subscriptions/webhook/` will be registered at Paddle and all Paddle events available in the API will be sent to it.

Then, link your subscription plans with sandbox monthly and yearly prices. 

If you have digital products, you can create nullable foreign-key relations from your models to Product model for each type and group the Product models into product categories. For example, Books can have ISBN and downloadable files, desktop apps can have downloadable files and license numbers, user credit can have balance and credit transaction items.

It's recommended to make them nullable, because while going live, you'll need to re-link those models with the new Product instances.

Also set the default payment link at Paddle (Paddle ➔ Checkout ➔ Checkout settings) to `https://example.com/paddle/payments/`. It will redirect to the correct location based on your SaaS project if you have more than one with the same Paddle account.

### 9. Create a pricing page and/or purchasable product list

Add the following template tag for subscription-plan pricing either on the start page or on a separate pricing page view:

```django
{% load paddle_subscriptions_tags %}
{% paddle_subscriptions_pricing %}
```

Add the following template tag to list out products under a specific category identified by a slug:

```django
{% load paddle_subscriptions_tags %}
{% paddle_subscriptions_category_products "licenses" %}
```

### 10. Copy the templates to your project

Copy the templates from `paddle_subscriptions/templates` in site-packages to your project and adjust them as necessary.

The copy of the templates serves two purposes: you can collect translatable strings into your project, and you can make the TailwindCSS classes discoverable by your installation.

### 11. Update your signup and account deletion views

Your Signup view must link to the subscription that has been done before signup or create a new subscriber with a free plan if they haven't subscribed yet:

```python
from paddle_subscriptions.services import (
    get_validated_unlinked_transaction, 
    connect_new_user_to_subscription,
    create_subscriber_for_free_plan, 
    get_initial_data_for_new_user, 
)


@transaction.atomic
@never_cache
def register(request, *arguments, **keywords):
    """
    Displays the registration form and handles the registration action
    """
    m = hashlib.md5()
    m.update(force_bytes(request.META["REMOTE_ADDR"]))
    request.session.session_id = m.hexdigest()[:20]

    transaction = None
    if transaction_id := request.COOKIES.get("paddle_transaction_id"):
        transaction = get_validated_unlinked_transaction(transaction_id)

    if request.method == "POST":
        form = RegistrationForm(request, request.POST)
        if form.is_valid():
            user = form.save()

            if transaction:
                connect_new_user_to_subscription(user, transaction, subscriber_name=form.cleaned_data["company_name"])
            else:
                create_subscriber_for_free_plan(user, subscriber_name=form.cleaned_data["company_name"])

            response = redirect("accounts:register_pending")

            if transaction:
                response.delete_cookie("paddle_transaction_id")

            return response
    else:
        initial = None
        if transaction:
            initial = get_initial_data_for_new_user(transaction)
            initial["company_name"] = transaction.business.name if transaction.business else ""
        form = RegistrationForm(request, initial=initial)
        if transaction:
            form.fields["email"].widget.attrs["readonly"] = True

    request.session.set_test_cookie()

    response = render(
        request,
        "accounts/signup.html",
        {"form": form},
    )

    return response

```

Then your account deletion view must cancel the existing subscription:

```python
from paddle_subscriptions.services import cancel_subscription


@login_required
def delete_account(request):
    context = {}
    if (
        request.user.is_authenticated
        and not request.user.is_staff
        and request.method == "POST"
    ):
        form = DeleteAccountForm(user=request.user, data=request.POST)
        if form.is_valid():
            user = request.user

            if subscription := request.subscriber.current_subscription:
                cancel_subscription(subscription, effective_from="immediately")
            if request.subscriber.membership_set.count() == 1:
                request.subscriber.delete()

            auth_logout(request)
            form.delete()

            response = redirect("accounts:delete_account_complete")
            return response
    else:
        form = DeleteAccountForm(user=request.user)
    context["form"] = form
    return render(request, "accounts/delete_account.html", context)
```

### 12. Handle the purchases with the `webhook_triggered` signal

When selling digital goods, make sure to update user's access to the purchased products at the 
`webhook_triggered` signal handler. Some examples:

- Link a purchased ebook to a user.
- Link a purchased app or license number to a user.
- Update user credit balanse based on the bought credits.

Here is an example with credits:

__myproject/apps/credits/apps.py__

```python
from django.apps import AppConfig


class CreditsConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "myproject.apps.credits"

    def ready(self):
        from paddle_subscriptions.signals import webhook_triggered
        from .signal_handlers import update_credits

        webhook_triggered.connect(update_credits)
```

__myproject/apps/credits/signal_handlers.py__

```python
def update_credits(sender, **kwargs):
    """
    Add credits that the user bought to their credit balance.
    """
    from django.conf import settings
    from django.db import transaction as db_transaction
    from myproject.apps.accounts.models import User
    from myproject.apps.credits.models import Credit, CreditTransaction
    from paddle_subscriptions.models import Transaction

    api_event = kwargs.get("api_event")
    if api_event.event_type != "checkout.completed":
        return

    transaction_id = api_event.data["transaction_id"]
    if not (transaction := Transaction.objects.filter(pk=transaction_id).first()):
        return

    transaction_item = transaction.transactionitem_set.first()
    if transaction_item.price.billing_cycle_interval or not (
        user := User.objects.filter(pk=transaction.custom_data.get("user_id")).first()
    ):
        return

    if not (
        credits_to_add := settings.PADDLE_PRODUCT_PRICE_CREDITS.get(
            transaction_item.price.name
        )
    ):
        return

    credits_to_add = credits_to_add * transaction_item.quantity

    credit, _created = Credit.objects.get_or_create(user=user)
    with db_transaction.atomic():
        credit_transaction = CreditTransaction.objects.create(
            user=user,
            transaction_type=CreditTransaction.TransactionType.BOUGHT,
            credits=credits_to_add,
        )
        credit.balance += credit_transaction.credits
        credit.save()

```

## How to Use

### 1. The subscription details page

The page at `https://example.com/subscriptions/` allows you to subscribe to a paid plan or view the details of your current subscription.

Use the `{% url "paddle_subscriptions:subscription_details" %}` in the templates to link to that page.

Test the pausing, resuming, and cancelling subscriptions there. Also test the billing history and invoices.

### 2. Check subscriber status in views or templates

These are some common values that might be interesting in your views and templates about the current subscriber:

```python
# The slug of the current subscriber's subscription plan
request.subscriber.plan.slug

# Does the current subscriber have free access to their subscription plan?
# (the plan itself is free or the subscriber has an exclusive manually set free access)
request.subscriber.has_free_access

# Is the current subscription active?
request.subscriber.is_subscription_active

# Will the current subscription be paused at the end of the billing cycle?
request.subscriber.is_subscription_to_be_paused

# Is the current subscription paused at the moment?
request.subscriber.is_subscription_paused

# Will the current subscription be cancelled at the end of the billing cycle?
request.subscriber.is_subscription_to_be_cancelled

# Is the current subscription cancelled at the moment?
# (only possible for pricing without a free plan)
request.subscriber.is_subscription_cancelled
```

### 3. Translate the strings in your templates

If your website has more than one language, prepare the translations:

- Use management command `makemessages` to collect translatable strings into `django.po` files.
- Translate the strings to the languages you need.
- Then, use the management command `compilemessages` to compile them to `django.mo` files.

## When going live

Paddle has an extensive [list of steps about going live](https://developer.paddle.com/build/onboarding/set-up-checklist). Read it thoroughly. What relates to Django Paddle Subscriptions follows:

### 1. Set Paddle environment to live

Set the environment to "live":

```python
PADDLE_SUBSCRIPTIONS["ENVIRONMENT"] = "live"
```

Make sure that `PADDLE_SUBSCRIPTIONS["WEBSITE_URL"]` points to the URL of the production website, which has to be approved by Paddle.

Remove the `PADDLE_SUBSCRIPTIONS["RESTRICTED_TO_IPS"]` setting.

### 2. Flush staging data and set up Paddle subscription anew

```bash
(venv)$ python manage.py flush_paddle_billing_models
(venv)$ python manage.py set_up_paddle_subscriptions
```

Then, link your subscription plans with live monthly and yearly prices. Also link your specific product models with the Product model and attach the categories for them.

### 3. Test live payments and subscriptions

Create a 100% discount code on the Paddle live environment and test your subscriptions with that code.
