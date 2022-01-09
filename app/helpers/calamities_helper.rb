module CalamitiesHelper
  def attendee_status(status)
    case status
    when 'pending'
      'Waiting for response'
    else
      'Unknown'
    end
  end
end
