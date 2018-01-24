#!/usr/bin/env bash
certbot certonly --webroot --webroot-path /srv/www -d pipefail.com -d www.pipefail.com
