Welcome to Matic Data Test assignment

### Setting up environment
- [Install dbt](https://docs.getdbt.com/docs/installation)
- [Install postgres](https://www.postgresql.org/download/)
- Create database and user for project
```postgresql
create database data_test_assignment;
create user data_test_assignment with encrypted password 'ThisShouldBeStrongPassword';
grant all privileges on database data_test_assignment to data_test_assignment;
```
- Create DBT profile `~/.dbt/profile`
```yaml
test_assignment:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: data_test_assignment
      pass: ThisShouldBeStrongPassword
      dbname: data_test_assignment
      schema: development
      threads: 4
```
- Check configuration. Run `dbt debug` and fix any errors.
- Seed database with data. Run: `dbt seed`

### Using the project

Try running the following commands:
- `dbt run`
- `dbt test`


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/overview)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
