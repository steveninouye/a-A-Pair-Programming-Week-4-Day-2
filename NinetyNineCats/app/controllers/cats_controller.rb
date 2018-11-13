class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find_by(id: params[:id])
    render :show
  end

  def create

  end

  def update

  end

  def destroy

  end

  def edit

  end

  def new

  end
end
