class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  has_many :addresses
  has_many :orders

  def full_name
    "#{first_name} #{last_name}"
  end
  
  after_create do
    UserMailer.welcome_email(self).deliver_now
    customer = Stripe::Customer.create(email: email, name: full_name)
    update(stripe_customer_id: customer.id)
  end

  after_update do
    Stripe::Customer.update(stripe_customer_id, {email: email, name: full_name})
  end
      
end
