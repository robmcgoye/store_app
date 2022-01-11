class ContactsController < ApplicationController
  before_action :load_page, only: [:new, :create]

  def new
    @contact = Contact.new
  end

  def create
    begin
      @contact = Contact.new(contact_params)
      @contact.request = request
      if @contact.deliver
        flash[:notice] = 'Thank you for your message!'
        redirect_to new_contact_path
      else
        render :new
      end
    rescue ScriptError
      flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def contact_params
      params.require(:contact).permit(:name, :email, :file, :message, :nickname)
    end

    def load_page
      @page = Page.find_by_name(:contact)
    end

end
