class EventFilter

  attr_accessor :event

  ACTIONS = %w{ ConfbridgeJoin BridgeLeave DTMFBegin ConfbridgeUnmute ConfbridgeMute }

  def initialize(event)
    self.event = event
  end

  def transfer?
    ACTIONS.include?(event.name)
  end

end