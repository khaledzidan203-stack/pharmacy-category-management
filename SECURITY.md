# Security & Data Policy

## Public Portfolio Scope

This repository is intended for public portfolio use and must contain only synthetic or intentionally public demonstration data.

Do not commit:

- employer or internal company data
- customer or patient information
- prescription or health records
- National IDs or personal identifiers
- passwords, API keys, tokens, connection strings, or secrets
- production database files, backups, server addresses, or credentials

## Reporting a Problem

If sensitive information is discovered, do not open a public issue containing the sensitive content. Remove the exposed material from the working branch/history as appropriate and rotate any affected credential outside this repository.

## Analytical Integrity

Security also includes protecting analytical integrity:

- do not silently suppress data-quality exceptions;
- do not change KPI definitions without documentation;
- do not present descriptive promotion analysis as causal impact;
- keep assortment recommendations as decision-support flags rather than automated commercial decisions.
