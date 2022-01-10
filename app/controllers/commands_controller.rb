class CommandsController < ApplicationController
  # GET /commands/new
  def new
    @command = Command.new
  end

  # POST /email_responses or /email_responses.json
  def create
    @command = command.new(JSON.parse(command_params[:attributes]).symbolize_keys)
    @command_event = @command.execute

    respond_to do |format|
      if @command_event.valid?
        format.html { render :show, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    def command
      @command ||=
        case command_params[:name]
        when 'ProcessEmailResponse'
          Commands::ProcessEmailResponse
        else
          raise "Command not supported: #{command_params[:name]}"
        end
    end

    # Only allow a list of trusted parameters through.
    def command_params
      params.require(:command).permit(:name, :attributes)
    end
end