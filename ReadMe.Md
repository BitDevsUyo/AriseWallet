# Arise Wallet

**A BitDevsUyo community project**

Arise Wallet is an open-source initiative by the BitDevsUyo community. The goal is to build a Bitcoin non-custodial wallet while encouraging hands-on application of what we learn during our monthly socratic seminar,collaboration and learning across multiple stacks.

---

## Branches

We currently maintain two main branches for development:

- `reactnative/dev` → For React Native contributors
- `flutter/dev` → For Flutter contributors

---

## How to Contribute

We use GitHub Issues to coordinate work.

### 1. Pick an Issue

Go to the [Issues tab](../../issues) and pick an issue you'd like to work on.

- If you're new, look for issues labeled `good first issue`.
- If you have an idea that isn't listed, open a new issue and discuss it before starting.

### 2. Claim the Issue

Comment on the issue to let others know you're working on it.

### 3. Fork and Clone

Fork the repository and clone your fork:

```bash
git clone https://github.com/YOUR-USERNAME/AriseWallet.git
cd AriseWallet
```

### 4. Check Out the Correct Branch

Check out the correct branch for your stack:

```bash
git checkout reactnative/dev   # for React Native work
git checkout flutter/dev   # for Flutter work
```

### 5. Create a Feature Branch

Create a feature branch:

```bash
git checkout -b issue-<ISSUE_NUMBER>-short-description
```

### 6. Make Changes and Push

Make your changes, commit, and push to your fork:

```bash
git add .
git commit -m "your commit message"
git push origin issue-<ISSUE_NUMBER>-short-description
```

### 7. Open a Pull Request

Open a Pull Request linking the issue.

**Example:**
```
Closes #12
```

---

## Guidelines

- Always link your Pull Request to an issue so we can track work.
- Use clear commit messages (e.g. `feat: add wallet creation`, `fix: bug in transaction signing`).
- Follow the branch coding style (`reactnative/dev` or `flutter/dev`).

### Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for our commit messages. This helps maintain a clear and consistent history of changes.

#### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools and libraries

#### Examples
```bash
feat: add wallet creation functionality
fix: resolve transaction signing bug
docs: update contribution guidelines
style: format code according to project standards
refactor: simplify wallet initialization logic
perf: optimize transaction processing
test: add unit tests for wallet creation
chore: update dependencies
```

#### Scope (Optional)
Use scope to indicate the area of the codebase affected:
- `wallet`: Wallet-related functionality
- `ui`: User interface components
- `api`: API endpoints and services
- `security`: Security-related changes
- `config`: Configuration files

#### Examples with Scope
```bash
feat(wallet): add multi-signature support
fix(ui): resolve button alignment issue
docs(api): update endpoint documentation
```

#### Breaking Changes
If your commit introduces a breaking change, add `!` after the type/scope and include a `BREAKING CHANGE:` footer:

```bash
feat!: redesign wallet architecture

BREAKING CHANGE: The wallet initialization API has changed. 
The `initWallet()` function now requires a configuration object.
```

#### Best Practices
1. **Keep the subject line under 50 characters**
2. **Use the imperative mood** ("add feature" not "added feature")
3. **Capitalize the subject line**
4. **Do not end the subject line with a period**
5. **Use the body to explain what and why, not how**
6. **Wrap the body at 72 characters**
7. **Use the footer to reference issues** (e.g., "Closes #123")



## Community

This project is built by BitDevsUyo for the community. We welcome contributions from developers of all levels.

Check the [Issues](../../issues) page to get started today.
