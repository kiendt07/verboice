require 'spec_helper'

describe ContactsController do
  include Devise::TestHelpers

  before(:each) do
    @account = Account.make
    sign_in @account
  end
  let!(:contact) { Contact.make }


  describe "GET index" do
    it "assigns all contacts as @contacts" do
      get :index, {}
      assigns(:contacts).should eq([contact])
    end
  end

  describe "GET show" do
    it "assigns the requested contact as @contact" do
      get :show, {:id => contact.to_param}
      assigns(:contact).should eq(contact)
    end
  end

  describe "GET new" do
    it "assigns a new contact as @contact" do
      get :new, {}
      assigns(:contact).should be_a_new(Contact)
    end
  end

  describe "GET edit" do
    it "assigns the requested contact as @contact" do
      get :edit, {:id => contact.to_param}
      assigns(:contact).should eq(contact)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Contact" do
        expect {
          post :create, {:contact => Contact.plan}
        }.to change(Contact, :count).by(1)
      end

      it "assigns a newly created contact as @contact" do
        post :create, {:contact => Contact.plan}
        assigns(:contact).should be_a(Contact)
        assigns(:contact).should be_persisted
      end

      it "redirects to the created contact" do
        post :create, {:contact => Contact.plan}
        response.should redirect_to(Contact.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contact as @contact" do
        Contact.any_instance.stub(:save).and_return(false)
        post :create, {:contact => {}}
        assigns(:contact).should be_a_new(Contact)
      end

      it "re-renders the 'new' template" do
        Contact.any_instance.stub(:save).and_return(false)
        post :create, {:contact => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested contact" do
        Contact.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => contact.to_param, :contact => {'these' => 'params'}}
      end

      it "assigns the requested contact as @contact" do
        put :update, {:id => contact.to_param, :contact => Contact.plan}
        assigns(:contact).should eq(contact)
      end

      it "redirects to the contact" do
        put :update, {:id => contact.to_param, :contact => Contact.plan}
        response.should redirect_to(contact)
      end
    end

    describe "with invalid params" do
      it "assigns the contact as @contact" do
        Contact.any_instance.stub(:save).and_return(false)
        put :update, {:id => contact.to_param, :contact => {}}
        assigns(:contact).should eq(contact)
      end

      it "re-renders the 'edit' template" do
        Contact.any_instance.stub(:save).and_return(false)
        put :update, {:id => contact.to_param, :contact => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contact" do
      expect {
        delete :destroy, {:id => contact.to_param}
      }.to change(Contact, :count).by(-1)
    end

    it "redirects to the contacts list" do
      delete :destroy, {:id => contact.to_param}
      response.should redirect_to(contacts_url)
    end
  end

end