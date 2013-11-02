require 'spec_helper'

describe TopicsController do

  context "#index" do
    let(:args1) { title:"Title 1", content:"content 1" }
    let(:story) {Story.create(args1)}
    let(:args2) { title:"Title 2", content:"content 2" }
    let(:story) {Story.create(args2)}
    let(:args3) { title:"Title 3", content:"content 3" }
    let(:story) {Story.create(args3)}

    it "visits the index page"
      get :index
      response.status.should eq(200)
    end
    # it "lists all records" do
    #   get :index
    #   expect(response.status).to render_template("show")
    # end
  end


  

  it  "#new" do
    get :new
    response.status.should eq(200)
  end

  context "#create" do
    it "creates a topic with valid params" do
      expect {
        post :create, topic: {title: "Meat", content: "It is what is for food"}
        }.to change { Topic.count }.by(1)
      expect(Topic.last.content).to eq('It is what is for food')
    end
    it "doesn't create a topic with invalid params" do
      expect {
      post :create, topic: {title: "Wrong"}
      }.to_not change { Topic.count }
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
      expect(page).to have_content(story.title)
    end
  end


  context "#edit" do
    before :each do
      @user = User.create(username: "raaaaaaa", password: "passwerd")
      @topic = Topic.create(title: "hello", content: "this is content", user_id: @user.id)
    end
    it "go to edit page" do
      get :edit, id: @topic.id
      response.status.should eq(200)
      expect(response).to render_template("edit")
    end
    it "updates topic" do
      put :update, id: @topic.id, topic: {title: "NOT HELLO", content: "THIS IS CONTENT"}
      expect(Topic.find(@topic.id).title).to eq("NOT HELLO")
    end
  end

  context "#destroy" do
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
