module TasksHelper
  def today_is_monday?
    Date.today.wday == 1
  end

  def friday_date(monday = Date.today)
    (monday - 3.days).strftime '%Y/%m/%d'
  end

  def group_tasks_by_description(tasks)
    {}.tap do |a|
      tasks.each do |task|
        a[task.description] ||= []
        a[task.description] << task
      end
    end
  end
end
