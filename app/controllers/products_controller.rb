class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy ]
  before_action :require_admin_user, only: [:new, :edit, :update, :destroy]

  # GET /products or /products.json
  def index
    if params[:show_all].to_i == 1 && admin_user?
      @products = Product.all
    else
      @products = Product.where(available: true)
    end
  end

  # GET /products/1 or /products/1.json
  def show
    if admin_user?
      set_product
    else
      @product = Product.find_by(id: params[:id], available: true)
      if !@product.present?
        redirect_to products_path
      end
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :picture, :thumbnail, 
                      :price, :stock, :available, :length, :width, :height, :weight)
    end
end
