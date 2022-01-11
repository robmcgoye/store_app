class PagesController < ApplicationController
  before_action :set_page, only: [:edit, :update]
  before_action :require_admin_user, only: [:edit, :update]
 
  def home
    @page = load_page(:home)
  end

  def about
    @page = load_page(:about)
  end
 
  def edit
  end

  def update
    if @page.update(page_params)
      if  @page.name == "contact"
        flash[:notice] = "The page was successfully updated."
        redirect_to new_contact_path
      else
        flash.now[:notice] = "The page was successfully updated."
        render @page.name
      end 
    else
      render 'edit'
    end 
  end
  
  private

  def load_page(page_name)
    Page.find_by_name(page_name)
  end

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :body)
  end

end
