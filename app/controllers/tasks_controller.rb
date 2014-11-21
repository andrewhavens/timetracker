class TasksController < ApplicationController

  def index
    @tasks_today = Task.today
    @today_clients = Client.includes(:tasks).merge(Task.today).order(:name)
    @hours_today = @tasks_today.collect(&:hours).sum
    @hours_remaining = 8 - @hours_today
    @priorities = Priority.order(:position)
  end

  def today
    @date_title = 'Today'
    @tasks = Task.today
    @tasks_with_clients = Client.includes(:tasks).merge(@tasks).order(:name)
    render :summary
  end

  def yesterday
    @date = Date.yesterday
    @date_title = "Yesterday (#{@date.strftime('%B %e')})"
    @tasks = Task.yesterday
    @tasks_with_clients = Client.includes(:tasks).merge(@tasks).order(:name)
    render :summary
  end

  def specific_day
    @date = Time.zone.parse "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    if @date == Date.today.to_time
      return redirect_to root_path
    end
    @date_title = @date.strftime('%A, %B %e, %Y')
    @tasks = Task.on_day(@date)
    @tasks_with_clients = Client.includes(:tasks).merge(@tasks).order(:name)
    render :summary
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    @task.start = params[:start] if params[:start]
    @task.end = params[:end] if params[:end]
    @return_to = request.env["HTTP_REFERER"]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @return_to = request.env["HTTP_REFERER"]
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to (params[:return_to] || @task), notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to (params[:return_to] || @task), notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to (request.env["HTTP_REFERER"] || tasks_url) }
      format.json { head :no_content }
    end
  end
end
