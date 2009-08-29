SubdomainFu.tld_sizes = {:development => 1, #for .local, if .localhost, set to 0
                         :test => 1, # since rspec
                         :production => 2}

# These are the subdomains that will be equivalent to no subdomain  
SubdomainFu.mirrors = ["www"]
