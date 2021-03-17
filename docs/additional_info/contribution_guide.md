# Contributing

1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Implement your feature or bug fix.
4. Don't forget to add tests and make sure they pass by running `mix test`. To view test coverage, run `mix coveralls.html`.
5. Make sure your code complies with the style guide by running `mix format`.
6. If necessary, add documentation for your feature or bug fix.
7. Commit and push your changes.
8. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-branches
[pr]: https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests

## Running tests

1. Copypaste `.env.sample` file as `.env` (for nix systems) or `.env.bat.sample` as `.env.bat` (for Windows). Put your API token inside and run `source .env` or `.env.bat` from your terminal. The `.env` file is excluded from version control so your token is safe. All in all, we use pre-recorded VCR cassettes, so the actual API requests won't be sent. However, providing at least some token is required.
3. Run `mix coveralls.html`. Observe test results and code coverage.

## Previewing the docs locally

1. Clone the repo.
2. `cd docs`
3. `bundle exec jekyll serve --baseurl=''`.
4. Navigate to `http://localhost:4000` and observe the docs.
