class ShortUrl < ApplicationRecord
    validates :original_url, :presence=> true
    

    def self.search(search)
        if search
            self.where("original_url LIKE ? OR shortend_url LIKE ?", "%#{search}%", "%#{search}%")
        else
           self.all
        end
    end
end
