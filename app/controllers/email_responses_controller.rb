class EmailResponsesController < ApplicationController
  before_action :set_calamity
  before_action :set_email_response, only: %i[ show destroy ]
  protect_from_forgery with: :null_session

  # GET /email_responses or /email_responses.json
  def index
    @email_responses = EmailResponse.all
  end

  # GET /email_responses/1 or /email_responses/1.json
  def show
  end

  # POST /email_responses or /email_responses.json
  def create
    @create_email_response_command = Commands::CreateEmailResponse.new(email_response_params.merge(calamity_id: @calamity.id))
    @email_response_create_event = @create_email_response_command.execute

    respond_to do |format|
      if @email_response_create_event.valid?
        @email_response = EmailResponse.find(@email_response_create_event.data[:email_response_id])

        format.html { render :show, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_responses/1 or /email_responses/1.json
  def destroy
    @destroy_email_response_command = Commands::DestroyEmailResponse.new(email_response: @email_response)
    @email_response_destroy_event = @destroy_email_response_command.execute

    respond_to do |format|
      format.html { redirect_to email_responses_url, notice: "Email Response was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calamity
      @calamity = Calamity.all.find { |team| team.name == 'Chinatown vs Shake \'n\' Bake' }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_email_response
      @email_response = EmailResponse.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_response_params
      params.permit!
    end
end
