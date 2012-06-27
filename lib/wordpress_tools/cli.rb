require 'thor'
require 'php_serialize'
# require 'thor/shell/basic'
require 'net/http'
require 'rbconfig'
require 'tempfile'
require 'wordpress_tools/cli_helper'

module WordPressTools
  class CLI < Thor
    include Thor::Actions
    include WordPressTools::CLIHelper
    
    @@lib_dir = File.expand_path(File.dirname(__FILE__))
    
    desc "new [DIR_NAME]", "download the latest stable version of WordPress in a new directory with specified name (default is wordpress)"
    method_option :locale, :aliases => "-l", :desc => "WordPress locale (default is en_US)"
    method_option :bare, :aliases => "-b", :desc => "Remove default themes and plugins"
    def new(dir_name = 'wordpress')
      download_url, version, locale = Net::HTTP.get('api.wordpress.org', "/core/version-check/1.5/?locale=#{options[:locale]}").split[2,3]
      downloaded_file = Tempfile.new('wordpress')
      begin
        puts "Downloading WordPress #{version} (#{locale})..."

        unless download(download_url, downloaded_file.path)
          error "Couldn't download WordPress."
          return
        end
        
        unless unzip(downloaded_file.path, dir_name)
          error "Couldn't unzip WordPress."
          return
        end
        
        subdirectory = Dir["#{dir_name}/*/"].first # This is probably 'wordpress', but don't assume
        FileUtils.mv Dir["#{subdirectory}*"], dir_name # Remove unnecessary directory level
        Dir.delete subdirectory
      ensure
         downloaded_file.close
         downloaded_file.unlink
      end
      
      success %Q{Installed WordPress in directory "#{dir_name}".}
      
      if options[:bare]
        dirs = %w(themes plugins).map {|d| "#{dir_name}/wp-content/#{d}"}
        FileUtils.rm_rf dirs
        FileUtils.mkdir dirs
        dirs.each do |dir|
          FileUtils.cp "#{dir_name}/wp-content/index.php", dir
        end
        success "Removed default themes and plugins."
      end
      
      if git_installed?
        if run "cd #{dir_name} && git init", :verbose => false, :capture => true
          success "Initialized git repository."
        else
          error "Couldn't initialize git repository."
        end
      else
        warning "Didn't initialize git repository because git isn't installed."
      end
    end

    desc "install [PLUGIN_NAME]", "download the latest stable version of the specified plugin ( you must use plugin slug, not real name )"
    method_option :wp_root, :aliases => "-w", :desc => "Specify the WordPress root in which install the plugin ( no trailing slash ). If not specified the gem assume that you ALREADY ARE in a WordPress root folder."
    method_option :version, :aliases => "-v", :desc => "Specify the version of the plugin you want to install"
    def install(plugin_name = nil)
      if not plugin_name
        error "You must specify a plugin name. Exiting."
        return false 
      end

      if options[:version]
        if options[:version] == 'version'
          warning "You haven''t specified any version"
          return false
        end

        download_url = "http://downloads.wordpress.org/plugin/#{plugin_name}.#{options[:version]}.zip"

        begin
          url = URI.parse(download_url)
          req = Net::HTTP.new(url.host, url.port)
          res = req.request_head(url.path)

          # Check return value and raise exception if is not 200
          res.value()
        rescue Net::HTTPServerException => e
          error "The #{options[:version]} version of the #{plugin_name} does not seem to exists"
          return false
        end

      end

      if not download_url
        serialized_api_return = Net::HTTP.get('api.wordpress.org', "/plugins/info/1.0/#{plugin_name}")
        api_return = PHP.unserialize(serialized_api_return)
        download_url = api_return.download_link
      end

      downloaded_file = Tempfile.new("#{plugin_name}")
      begin
        puts "Downloading Plugin #{plugin_name}..."

        unless download(download_url, downloaded_file.path)
          error "Couldn't download plugin #{plugin_name}."
          return
        end
        
        if options[:wp_root]
          dir_name = "#{options[:wp_root]}/wp-content/plugins"
        else
          dir_name = "wp-content/plugins"
        end
        unless unzip(downloaded_file.path, "#{dir_name}")
          error "Couldn't unzip WordPress."
          return
        end
        
      ensure
        downloaded_file.close
        downloaded_file.unlink
        success "Plugin #{plugin_name} was successfully installed, please enable it from admin backend."
      end
    end
  end
end
