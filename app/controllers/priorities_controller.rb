class PrioritiesController < ApplicationController

  respond_to :html, :json

  def create
    @priority = Priority.new(params[:priority])
    if @priority.save
      respond_with(@priority, :status => :created, :location => root_path)
    else
      respond_with(@priority.errors, :status => :unprocessable_entity)
    end
  end

  def update
    @priority = Priority.find(params[:id])
    if @priority.update_attributes(params[:priority])
      respond_with(@priority)
    else
      respond_with(@priority.errors, :status => :unprocessable_entity)
    end
  end

  def order
    ids = params[:priorities]
    positions = ids.each_with_index.map{|id, index| {position: index} }
    Priority.update(ids, positions)
    render nothing: true, status: :ok
  end

  def destroy
    @priority = Priority.find(params[:id])
    @priority.destroy
    respond_with(nil, status: :no_content, :location => root_path)
  end

end
