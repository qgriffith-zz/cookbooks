Public cookbooks, intended for use with AWS.
No sensitive information should be included in this repo.

### Monitoring
To add the datadog agent to your opsworks application simply

1. Add the DD key to your application as an enviornment variable called `DATADOG_KEY`
1. `include_recipe 'opsworks_datadog'` in your application cookbook

