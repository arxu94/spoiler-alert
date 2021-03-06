class Food < ApplicationRecord
  belongs_to :user
  acts_as_taggable_on :tags
# add a callback method so that the shelf life is set based on the tag
  before_commit :set_expiring_date
  # "Meat", "Seafood", "Dairy", "Fruits", "Veggies", "Condiments", "Eggs", "Others"]

  # private

  def set_expiring_date
    # p "-------------------"
    # p date = ((self.purchase_date+11) - Date.today).to_i
    # p "-------------------"
    if self.tag_list == ["Fruits"]
      self.update!(expire_date: (self.purchase_date + 6))
    elsif self.tag_list == ["Meat"]
      self.update!(expire_date: (self.purchase_date + 3))
    elsif self.tag_list == ["Seafood"]
      self.update!(expire_date: (self.purchase_date + 3))
    elsif self.tag_list == ["Veggies"]
      self.update!(expire_date: (self.purchase_date + 4))
    elsif self.tag_list == ["Dairy"]
      self.update!(expire_date: (self.purchase_date + 5))
    elsif self.tag_list == ["Condiments"]
      self.update!(expire_date: (self.purchase_date + 10))
    elsif self.tag_list == ["Eggs"]
      self.update!(expire_date: (self.purchase_date + 14))
    end
  end
  # def set_shelf_life
  # OUR DREAM
  # end
end
