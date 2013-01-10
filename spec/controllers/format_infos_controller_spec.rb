require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe FormatInfosController do

  # This should return the minimal set of attributes required to create a valid
  # FormatInfo. As you add validations to FormatInfo, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FormatInfosController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all format_infos as @format_infos" do
      format_info = FormatInfo.create! valid_attributes
      get :index, {}, valid_session
      assigns(:format_infos).should eq([format_info])
    end
  end

  describe "GET show" do
    it "assigns the requested format_info as @format_info" do
      format_info = FormatInfo.create! valid_attributes
      get :show, {:id => format_info.to_param}, valid_session
      assigns(:format_info).should eq(format_info)
    end
  end

  describe "GET new" do
    it "assigns a new format_info as @format_info" do
      get :new, {}, valid_session
      assigns(:format_info).should be_a_new(FormatInfo)
    end
  end

  describe "GET edit" do
    it "assigns the requested format_info as @format_info" do
      format_info = FormatInfo.create! valid_attributes
      get :edit, {:id => format_info.to_param}, valid_session
      assigns(:format_info).should eq(format_info)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FormatInfo" do
        expect {
          post :create, {:format_info => valid_attributes}, valid_session
        }.to change(FormatInfo, :count).by(1)
      end

      it "assigns a newly created format_info as @format_info" do
        post :create, {:format_info => valid_attributes}, valid_session
        assigns(:format_info).should be_a(FormatInfo)
        assigns(:format_info).should be_persisted
      end

      it "redirects to the created format_info" do
        post :create, {:format_info => valid_attributes}, valid_session
        response.should redirect_to(FormatInfo.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved format_info as @format_info" do
        # Trigger the behavior that occurs when invalid params are submitted
        FormatInfo.any_instance.stub(:save).and_return(false)
        post :create, {:format_info => {}}, valid_session
        assigns(:format_info).should be_a_new(FormatInfo)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FormatInfo.any_instance.stub(:save).and_return(false)
        post :create, {:format_info => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested format_info" do
        format_info = FormatInfo.create! valid_attributes
        # Assuming there are no other format_infos in the database, this
        # specifies that the FormatInfo created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FormatInfo.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => format_info.to_param, :format_info => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested format_info as @format_info" do
        format_info = FormatInfo.create! valid_attributes
        put :update, {:id => format_info.to_param, :format_info => valid_attributes}, valid_session
        assigns(:format_info).should eq(format_info)
      end

      it "redirects to the format_info" do
        format_info = FormatInfo.create! valid_attributes
        put :update, {:id => format_info.to_param, :format_info => valid_attributes}, valid_session
        response.should redirect_to(format_info)
      end
    end

    describe "with invalid params" do
      it "assigns the format_info as @format_info" do
        format_info = FormatInfo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FormatInfo.any_instance.stub(:save).and_return(false)
        put :update, {:id => format_info.to_param, :format_info => {}}, valid_session
        assigns(:format_info).should eq(format_info)
      end

      it "re-renders the 'edit' template" do
        format_info = FormatInfo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FormatInfo.any_instance.stub(:save).and_return(false)
        put :update, {:id => format_info.to_param, :format_info => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested format_info" do
      format_info = FormatInfo.create! valid_attributes
      expect {
        delete :destroy, {:id => format_info.to_param}, valid_session
      }.to change(FormatInfo, :count).by(-1)
    end

    it "redirects to the format_infos list" do
      format_info = FormatInfo.create! valid_attributes
      delete :destroy, {:id => format_info.to_param}, valid_session
      response.should redirect_to(format_infos_url)
    end
  end

end