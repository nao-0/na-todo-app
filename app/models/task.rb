class Task < ApplicationRecord
  has_one_attached :eyecatch
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :board   
  belongs_to :user
  
  def display_created_at
    I18n.l(self.created_at, format: :default)
  end

  def auther_name
    user.display_name
  end
  
end
