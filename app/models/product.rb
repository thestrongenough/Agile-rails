class Product < ActiveRecord::Base
  validates :title, :description, :image_url, presence: :true
  validates :price, numericality: {greater_than_or_equal: 0.01}
  validates :image_url, allow_blank: :true, format: {with: %r{\.(gif|jpg|png)\Z}i, message: 'must be a url for gif,png or jpg'}
  
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  
  def self.latest
    Product.order(:updated_at).last
  end
  private
  
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items Present')
      return false
    end
  end
end
