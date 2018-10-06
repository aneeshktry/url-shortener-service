class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def random_string
    
        o = [('a'..'z')].map { |i| i.to_a }.flatten
        string = (0...36).map { o[rand(o.length)] }.join
        @random_string ||= string[5..12]
     
      end
    
      def small_url(random_string)
    
        credentials + random_string
    
      end
    
      def credentials
        @host ||= YAML.load_file("#{::Rails.root}/config/host.yml")[Rails.env]["host"]
      end

      def get_host_and_path(url)
        uri = URI.parse(url)
        uri = URI.parse("http://#{url}") if uri.scheme.nil?
        host = uri.host.downcase
        host = host.start_with?('www.') ? host[4..-1] : host
        path = uri.path
        path = path + '?' + uri.query unless uri.query.nil?
        path = path + '#' + uri.fragment unless uri.fragment.nil?
        [host,path]
      end
end
