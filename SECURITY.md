# Security Policy

## Reporting

If you find a security issue, please do not open a public issue with secrets,
tokens, database dumps, or personal data. Contact the maintainer privately and
include the affected module, reproduction steps, and expected impact.

## Secrets

Do not commit real API keys or database passwords. Use environment variables
such as `SPARK_API_KEY` and keep local overrides out of Git.
