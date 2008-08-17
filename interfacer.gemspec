Gem::Specification.new do |s|
  s.name     = "interfacer"
  s.version  = "0.0.1"
  s.date     = "2008-08-17"
  s.summary  = "Make interfaces that can be enabled at will in your classes"
  s.email    = "todd@rubidine.com"
  s.homepage = "http://github.com/xtoddx/interfacer"
  s.description = "Wrap methods in an interface so they are invisible in your instances until an interfaces is activated.  Multiple interfaces and default methods are supported."
  s.has_rdoc = true
  s.authors  = ['Todd Willey']
  s.files    = [
    "README", 
    "interfacer.gemspec", 
    "lib/interfacer.rb", 
    "test/interfacer.rb"
  ]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  # s.add_dependency("test-spec", [">= 0.9.0"])
end
