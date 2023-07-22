# LGTM

Who knows what the heck LGTM even stands for anyway?

Let's Get This Merged?

Let's Get this Money?

Looks Good To me?

something else?

This is an action that responds to the acronym in Pull Requests or issues with the true meaning of LGTM, or atleast up to the Random Number Generator.

Setup:

Add the `GH_TOKEN` secret to your repo with a token that has permission to comment on Issues.

```
cat .github/workflows/action.yaml

---

on:
  issue_comment:
    types: [created]

jobs:
  lgtm:
    runs-on: ubuntu-latest
    name: True meaning of LGTM
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: LGTM
      uses: beeceej/lgtm@v0.0.3
      env:
        GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
