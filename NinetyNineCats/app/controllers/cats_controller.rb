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
    @cat = Cat.find_by(id: params[:id])
    render :edit
  end

  def new
    @cat = Cat.new
    render :new
  end
end
