class CreateShortUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :short_urls do |t|
      t.text :original_url
      t.string :host
      t.string :path
      t.string :random_string
      t.string :shortend_url

      t.timestamps
    end
  end
end
