class <%= class_name %>Controller < InheritedResources::Base

  <% if actions.include?("index") %>
    def index
      respond_to do |format|
        format.html
      end
    end

  <% end -%>
  <% if actions.include?("show") %>
    def show
      respond_to do |format|
        format.html
      end
    end

  <% end -%>
  <% if actions.include?("new") %>
    def new
      @<%= object_singular_name %> = <%= model_name %>.new()
    end

  <% end -%>

  def create
    create! do |success, failure|
      success.html {
        flash[:notice] = "<%= object_singular_name.humanize %> created successfully!"
        redirect_to <%= namespace_prefix %><%= object_plural_name %>_path }
      failure.html { render :new }
    end
  end

  <% if actions.include?("edit")%>
    def edit
      respond_to do |format|
        format.html
      end
    end

  <% end -%>

    def update
      update! do |success, failure|
            success.html {
              flash[:notice] = "<%= object_singular_name.humanize %> saved!"
              redirect_to <%= namespace_prefix %><%= object_plural_name %>_path
            }
          end
    end

  <% if actions.include?("destroy") %>
    def destroy
      @<%= object_singular_name %>.destroy
      respond_to do |format|
        format.html {redirect_to <%= namespace_prefix %><%= object_plural_name %>_path}
      end
    end
  <% end -%>

protected
def collection
  @search = <%= model_name %>.searchlogic(params[:search])
  @<%= object_plural_name %> = @search.all.paginate :page => params[:page], :per_page => 20
end

end