# Django Paddle Subscriptions

## Why do you need it?

For SaaS (Software as a Service) businesses expanding into global markets, partnering with a reseller like [Paddle](https://www.paddle.com/) can be a strategic move to navigate complex tax regulations and streamline operations. Resellers like Paddle act as intermediaries, handling payments, tax compliance, and currency conversions, for their partners, freeing up SaaS companies to focus on their core product offerings.

The rules for VAT (Value Added Tax) and sales tax are varied from country to country.

For example, in the EU, VAT is charged based on the customer's location, regardless of the SaaS provider's headquarters. This means that SaaS businesses outside the EU may need to register for VAT to collect and remit taxes. Paddle simplifies this process by registering for VAT on behalf of its partners and automatically collecting the appropriate tax from each customer.

Similarly, in the US, sales tax regulations vary from state to state. Resellers like Paddle typically handle sales tax compliance, ensuring that SaaS businesses only collect taxes in the jurisdictions where they are legally required. This can save businesses time and money, as they don't need to maintain their tax expertise or register for sales tax in multiple states.

Django Paddle Subscriptions is a Django app for SaaS projects implementing free and paid subscriptions using [Paddle Billing API](https://developer.paddle.com/). It saves you at least a month of work on implementation. And it is pretty flexible and configurable to meet your business needs.

## Who is it for?

The Django Paddle Subscriptions app is for business owners and tech entrepreneurs who want to provide Django-based SaaS globally.

| Feature                                   | Value                                          |
|-------------------------------------------|------------------------------------------------|
| Supported modern browsers                 | Chrome, Firefox, Safari, Opera, Microsoft Edge |
| Supported Django versions                 | 4.2, 5.0                                       |
| Supported Python versions                 | 3.10, 3.11, 3.12                               |
| Default styling with TailwindCSS          | ✔︎                                              |
| Translatable                              | ✔︎                                              |
| Configurable                              | ✔︎                                              |
| Unlimited websites                        | ✔︎                                              |
| Localized pricing widget                  | ✔︎                                              |
| Offerred free and paid plans              | ✔︎                                              |
| Subscriptions before or after signup      | ✔︎                                              |
| Monthly and yearly pricing                | ✔︎                                              |
| List of paid invoices                     | ✔︎                                              |
| Pausing and cancelling subscriptions      | ✔︎                                              |
| Copy of Paddle data in your database      | ✔︎                                              |
| Multiple SaaS with the same Paddle account| ✔︎                                              |
| Infrastructure for upsells                | ✔︎                                              |
| Latest package version                    | 1.0.0                                          |

## What are the benefits?

There are lots of benefits:

- Saves at least a month of development work.
- Highly flexible and configurable.
- Can be used for as many Django-based SaaS projects as necessary.
- The frontend is styled with TailwindCSS for quick start, but you can overwrite the templates and introduce your custom styling.
- Comes with handy management commands to fetch Paddle data and set up the environment.
- Allows using the same Paddle account for multiple Django-based SaaS projects.
- Developed with internationalization in mind.
- Compatible with Content-Security-Policy via Django-CSP.
- MIT license applied.
- Designed and implemented by the author of "Web development with Django Cookbook."

## How does it work?

You will need a seller's account at Paddle and your business and SaaS domains approved (which might take from a few days to two weeks). At first, implement the payments in the [sandbox environment](https://sandbox-vendors.paddle.com/).

At Paddle, create Products for each subscription plan and one monthly and one yearly price for each plan. For example, Premium plan as a product will have two prices: Premium monthly and Premium yearly.

At your Django website, fetch all data from Paddle, create subscription plans, and attach the prices to the subscription plans accordingly.

Check these workflows:

- Pricing ➔ Subscription ➔ Signup ➔ Billing history
- Signup ➔ Pricing ➔ Subscription ➔ Billing history
- Pausing subscription ➔ Resuming subscription ➔ Cancelling subscription
- Pausing subscription ➔ Cancelling subscription

When ready to go live, create the same products and prices at the [live environment](https://vendors.paddle.com/). Flush the Paddle data on your server, fetch the data from the live server, and connect the prices to your subscription plans. Create a 100% discount code and test subscriptions with that code on the live environment.

## Examples

Django Paddle Subscriptions are used in production at these websites:

- [1st things 1st](https://www.1st-things-1st.com)
- [Remember Your People](https://remember-your-people.app/)

## Credits

The Django Paddle Subscriptions app under the hood uses [paddle-billing-client](https://github.com/websideproject/paddle-billing-client), which was thoroughly crafted by Benjamin Gervan.

## Disclaimer

Django Paddle Subscriptions app is provided without any warranties or guarantees, either explicit or implied.

The user is responsible for using the app responsibly and in compliance with all applicable laws and regulations. The user is also solely responsible for any financial losses or other issues that may arise from using the app.

By using this app, the user agrees to indemnify and hold harmless the app's author from any claims, damages, losses, liabilities, costs, or expenses (including reasonable attorney's fees) arising from or in connection with the app's use or misuse.

## Contact

For technical questions, feature requests, or bug reports, please contact Aidas Bendoraitis at <https://www.djangotricks.com/feedback/>.
