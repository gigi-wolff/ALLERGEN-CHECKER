class AllergensController < ApplicationController
  # Use before_action to set up an instance variable for an action, 
  # in this case, call set_allergen before calling edit or destroy
  before_action :set_allergen, only: [:edit, :destroy]
  # Use after_action to check all products in db for allergens if a new
  # allergen has been created or an existing allergen has been updated
  after_action :check_all_products_for_allergens, only: [:create, :update]

# run 'rails routes' then add '_path' to the Prefix to get the url

#       Prefix Verb   URI Pattern                   Controller#Action
#---------------------------------------------------------------------
#    allergens GET    /allergens(.:format)          allergens#index
#              POST   /allergens(.:format)          allergens#create
# new_allergen GET    /allergens/new(.:format)      allergens#new
#edit_allergen GET    /allergens/:id/edit(.:format) allergens#edit
#     allergen GET    /allergens/:id(.:format)      allergens#show
#              PATCH  /allergens/:id(.:format)      allergens#update
#              PUT    /allergens/:id(.:format)      allergens#update
#              DELETE /allergens/:id(.:format)      allergens#destroy
#         root GET    /                             allergens#index

# GET '/'
  def index
    # Allergens.all accesses model layer and stores result in an instance variable
    # which is passed to the view
    @allergens = Allergen.all
    # render 'allergens/index' happens by default at end of method
  end

  # GET '/allergens/new'
  def new
    # set up a new instance variable which is an active record object
    # and pass it to the 'new' template in "new.html.erb" 
    @allergen = Allergen.new
    # render 'allergens/new' happens by default at end of method
  end

  # GET '/allergens/:id/edit'
  def edit # url will be something like /allergens/"Formaldehyde"/edit, edit form will be rendered
    # @allergen = Allergen.find_by category: params[:id]... this is now done by set_allergen
    # render 'allergens/edit by default
  end

  # POST '/allergens'
  # the general pattern used in the action create that handles
  # submission of model-backed forms 
  def create 
    # the form displayed in "new.html.erb" is submitted to action='/allergens' 
    # using verb method="post" which is routed to allergens#create.
    # @allergen, is populated with values (params) submitted from the form
    @allergen = Allergen.new(allergen_params)

    if @allergen.save #returns "false" if it can't save
      flash[:success] = "Allergen was successfully created"
      # redirect must be a url, can't render a view template
      # (add '_path' to the prefix to get the url)
      redirect_to allergen_path(@allergen) # index
    else
      # validation error occured. We must render to have access to 
      # "allergens.error.full_messages" array to display generated errors 
      render 'new'
    end
  end

  # PATCH '/allergens/:id'
  #the general pattern used in the action create that handles
  #submission of model-backed forms 
  def update # this is where the form displayed in 'edit' is submitted using verb "patch"
    @allergen = Allergen.find(params[:id])
    if @allergen.update(allergen_params)
      flash[:success] = "Allergen was successfully updated"
      redirect_to allergen_path(@allergen)
    else
      render 'edit'
    end
  end

  # GET '/allergens/:id'
  def show
    #already have @allergen at this point because 'set_allergen' was invoked
    #render 'allergens/index' 
    @allergens = Allergen.all
    render 'index'
  end

  # DELETE '/allergens/:id'
  def destroy
    # already have @allergen at this point because 'set_allergen' was invoked
    @allergen.destroy
    flash[:success] = "Allergen was successfully deleted"
    redirect_to allergens_path # show.html.erb
  end

  private

  def set_allergen
    # ask ActiveRecord to find the Allergen object in the db using the :category from params
    # @allergen = Allergen.find(params[:id])
    @allergen = Allergen.find_by category: params[:id]
  end

  def allergen_params
    # use strong parameters to expose the fields we're interested in
    # require top level key be allergen and allow changes to category, substances
    params.require(:allergen).permit(:category, :substances)
    # To permit all attributes params.require(:post).permit!
  end

  def check_all_products_for_allergens
    Product.pluck(:id).each do |product_id| 
      check_for_allergens(product_id)
    end 
  end

end