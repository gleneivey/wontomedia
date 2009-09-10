require 'tempfile'

module BlueRidge
  JavaScriptSpecDirs = ["examples/javascripts", "spec/javascripts", "test/javascript"]
  
  def self.plugin_prefix
    ENV["BLUE_RIDGE_PREFIX"] || "#{RAILS_ROOT}/vendor/plugins/blue-ridge"
  end
  
  def self.rhino_command
    "java -Dblue.ridge.prefix=\"#{plugin_prefix}\" -jar #{plugin_prefix}/lib/env-js.jar -w -debug"
  end
  
  def self.test_runner_command
    "#{rhino_command} #{plugin_prefix}/lib/test_runner.js"
  end
  
  def self.find_base_spec_dir
    return "examples" if File.exist?("examples")
    return "spec" if File.exist?("spec")
    "test"
  end

  def self.javascript_spec_dir
    base_spec_dir = find_base_spec_dir
    return "test/javascript" if base_spec_dir == "test"
    base_spec_dir + "/javascripts"
  end
  
  def self.find_javascript_spec_dir
    JavaScriptSpecDirs.find {|d| File.exist?(d) }
  end
  
  def self.find_specs_under_current_dir
    Dir.glob("**/*_spec.js")
  end
  
  def self.run_spec(spec_filename)
    system("#{test_runner_command} #{spec_filename}")
  end
  
  def self.run_specs_in_dir(spec_dir, spec_name = nil)
    result = nil
    Dir.chdir(spec_dir) { result = run_specs(spec_name) }
    result
  end
  
  def self.run_specs(spec_name = nil)
    specs = spec_name.nil? ? find_specs_under_current_dir : ["#{spec_name}_spec.js"]
    all_fine = specs.inject(true) {|result, spec| result &= run_spec(spec) }
  end


  #### build an index of our spec files for the browser
  TEMP_INDEX_PREFIX = "blue-ridge_fixture-index"

  def self.clean_up_old_temp_index_files(index_path)
    # usually, Tempfile will clean up /tmp when Rake exits, but sometimes...
    old_index_files = nil
    dir = File.dirname(index_path)
    Dir.chdir(dir){
      old_index_files = Dir.glob("**/#{TEMP_INDEX_PREFIX}*")
    }
    unless old_index_files.nil?
      old_index_files = old_index_files.map { |file| File.join(dir, file) }
      old_index_files -= [ index_path ]
      FileUtils.rm old_index_files
    end
  end

  def self.find_fixture_for_spec(spec)
    file = File.join("fixtures", spec)
    file.sub!(/\.js$/, ".html")
    needSpecParam = false
    while file =~ /_/
      file.sub!(/_[^_]*\.html$/, ".html")
      if File.exist? file
        return file, needSpecParam
      end
      needSpecParam = true
    end

    return "fixture.html", true
  end

  def self.write_html_page_with_index(html_index, specs)
    html_index.puts "<html>"
    html_index.puts "  <head>"
    if ENV['BLUERIDGE_TITLE']
      html_index.puts "    <title>#{ENV['BLUERIDGE_TITLE']}</title>"
    else
      html_index.puts "    <title>Index of Blue Ridge tests</title>"
    end
    html_index.puts "  </head>"
    html_index.puts "  <body>"
    html_index.puts "    <p>Click a link to execute the test of the"
    html_index.puts "       same name</p>"
    html_index.puts "    <h2>Blue Ridge tests</h2>"

    specs.each do |spec|
      fixture, needSpecParam = find_fixture_for_spec(spec)

      url = ENV['BLUERIDGE_PREFIX']
      if url.nil? then url = Dir.pwd end
      url += "/" + fixture
      spec.sub!(/_spec\.js$/, "")
      if needSpecParam
        url += "?" + spec
      end
      html_index.puts "    <a href='#{url}'>#{spec}</a><br/>"
    end

    html_index.puts "  </body>"
    html_index.puts "</html>"
  end

  def self.generateSpecIndexFile(js_spec_dir)
    temp_index = Tempfile.new TEMP_INDEX_PREFIX
    path = temp_index.path
    clean_up_old_temp_index_files path
    specs = []
    Dir.chdir(js_spec_dir) {
      specs = BlueRidge.find_specs_under_current_dir
      write_html_page_with_index temp_index, specs
    }
    temp_index.close
    path
  end
end
