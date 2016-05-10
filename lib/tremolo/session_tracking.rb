module Tremolo
  module SessionTracking
    def tracker(key=:default)
      Tremolo.fetch(key)
    end

    # load or set new uuid in session
    def tremolo_client_id
      session['tremolo.client_id'] ||= Tremolo::Rails.build_client_id
    end

    def append_info_to_payload(payload)
      super

      payload["tremolo.tracker"] = tracker
      payload["tremolo.client_id"] = tremolo_client_id
    end
  end
end
