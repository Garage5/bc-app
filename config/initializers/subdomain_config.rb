SubdomainFu.tld_sizes = {:development => ENV['SUBDOMAIN'].to_i || 0, #if .localhost, set to 0, if asdf.com, then 1
                         :test => 1, # since rspec
                         :production => 1}

# These are the subdomains that will be equivalent to no subdomain  
SubdomainFu.mirrors = ["www"]