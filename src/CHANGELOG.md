Changelog
=========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).



[Unreleased]
------------

[v2.3.1] - 2024-08-19
------------------

### Fixed

- URL resolving in the JavaScript snippet fixed.

[v2.3.0] - 2024-08-17
------------------

### Changed

- Timeout for localized pricing decreased to 3 seconds and made configurable, not to stop the start pages with pricing information for too long.

### Fixed

- Missing template tag library loaded.

[v2.2.0] - 2024-08-16
------------------

### Added

- Information that unlocalized pricing is used when it's used.

### Changed

- Timeout for localized pricing increased from 1 to 5 seconds.
- Fall back to the default pricing if local prices are not returned in time.
- Missing translatable strings added.

[v2.1.1] - 2024-08-16
------------------

### Removed

- Template cleanup.

[v2.1.0] - 2024-08-09
------------------

### Added

- Django 5.1 support.

[v2.0.2] - 2024-07-17
------------------

### Changed

- Catching an error of mixmatched transactions.

[v2.0.1] - 2024-07-15
------------------

### Fixed

- Don't show the next billing date if the current plan is free.

[v2.0.0] - 2024-07-14
------------------

### Added

- Buying non-recurring digital products.

### Changed

- List administration made more user-friendly.
- Template tags allow setting a custom template.
- Separation of subscriptions and purchases.

[v1.4.1] - 2024-07-01
------------------

### Changed

- The paddle-billing-client version requirements updated.


[v1.4.0] - 2024-06-29
------------------

### Fixed

- Fixed support for non-recurring products.

[v1.3.3] - 2024-06-28
------------------

### Fixed

- Showing nice transaction details for fully discounted transactions.
- Showing prices for fully discounted transactions in the transaction history view.

[v1.3.2] - 2024-02-14
------------------

### Fixed

- More stable real-time pricing handling.

[v1.3.1] - 2024-02-13
------------------

### Fixed

- Prices rounded to cents in the pricing page.

[v1.3.0] - 2024-02-11
------------------

### Added

- Unit tests for fetching information from Paddle Billing.

### Fixed

- Saving adjustments fixed.


[v1.2.1] - 2024-02-10
------------------

### Changed

- Link to documentation

[v1.2.0] - 2024-02-10
------------------

### Added

- Templates added
- Markdown files added

[v1.1.0] - 2024-02-10
------------------

### Changed

- Functions refactored.

### Fixed

- Cosmetic styling adjustments.

[v1.0.0] - 2024-02-06
------------------

### Added

- Paddle Billing models.
- Custom Django Paddle Subscriptions models.
- Management commands to fetch data from Paddle Billing.
- Management command to set up the webhook.
- Management command to flush Paddle Billing models.
- Pricing widget.
- Subscription details page.
- Pausing and resuming subscriptions.
- Cancelling subscriptions.
- Billing history with invoice downloads.
- Lots of customizations via settings.

<!--
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
-->


