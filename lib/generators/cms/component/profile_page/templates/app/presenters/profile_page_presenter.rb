class ProfilePagePresenter
  include ActiveAttr::Model

  attr_reader :user

  attribute :id
  attribute :gender
  attribute :first_name
  attribute :last_name
  attribute :email
  attribute :language
  attribute :want_email

  validates :id, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def initialize(user, attributes)
    @user = user
    attributes ||= user.fetch.attributes

    super(attributes)
  end

  def save
    if valid?
      user.fetch.update_attributes(attributes)
    end
  end
end