# Docksal Certificate Manager (dcert)

Unified mkcert + Docksal TLS automation for local HTTPS development.

version 2.1.0

`dcert` guarantees correct trust at **all three layers**:

1. **Browser trust (macOS System Keychain → mkcert root CA)**
2. **Container trust (Debian CA store → update-ca-certificates)**
3. **PHP/Guzzle/Drupal trust (php.ini CA bundle settings)**

This prevents:

- Browser “Not Secure”
- cURL `SSL certificate problem: unable to get local issuer certificate`
- Guzzle `cURL error 60`
- Drupal/Drush HTTPS failures
- Certificate mismatch issues
- Stale or broken CA symlinks in Debian

---

# Commands

### `fin dcert`

Runs the full setup:

- Ensures mkcert root CA exists
- Ensures project certificates exist
- Installs root CA into CLI container trust store
- Repairs Debian CA state (stale links, missing hash symlinks)
- Ensures php.ini CA configuration
- Restarts Docksal project
- Automatically runs `fin dcert verify`

---

### `fin dcert verify`

Runs **full diagnostics**, including:

- Host mkcert CAROOT validation
- Docksal ca-root.crt validation
- Container CA store contents
- Certificate issuer comparisons
- Bundle membership tests
- PHP CA settings
- HTTPS test via `curl` inside CLI

---

### `fin dcert trust-host`

Ensures the **macOS System Keychain** trusts mkcert’s Root CA, then restarts the default browser.

---

# Trust Requirements Overview

Local HTTPS requires **three independent trust chains**:

| Layer                                  | Purpose                               | Fails When                        |
| -------------------------------------- | ------------------------------------- | --------------------------------- |
| **Browser (macOS System Keychain)**    | Allows HTTPS to load without warnings | mkcert root CA not trusted        |
| **Container (Debian CA/openssl/curl)** | Allows internal HTTPS requests        | mkcert CA not in system bundle    |
| **PHP (Guzzle/Drush cURL)**            | Allows programmatic HTTPS             | php.ini missing CA bundle mapping |

---

# Certificate File Table

| Filename            | Required By        | Required In Directory            | Created By             | OS Layer  | Trust System      | Role                    | Permissions | Contents       |
| ------------------- | ------------------ | -------------------------------- | ---------------------- | --------- | ----------------- | ----------------------- | ----------- | -------------- |
| rootCA.pem          | macOS, Container   | mkcert CAROOT                    | mkcert -install        | Host      | mkcert root       | Source root certificate | 0644        | Root CA        |
| ca-root.crt         | Browser, Container | ~/.docksal/certs                 | dcert                  | Host      | Docksal reference | Copy of rootCA.pem      | 0644        | Root CA        |
| ${VIRTUAL_HOST}.crt | Browser, Server    | ~/.docksal/certs                 | mkcert                 | Host      | Leaf cert         | Project certificate     | 0644        | Leaf cert      |
| ${VIRTUAL_HOST}.key | Server only        | ~/.docksal/certs                 | mkcert                 | Host      | Private key       | Leaf private key        | 0600        | Private key    |
| docksal-root-ca.crt | cURL, openssl      | /usr/local/share/ca-certificates | dcert                  | Container | CA store          | Root CA                 | 0644        | Root CA        |
| docksal-root-ca.pem | cURL, openssl      | /etc/ssl/certs                   | update-ca-certificates | Container | CA hash index     | Symlink                 | symlink     | Points to .crt |
| ca-certificates.crt | cURL, PHP          | /etc/ssl/certs                   | update-ca-certificates | Container | System bundle     | Combined CA bundle      | 0644        | Aggregate CAs  |
| php.ini             | PHP (Guzzle/Drush) | .docksal/etc/php/php.ini         | dcert                  | Container | PHP CA config     | Sets CA paths           | 0644        | CAfile/cainfo  |

---

# Files Created

### Host

```txt
- /Users/dan/Library/Application Support/mkcert/rootCA.pem (Host OS Root CA package)
- ~/.docksal/certs/ca-root.crt
- ~/.docksal/certs/${VIRTUAL_HOST}.crt
- ~/.docksal/certs/${VIRTUAL_HOST}.key
- PROJECT/.docksal/etc/php/php.ini
```

### Container

```txt
- /usr/local/share/ca-certificates/docksal-root-ca.crt
- /etc/ssl/certs/docksal-root-ca.pem
- /etc/ssl/certs/ca-certificates.crt
```
