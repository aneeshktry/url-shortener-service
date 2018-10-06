class Api::V1::ShortUrlsController < ApplicationController
    before_action :set_default_format
    before_action :get_url, except: [:index,:create]
    
    def index
      response = { status: "success" }
      response["short_url_list"] = ShortUrl.select("original_url,shortend_url").map {|x| {original_url: x.original_url, shortend_url: x.shortend_url}}
      render :json => response
    end
    
    def create
        response = { status: "success" }
        url = params["url"]
        if !url.blank? && url.match(/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix)
          host,path = get_host_and_path(url)
          if path.blank?
            @short_url = ShortUrl.find_by_host("#{host}") || ShortUrl.new
          else
            @short_url = ShortUrl.where("host = ? AND path = ?",host,path).first || ShortUrl.new
          end
          if @short_url.new_record?
            @short_url.original_url = url
            @short_url.host = host
            @short_url.path = path
            @short_url.random_string = random_string
            @short_url.shortend_url = small_url(random_string)
            if @short_url.valid?
              @short_url.save
              response[:message] = "Successfully created shortend url"
              response[:short_url] = @short_url.shortend_url
            else
                response[:status] = "Error"
                response[:message] = @short_url.errors.full_messages
            end
          else
            response[:message] = "Given url already exists"
            response[:short_url] = @short_url.shortend_url
          end
        else
          response[:status] = "Error"
          response[:message] = "The given url should not be blank and should be a valid url"
        end
        
        render :json => response
    end
    
    def show
      response = { status: "success" }
      if @shortend_url
        response["original_url"] = @shortend_url.original_url
        response["shortend_url"] = @shortend_url.shortend_url
      else
        response["status"] = "Error"
        response["message"] = "Cannot find given url"
      end
      render :json => response
    end
    
    def destroy
      response = { status: "success" }
      if @shortend_url.destroy
        response["message"] = "Successfully deleted"
      else
        response["status"] = "Error"
        response["message"] = "Cannot find given url"
      end
      render :json => response
    end

    private

      def set_default_format
        request.format = :json
      end

      def get_url
        @shortend_url = ShortUrl.find_by_shortend_url(params["short_url"])
      end
end
