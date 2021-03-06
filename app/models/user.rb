  class User < ActiveRecord::Base
  enum role: [:pollee, :owner, :admin]
  after_initialize :set_default_role, :if => :new_record?
  
  has_many :rooms
  has_many :polls
  has_many :answers, through: :polls

  def set_default_role
    self.role ||= :pollee
  end

  def answered?(question)
    return polls.any? {|poll| poll.question == question}
  end

  def choose(answer)
    poll = Poll.new 
    self.polls << poll 
    poll.question = answer.question
    poll.answer = answer 
    poll.save!
    self.save
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
