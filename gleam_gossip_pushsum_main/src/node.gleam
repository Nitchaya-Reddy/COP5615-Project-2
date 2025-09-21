import gleam/erlang/process.{type Subject, send, new_subject}

pub type ParticipantMessage {
  ConfigureAdjacency(List(Subject(ParticipantMessage)))
  RumorNotification
  AggregationData(Float, Float)
  StatusInquiry(Subject(ParticipantStatusResponse))
  ShutdownParticipant
}

pub type ParticipantStatusResponse {
  ParticipantStatus(Int, Float, Float, Bool)  // rumor_reception_count, sum_value, weight_value, shutdown_flag
}

pub type ParticipantState {
  ParticipantState(
    identifier: Int,
    adjacent_participants: List(Subject(ParticipantMessage)),
    rumor_reception_count: Int,
    sum_value: Float,
    weight_value: Float,
    shutdown_flag: Bool,
    historical_ratios: List(Float)  // For aggregation convergence detection
  )
}

pub fn initialize_participant(_identifier: Int) -> Subject(ParticipantMessage) {
  // Create node communication channel
  // TODO: Implement complete actor behavior when OTP API becomes available
  new_subject()
}


// Communication functions for node interaction
pub fn transmit_rumor(node: Subject(ParticipantMessage)) -> Nil {
  send(node, RumorNotification)
}

pub fn transmit_aggregation_data(node: Subject(ParticipantMessage), sum_val: Float, weight_val: Float) -> Nil {
  send(node, AggregationData(sum_val, weight_val))
}

pub fn establish_adjacency(node: Subject(ParticipantMessage), adjacent_list: List(Subject(ParticipantMessage))) -> Nil {
  send(node, ConfigureAdjacency(adjacent_list))
}

pub fn request_participant_status(node: Subject(ParticipantMessage), response_channel: Subject(ParticipantStatusResponse)) -> Nil {
  send(node, StatusInquiry(response_channel))
}

pub fn shutdown_participant(node: Subject(ParticipantMessage)) -> Nil {
  send(node, ShutdownParticipant)
}
