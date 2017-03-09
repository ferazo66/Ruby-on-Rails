class Article < ApplicationRecord

  include AASM

  belongs_to :user
  has_many :comments
  has_many :has_categories
  has_many :categories, through: :has_categories
  attr_reader :categories
  validates :title, presence: true, uniqueness: true
  validates :body, presence: true, length: {minimum: 20}
  before_save :set_visits_count
  after_create :save_categories

  has_attached_file :cover, style:{medium:"1280x720",thumb:"400x200"}, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/

  #scope para parametros / pueden ser encadenables
  #scope :publicados, ->{where(state: "published")}

  def categories=(value)
    @categories=value
  end
  def update_visits_count
    self.save if self.visits_count.nil?
    self.update(visits_count: self.visits_count + 1)
  end
  aasm_column :state
  aasm do
    state :in_draft,:initial=> true
    state :published

    event :publish do
      transitions :form=> :in_draft, :to=> :published
    end
    event :unpublish do
      transitions :form=> :published, :to=> :in_draft
    end
  end

  private
  def set_visits_count
    self.visits_count ||= 0
  end
  def save_categories
    @categories.each do |category_id|
      HasCategory.create(category_id: category_id,article_id: self.id)
    end
  end
end
