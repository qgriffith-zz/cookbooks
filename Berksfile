source "https://supermarket.chef.io"

cookbook "datadog"
cookbook "aws", "2.5.0" #Bug in cookbook, see issue 181
cookbook "ohai", "~> 3.0" #We have to lock this to Chef 11 supported version
cookbook "apt", "2.9.2" #We must lock this to the last supported version for Chef 11
