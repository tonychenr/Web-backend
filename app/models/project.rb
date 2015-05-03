class Project < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  has_and_belongs_to_many :users, join_table: 'user_projects'
  has_many :comments
  validates :name, presence: true
  after_update :remove_users

  def all_users
    # Input: Project (self)
    # Output: String of the usernames for all owners of the project

    accounts = []
    self.users.each { |user| accounts += [user.username] }
    accounts.join(", ").to_str
  end

  def remove_users
    # Input: Project (self)
    # Output: nil, Removes all users from the project

    self.users.each { |user| self.users.delete(user) }
  end

  def add_users(users)
    # Input: Array of users to be added to the project
    # Output: nil, Adds all users from the project

    users.each { |user| self.users << user }
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
    end
  end
  
end

# Delete the previous Projects index in Elasticsearch
Project.__elasticsearch__.client.indices.delete index: Project.index_name rescue nil
 
# Create the new index with the new mapping
Project.__elasticsearch__.client.indices.create \
  index: Project.index_name,
  body: { settings: Project.settings.to_hash, mappings: Project.mappings.to_hash }
 
# Index all Project records from the DB to Elasticsearch
Project.import
