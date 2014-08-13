class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :email, type: String
  validates_presence_of :name
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })

  # enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    if User.count == 0
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
      end
    end
  end

end
