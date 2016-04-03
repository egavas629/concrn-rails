require 'spec_helper'

describe ClientsController do
  before do
    sign_in create(:user, role: 'dispatcher')
  end

  let(:valid_attributes) { { "name" => "MyString" } }

  describe "GET index" do
    it "assigns all active clients as @clients" do
      active_client = create(:client, active: true)
      create(:client, active: false)
      get :index, {}
      assigns(:clients).should eq([active_client])
    end
  end

  describe "GET deactivated" do
    it "assigns all deactivated clients as @clients" do
      inactive_client = create(:client, active: false)
      create(:client, active: true)
      get :deactivated, {}
      assigns(:clients).should eq([inactive_client])
    end
  end

  describe "GET show" do
    it "assigns the requested client as @client" do
      client = create(:client)
      get :show, {:id => client.to_param}
      assigns(:client).should eq(client)
    end
  end

  describe "GET new" do
    it "assigns a new client as @client" do
      get :new, {}
      assigns(:client).should be_a_new(Client)
    end
  end

  describe "GET edit" do
    it "assigns the requested client as @client" do
      client = create(:client)
      get :edit, {:id => client.to_param}
      assigns(:client).should eq(client)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Client" do
        expect {
          post :create, {:client => valid_attributes}
        }.to change(Client, :count).by(1)
      end

      it "assigns a newly created client as @client" do
        post :create, {:client => valid_attributes}
        assigns(:client).should be_a(Client)
        assigns(:client).should be_persisted
      end

      it "redirects to the created client" do
        post :create, {:client => valid_attributes}
        response.should redirect_to(Client.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved client as @client" do
        # Trigger the behavior that occurs when invalid params are submitted
        Client.any_instance.stub(:save).and_return(false)
        post :create, {:client => { "name" => "invalid value" }}
        assigns(:client).should be_a_new(Client)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Client.any_instance.stub(:save).and_return(false)
        post :create, {:client => { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested client" do
        client = create(:client)
        Client.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => client.to_param, :client => { "name" => "MyString" }}
      end

      it "assigns the requested client as @client" do
        client = create(:client)
        put :update, {:id => client.to_param, :client => valid_attributes}
        assigns(:client).should eq(client)
      end

      it "redirects to the client" do
        client = create(:client)
        put :update, {:id => client.to_param, :client => valid_attributes}
        response.should redirect_to(client)
      end
    end

    describe "with invalid params" do
      it "assigns the client as @client" do
        client = create(:client)
        # Trigger the behavior that occurs when invalid params are submitted
        Client.any_instance.stub(:save).and_return(false)
        put :update, {:id => client.to_param, :client => { "name" => "invalid value" }}
        assigns(:client).should eq(client)
      end

      it "re-renders the 'edit' template" do
        client = create(:client)
        # Trigger the behavior that occurs when invalid params are submitted
        Client.any_instance.stub(:save).and_return(false)
        put :update, {:id => client.to_param, :client => { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end
end
