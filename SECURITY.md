# Security & Data Policy

## Public repository scope

This repository must contain only synthetic or intentionally public demonstration material.

Do not commit:

- employer or internal company data;
- customer or patient information;
- prescription or health records;
- government identifiers or personal identifiers;
- passwords, API keys, tokens, connection strings, certificates, or secrets;
- production database files, backups, server addresses, or credentials;
- confidential supplier terms or commercial agreements.

## Reporting a problem

If sensitive information is discovered, do not open a public issue containing the sensitive value. Remove the material from the branch/history as appropriate and rotate any affected credential outside this repository.

## Analytical integrity

Security includes analytical integrity:

- do not silently suppress data-quality exceptions;
- do not change KPI definitions without documentation and regression coverage;
- do not merge the SQL full demo and Python CSV fixture into one claimed dataset;
- do not present descriptive promotion analysis as causal;
- do not present review labels as automated commercial decisions;
- do not claim Power BI runtime validation without a committed runtime artifact and reconciliation evidence.
