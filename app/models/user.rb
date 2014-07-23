class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :firstname, :lastname, :phone, :image, :is_admin

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  field :image,       type: String
  field :phone,       type: Integer
  field :firstname,   type: String
  field :lastname,    type: String

  # Role admin
  field :is_admin,    type: Boolean, :default => false

  has_many :authentications, :dependent => :delete_all

  
  ##
  # => Date: July 23,2014
  # => Method create user and authentication from auth
  ##
  def apply_omniauth(auth)
    # Assign value to new user
    self.email = auth['extra']['raw_info']['email']  
    self.password = Devise.friendly_token[0,20]
    
    # Create authentication get from api token
    authentications.build(
      :provider => auth['provider'],
      :uid => auth['uid'],
      :token => auth['credentials']['token'],
      :token_secret => auth['credentials']['token_secret']
      )
  end
end
