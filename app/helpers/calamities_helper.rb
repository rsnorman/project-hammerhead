module CalamitiesHelper
  def attendee_status(status)
    case status
    when 'pending'
      'Waiting for response'
    when 'accepted'
      'Going'
    when 'declined'
      'Not going'
    when 'unsure'
      'Maybe'
    else
      'Unknown'
    end
  end
end
