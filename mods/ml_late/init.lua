-- Old worlds may already have taken the ship while wave is still 2.
-- Those saves would be stuck, because the hall step now waits for wave 4.

if ml.storage:get_int("phaeacians") == 1
	and ml.storage:get_int("wave") == 2
	and ml.storage:get_int("ithaca") ~= 1
	and ml.start_last_wave then
	ml.start_last_wave()
end
