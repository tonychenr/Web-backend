class Snapproject < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_and_belongs_to_many :snapusers, join_table: 'user_projects'
  has_many :snapcomments
  validates :name, presence: true

  def all_users
    string = ""
    self.snapusers.each do |user|
      string += "#{user.username} "
    end
    string
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
    end
  end
  
end

# Delete the previous Snapusers index in Elasticsearch
Snapproject.__elasticsearch__.client.indices.delete index: Snapproject.index_name rescue nil
 
# Create the new index with the new mapping
Snapproject.__elasticsearch__.client.indices.create \
  index: Snapproject.index_name,
  body: { settings: Snapproject.settings.to_hash, mappings: Snapproject.mappings.to_hash }
 
# Index all Snapuser records from the DB to Elasticsearch
Snapproject.import
