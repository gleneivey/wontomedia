
begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "wontomedia"
    s.rubyforge_project = "wontomedia"
    s.summary = "WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme"
    s.description = <<-ENDOSTRING
      WontoMedia is a Ruby-on-Rails web app for community creation of
      an information classification scheme.  WontoMedia is free
      software (licensed under the AGPL v3), and is being developed by
      a dispersed volunteer team using agile methods.
ENDOSTRING

    s.email = "gleneivey@wontology.org"
    s.homepage = "http://wontomedia.rubyforge.org"
    s.authors = ["Glen Ivey"]

    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]

    s.files =  FileList["*", "{app,config,bin,db,features,generators,lib,policy,public,script,test,vendor}/**/*"]
    s.add_dependency 'rails', '~>2.2'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

