require 'spec_helper'

describe "something" do
  it "does something" do
  end
end

describe "something" do
  context "in one context" do
    it "does one thing" do
    end
  end
  context "in another context" do
    it "does another thing" do
    end
  end
end

describe TopicsController do

  describe "#index" do
    let(:args1) { title:"Title 1", content:"content 1" }
    let(:story) {Story.create(args1)}

    it "visits the index page"
      get :index
      expect(assigns(:posts)).to eq(Post.all)
      response.status.should eq(200)
      expect(response.status).to eq(200)
    end
  end

  describe "#new" do
    it 'visits the new page'
      get :new
      response.status.should eq(200)
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context 'when using valid params' do
      it "creates a topic" do
        expect {
          post :create, topic: {title: "Meat", content: "It is what is for food"}
          }.to change { Topic.count }.by(1)
        expect(Topic.last.content).to eq('It is what is for food')
        expect(response).to redirect_to(root_path)
      end
    end
    context 'when using invalid params' do
      it "doesn't create a topic" do
        expect {
        post :create, topic: {title: "Wrong"}
        }.to_not change { Topic.count }
        expect(response).to render_template(:new)
      end
    end
    it "creates a topic with a user" do
      user = User.create(username: "joseph", password: "securea")
      session[:user_id] = user.id
      post :create, topic: {title: "Ryan", content: "The best"}
      expect(Topic.first.user_id).to eq(1)
    end
  end

  describe "#show" do
    it "visits the show page" do
      get :show, id: story.id
      response.status.should eq(200)
      expect(response).to render_template(:show)
      expect(page).to have_content(story.title)
    end
  end

  describe "#edit" do
    before :each do
      @user = User.create(username: "raaaaaaa", password: "passwerd")
      @topic = Topic.create(title: "hello", content: "this is content", user_id: @user.id)
    end
    it "visits the edit page" do
      get :edit, id: @topic.id
      response.status.should eq(200)
      expect(response).to render_template("edit")
    end
  end
  describe "#update" do
    before :each do
      @user = User.create(username: "raaaaaaa", password: "passwerd")
      @topic = Topic.create(title: "hello", content: "this is content", user_id: @user.id)
    end
    it "updates topic" do
      put :update, id: @topic.id, topic: {title: "NOT HELLO", content: "THIS IS CONTENT"}
      expect(Topic.find(@topic.id).title).to eq("NOT HELLO")
      expect(response).to redirect_to(topics_path)
    end
  end

  describe "#update" do
    let!(:new_post) { Post.create({:title => "old title", :content => "old content"})}

    it "updates a post with valid params" do
      expect {
        put :update, :id => new_post.id, post: {:title => "new title"}
      }.to change {Post.last.title}.to eq("New Title")
    end
    it "doesn't update a post when params are invalid" do
      expect {
        put :update, :id => new_post.id, post: {}
      }.to_not change {Post.last.title}.to eq("Old Title")
    end
  end

  describe "#destroy" do
    before :each do
      @user = User.create(username: "raaaaaaa", password: "passwerd")
      @topic = Topic.create(title: "hello", content: "this is content", user_id: @user.id)
    end
    it "deletes the topic" do
      expect {
      delete :destroy, id: @topic.id
      }.to change { Topic.count }.by(-1)
    end
  end
end

describe UsersController, "on GET to show with a valid id" do
  before(:each) do
    get :show, :id => User.first.to_param
  end


  it { should assign_to(:user) }
  it { should_not assign_to(:user) }
  it { should assign_to(:user).with_kind_of(User) }
  it { should assign_to(:user).with(@user) }

  it { should assign_to(:user) }
  it { should respond_with(:success) }
  it { should render_template(:show) }
  it { should not_set_the_flash) }

  it "should do something else really cool" do
    assigns[:user].id.should == 1
  end

  it { should redirect_to('http://somewhere.com')  }
  it { should redirect_to(users_path)  }

  it { should render_template(:partial => '_customer')  }

  it { should respond_with_content_type(/json/) }

  it { should set_session(:user_id).to(@user.id) }

end

describe Note do
  it { should belong_to(:talk) }
  it { should belong_to(:author) }

  describe "#author_name" do
    context "when no author is for the Note" do
      its(:author_name) { should eql "" }
    end

    context "when there is an author for the note" do
      let(:user) { User.new(random_user_attributes) }
      subject(:note) { Note.new(author: user) }
      its(:author_name) { should eql user.name }
    end
  end
end

describe "#suggest_talk" do
  it "Adds the passed in talk to the users talks" do
    user = User.create(random_user_attributes)
    talk = user.suggest_talk(random_talk_attributes)
    expect(user.suggested_talks).to include talk
  end
end