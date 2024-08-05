# create Post model
generate :model, "Post title:string body:text published:boolean user:references"

# migrate
rails_command "db:migrate"

# create route resources with onlt index and show
route "resources :posts, only: [:index, :show]"

# create controller
generate :controller, "Posts index show"

# insert code to controller
insert_into_file "app/controllers/posts_controller.rb", after: "class PostsController < ApplicationController\n" do
  <<-'RUBY'
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
  RUBY
end

#insert into view
create_file "app/views/posts/index.html.erb" do
  <<-HTML
  <h1>Posts</h1>
  <div class="grid grid-cols-1 gap-4 lg:grid-cols-3 lg:gap-8">
    <% @posts.each do |post| %>
      <div class="card">
        <%= link_to post.title, post_path(post) %>
      </div>
    <% end %>
  </div>
  HTML
end

