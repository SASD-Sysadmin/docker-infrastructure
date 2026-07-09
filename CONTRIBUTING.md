# Contributing

English is the leading repository language. User-facing operational changes should update the corresponding German document in the same pull request.

## Workflow

1. Branch from `main`.
2. Keep roles declarative and profiles focused.
3. Put data in Hiera and classification in the allowlisted `site.pp` mapping.
4. Add tests and Puppet Strings comments with every manifest change.
5. Run `bundle exec rake`.
6. Open a pull request to `main`.
7. Promote tested releases separately from `main` to `production`.

Never commit generated `modules/`, deployed environments, package credentials, certificates, private keys, or production reports.

## Milestone 3 boundaries

Application catalogs may declare only package and file resources. Server installation and CA operations are explicit bootstrap scripts. Adding service/user/exec/firewall/application behavior is a new reviewed stepstone, not a drive-by change.
