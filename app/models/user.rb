class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    #:recoverable,
    #:rememberable,
    #:trackable,
    #:validatable
  )

  has_many :power_assignments, dependent: :destroy
  has_many :games, through: :power_assignments

  # devise attributes
  attr_accessible :email, :password, :password_confirmation#, :remember_me
  attr_accessible :name
end
