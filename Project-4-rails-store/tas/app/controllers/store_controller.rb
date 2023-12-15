class StoreController < ApplicationController
  skip_before_action :authorize
  include CurrentCart
  before_action :set_cart

  def index
    @products = Product.order(:title)
  end

  def contact
  end

  def search
    @products = nil
    if params[:search].blank?
      redirect_to(root_path, alert: "Empty field!") and return
    else
      @products = Product.where("title LIKE ?", "%#{params[:search]}%").order(:title)
      render :index
    end
  end

  def product
    @product = Product.find(params[:id])
  end
end
