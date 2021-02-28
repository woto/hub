Yabeda.configure do
  group :hub do
    counter :categories_errors, comment: "Errors in categories", tags: %i[feed_id message]
    gauge :delete_old_offers, comment: "Number of deleted old offers", tags: %i[feed_id]
    # gauge     :whistles_active,  comment: "Number of whistles ready to whistle"
    # histogram :whistle_runtime, buckets: [0.01, 0.5, 60, 300, 3600] do
    #   comment "How long whistles are being active"
    #   unit :seconds
    # end
  end
end

Yabeda.configure!
