require 'elasticsearch/model'
class Snapuser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :Snapgroups
  has_many :Snapprojects
  has_and_belongs_to_many :taught_classes, :class_name => "Snapclass", join_table: 'class_teachers'
  has_and_belongs_to_many :enrolled_classes, :class_name => "Snapclass", join_table: 'class_students'
  has_and_belongs_to_many :snapprojects, join_table: 'user_projects'
  has_many :Snapclasses
  has_many :snapcomments

  def all_classes
  	classes = self.taught_classes + self.enrolled_classes
  end
  
end

#   settings index: { number_of_shards: 1 } do
#     mappings dynamic: 'false' do
#       indexes :username, analyzer: 'english'
#     end
#   end
# end

# # Delete the previous Snapusers index in Elasticsearch
# Snapuser.__elasticsearch__.client.indices.delete index: Snapuser.index_name rescue nil
 
# # Create the new index with the new mapping
# Snapuser.__elasticsearch__.client.indices.create \
#   index: Snapuser.index_name,
#   body: { settings: Snapuser.settings.to_hash, mappings: Snapuser.mappings.to_hash }
 
# Index all Snapuser records from the DB to Elasticsearch
Snapuser.import