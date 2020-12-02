class Food < ApplicationRecord
  belongs_to :user
  acts_as_taggable_on :tags

# add a callback method so that the shelf life is set based on the tag
end
