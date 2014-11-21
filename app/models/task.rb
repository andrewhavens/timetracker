class Task < ActiveRecord::Base
  belongs_to :client
  attr_accessible :client_id, :description, :start, :end

  validates_presence_of :client, :description

  scope :yesterday, -> {
    where(start: (Date.yesterday.to_time...Date.today.to_time)).order(:start)
  }
  
  scope :today, -> {
    where(start: (Date.today.to_time...Date.tomorrow.to_time)).order(:start)
  }

  scope :on_day, lambda {|day|
    where(start: (day.to_time...day.end_of_day.to_time)).order(:start)
  }

  def hours
    (self.end - self.start) / 3600
  end
end
