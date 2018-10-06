class ShortUrlsController < ApplicationController
    
    def index
      flash.clear
      @short_url = ShortUrl.new
    end
    
    def show
      
      @urls = ShortUrl.search(params[:search])
    end
    
    def create
        
        url = params[:short_url][:original_url]
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
            @short_url.shortend_url = @shortend_url = small_url(random_string)
          else
            @shortend_url = @short_url.shortend_url
          end
          if @short_url.valid?
            @short_url.save
            respond_to do |format|
              format.html {
                render :result
              }
            end
          else
            flash["danger"] = "Something went wrong"
          end
        else
          @short_url = ShortUrl.new
          flash["danger"] = "Given url should not be blank and should be a valid url"
          page_render
        end
    
    end
    
      def original_redirect
        random_string = params[:random]
        short_url = ShortUrl.find_by_random_string("#{random_string}")
        if short_url
          url = short_url.original_url
          respond_to do |format|
            format.html { redirect_to(url)}
            format.js {}
          end
        else
          @error = "Please create a short url first"
          respond_to do |format|
            format.html {
              render :result
            }
          end
        end
      end

      private

      def page_render
        respond_to do |format|
          format.html {
            render :index
          }
      end
    end

      def short_url_params
        params.require(:short_url).permit(:search)
      end
end
