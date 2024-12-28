# PlausibleSiteManager

This is a simple site manager for Plausible Analytics.
As of v2.1, Plausible does not support Site APIs for Community Edition anymore.

This is a very very basic tool, for now it only supports adding and removing sites,
fulfilling our own basic needs.

## Features

- Add a site
- Remove a site

## Usage

The API endpoints are designed to be the same as the Plausible API.

### Add a site

```bash
# Create a site
# POST /api/v1/sites
$ curl -XPOST -H "Content-Type: application/json" -d '{"timezone": "Europe/Berlin", "domain": "domain.com"}' 'http://localhost:4000/api/v1/sites'

# Delete a site
# DELETE /api/v1/sites/:domain
$ curl -XDELETE 'http://localhost:4000/api/v1/sites/domain.com'
```
