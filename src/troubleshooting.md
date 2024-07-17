# Troubleshooting

## Notifications

### After updating the webhook settings at Paddle Billing, the notifications don't pass verification

Django Paddle Subscriptions use a copy of Paddle data in your website's database. If you modify the webhook destination manually at Paddle Billing, the data will be out of sync and it might raise invalid verification error.

Make sure to update it in your database too. Do that in Django administration or by fetching it with this management command:

```bash
(venv)$ python manage.py fetch_paddle_notifications_events
```
