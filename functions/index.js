const functions = require("firebase-functions");
const { createClient } = require("@supabase/supabase-js");

// Initialize Supabase Client
    const supabaseUrl = 'https://mianifmvhtxtqxxhhwpr.supabase.co';-->
    const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxODY2MTAsImV4cCI6MjA0Nzc2MjYxMH0.blrfnraxP9t7EXztwnYsEp_TzJGD_sr__cZI-ymDDdc';
const supabase = createClient(supabaseUrl, supabaseKey);

exports.confirmAttendance = functions.https.onRequest(async (req, res) => {
  const { user_id, shift_id_status } = req.query;

  if (!user_id || !shift_id_status) {
    return res.status(400).send({ error: "Missing user_id or shift_id_status" });
  }

  try {
    // Insert data into Supabase
    const { data, error } = await supabase
      .from("attendance1")
      .insert([{ user_id, shift_id_status }]);

    if (error) {
      throw error;
    }

    res.status(200).send({ message: "Attendance confirmed!", data });
  } catch (error) {
    console.error("Error confirming attendance:", error);
    res.status(500).send({ error: error.message });
  }
});
