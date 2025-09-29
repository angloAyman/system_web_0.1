// supabase/functions/logout_user/index.ts
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  const supabaseClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  try {
    const { user_id } = await req.json();

    // الحصول على آخر جلسة دخول
    const { data: logins, error: selectError } = await supabaseClient
      .from("logins")
      .select("id")
      .eq("user_id", user_id)
      .order("login_time", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (selectError) throw selectError;
    if (!logins) return new Response("No session found", { status: 404 });

    // تحديث وقت الخروج
    const { error: updateError } = await supabaseClient
      .from("logins")
      .update({ logout_time: new Date().toISOString() })
      .eq("id", logins.id);

    if (updateError) throw updateError;

    return new Response("Logout time updated ✅", { status: 200 });
  } catch (err) {
    console.error("❌ Error:", err);
    return new Response("Server Error", { status: 500 });
  }
});
