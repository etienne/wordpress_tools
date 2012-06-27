require 'spec_helper'

describe WordPressTools::CLI do
  before :each do
    @original_wd = Dir.pwd
    
    wp_api_response = <<-eof
      upgrade
      http://wordpress.org/download/
      http://wordpress.org/wordpress-3.3.1.zip
      3.3.1
      en_US
      5.2.4
      5.0
    eof

    FakeWeb.register_uri(
      :get, 
      %r|http://api.wordpress.org/core/version-check/1.5/.*|, 
      :body => wp_api_response)
    FakeWeb.register_uri(
      :get, 
      'http://wordpress.org/wordpress-3.3.1.zip', 
      :body => File.expand_path('spec/fixtures/wordpress_stub.zip'))
    
    # First plugin stub
    FakeWeb.register_uri(
      :get, 
      'http://api.wordpress.org/plugins/info/1.0/wordless', 
      :body => File.expand_path('spec/fixtures/wordless_plugin_api.php'))
    FakeWeb.register_uri(
      :get, 
      'http://downloads.wordpress.org/plugin/wordless.zip', 
      :body => File.expand_path('spec/fixtures/wordless.zip'))
    FakeWeb.register_uri(
      :any, 
      'http://downloads.wordpress.org/plugin/wordless.0.0.zip', 
      :status => ["404", "Not Found"])
    FakeWeb.register_uri(
      :any, 
      'http://downloads.wordpress.org/plugin/wordless.0.1.zip', 
      :body => File.expand_path('spec/fixtures/wordless.zip'))

    
    Dir.chdir('tmp')
  end

  context "#new" do
    context "with no arguments" do
      it "downloads a copy of WordPress" do
        WordPressTools::CLI.start ['new']
        File.exists?('wordpress/wp-content/index.php').should eq true
      end

      it "initializes a git repository" do
        WordPressTools::CLI.start ['new']
        File.directory?('wordpress/.git').should eq true
      end
      
      it "doesn't leave a stray 'wordpress' directory" do
        WordPressTools::CLI.start ['new']
        File.directory?('wordpress/wordpress').should eq false
      end
    end
    
    context "with a custom directory name" do
      it "downloads a copy of WordPress in directory 'myapp'" do
        WordPressTools::CLI.start ['new', 'myapp']
        File.exists?('myapp/wp-content/index.php').should eq true
      end
    end
    
    context "with the 'bare' option" do
      it "downloads a copy of WordPress and removes default plugins and themes" do
        WordPressTools::CLI.start ['new', '--bare']
        (File.exists?('wordpress/wp-content/plugins/hello.php') || File.directory?('wordpress/wp-content/themes/twentyeleven')).should eq false
      end
    end
  end

  context "#install" do

    before :each do
      WordPressTools::CLI.start ['new']
    end

    context "with no arguments" do
      it "should return false" do
        WordPressTools::CLI.start(['install']).should be_false
      end
    end

    context "with one arguments" do
      it "downloads a copy of the plugin and unzip it in the plugins folder" do
        Dir.chdir('wordpress')
        WordPressTools::CLI.start ['install', 'wordless']
        Dir.chdir('..')
        File.directory?('wordpress/wp-content/plugins/wordless').should be_true
      end
    end

    context "with --wp_root" do
      it "downloads a copy of the plugin and unzip it in the plugins folder of the specified WordPress installation" do
        WordPressTools::CLI.start ['install', 'wordless', '-w', 'wordpress']
        File.directory?('wordpress/wp-content/plugins/wordless').should be_true
      end
    end

    context "with --version" do
      it "return false if no version is specified" do
        WordPressTools::CLI.start(['install', 'wordless', '-v']).should be_false
      end

      it "return false if the specified version is not found" do
        WordPressTools::CLI.start(['install', 'wordless', '-v', '0.0']).should be_false
      end

      it "downloads the specified version of the plugin and unzip it in the plugins folder" do
        Dir.chdir('wordpress')
        WordPressTools::CLI.start ['install', 'wordless', '-v', '0.1']
        Dir.chdir('..')
        File.directory?('wordpress/wp-content/plugins/wordless').should be_true
      end
    end

  end

  context "#remove" do

    before :each do
      WordPressTools::CLI.start ['new']
      WordPressTools::CLI.start ['install', 'wordless', '-w', 'wordpress']
    end

    context "with no arguments" do
      it "should return false" do
        WordPressTools::CLI.start(['remove']).should be_false
      end
    end

    context "with one argument" do
      it "should return false if plugin directory does not exists" do
        Dir.chdir('wordpress')
        WordPressTools::CLI.start(['remove', 'cantfindplugin']).should be_false
        Dir.chdir('..')
      end

      it "should remove the plugin folder" do
        Dir.chdir('wordpress')
        WordPressTools::CLI.start ['remove', 'wordless']
        Dir.chdir('..')
        File.directory?('wordpress/wp-content/plugins/wordless').should be_false
      end
    end

    context "with --wp-root" do
      it "should return false if plugin directory does not exists" do
        WordPressTools::CLI.start(['remove', 'cantfindplugin', '-w', 'wordpress']).should be_false
      end

      it "sould remove the plugin folder" do
        WordPressTools::CLI.start ['remove', 'wordless', '-w', 'wordpress']
        File.directory?('wordpress/wp-content/plugins/wordless').should be_false
      end
    end

  end
  
  after :each do
    Dir.chdir(@original_wd)
    %w(tmp/wordpress tmp/myapp).each do |dir|
      FileUtils.rm_rf(dir) if File.directory? dir
    end
  end
end
