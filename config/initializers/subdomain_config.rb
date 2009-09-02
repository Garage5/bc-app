SubdomainFu.tld_sizes = {:development => 0, #for .local, if .localhost, set to 0
                         :test => 1, # since rspec
                         :production => 1}

# These are the subdomains that will be equivalent to no subdomain  
SubdomainFu.mirrors = ["www"]
