class EmailResponsesController < ApplicationController
  before_action :set_team
  before_action :set_email_response, only: %i[ show destroy ]

  # GET /email_responses or /email_responses.json
  def index
    @email_responses = EmailResponse.all
  end

  # GET /email_responses/1 or /email_responses/1.json
  def show
  end

  # POST /email_responses or /email_responses.json
  def create
    @create_email_response_command = Commands::CreateEmailResponse.new(email_response_params)
    @email_response_create_event = @create_email_response_command.execute

    respond_to do |format|
      if @email_response_create_event.valid?
        format.html { redirect_to "/email_responses/#{@email_response_create_event.data[:email_response_id]}", notice: "Email Response was successfully created." }
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
    def set_team
      @team = Team.all.find { |team| team.name == 'Chinatown' }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_email_response
      @email_response = EmailResponse.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_response_params
      params.require(:email_response).permit(:name)
    end
end
