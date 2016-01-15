require_relative '../../lib/controller_base'
require_relative '../models/cat'

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      flash[:notice] = "Saved cat successfully"
      redirect_to :index
    else
      flash.now[:errors] = @cat.errors
      render :new
    end
  end

  def show
    @cat = Cat.find(params["id"])
    render :show
  end
end
