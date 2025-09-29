// import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
//
// const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
// const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
// const supabase = createClient(supabaseUrl, supabaseKey, { auth: { persistSession: false } });
//
// export default async function handler(req: Request): Promise<Response> {
//   try {
//     // Find all active sessions where the user has been logged in for 10+ minutes
//     const { data, error } = await supabase
//       .from("logins")
//       .select("id, login_time")
//       .is("logout_time", null) // Only get active sessions
//       .lt("login_time", new Date(Date.now() - 10 * 60 * 1000).toISOString()); // 10 minutes ago
//
//     if (error) throw error;
//
//     // If no users to log out, return early
//     if (!data || data.length === 0) {
//       return new Response("No users to log out.", { status: 200 });
//     }
//
//     // Update `logout_time` for these users
//     for (const session of data) {
//       await supabase
//         .from("logins")
//         .update({ logout_time: new Date().toISOString() })
//         .eq("id", session.id);
//     }
//
//     return new Response(`Logged out ${data.length} users.`, { status: 200 });
//   } catch (err) {
//     return new Response(`Error: ${err.message}`, { status: 500 });
//   }
// }

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
// Supabase client with service role key
const supabase = createClient(Deno.env.get("SUPABASE_URL"), Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"));
const AUTO_LOGOUT_MINUTES = 10;
const SECRET_TOKEN = Deno.env.get("SECRET_TOKEN"); // من المتغيرات البيئية
Deno.serve(async (req)=>{
  const url = new URL(req.url);
  // ✅ محاولة الحصول على التوكن من query أو من الهيدر
  const tokenFromQuery = url.searchParams.get("token");
  const tokenFromHeader = req.headers.get("authorization")?.replace("Bearer ", "");
  // ✅ التحقق من صحة التوكن
  if (tokenFromQuery !== SECRET_TOKEN && tokenFromHeader !== SECRET_TOKEN) {
    return new Response("Unauthorized", {
      status: 401
    });
  }
  const now = new Date();
  // ✅ جلب السجلات التي لا تحتوي على logout_time
  const { data, error } = await supabase.from("logins").select("id, login_time").is("logout_time", null);
  if (error) {
    console.error("❌ خطأ أثناء جلب البيانات:", error.message);
    return new Response("Error fetching data", {
      status: 500
    });
  }
  const expiredLogins = data.filter((login)=>{
    const loginTime = new Date(login.login_time);
    const diffMinutes = (now.getTime() - loginTime.getTime()) / (1000 * 60);
    return diffMinutes > AUTO_LOGOUT_MINUTES;
  });
  // ✅ تحديث السجلات المنتهية
  const updates = expiredLogins.map((login)=>supabase.from("logins").update({
      logout_time: now.toISOString()
    }).eq("id", login.id));
  const results = await Promise.all(updates);
  const failedUpdates = results.filter((r)=>r.error);
  if (failedUpdates.length > 0) {
    console.error("⚠️ تحديثات فاشلة:", failedUpdates.map((r)=>r.error.message));
  }
  return new Response(`✅ تم تحديث ${expiredLogins.length - failedUpdates.length} سجل (فشل ${failedUpdates.length})`, {
    status: 200
  });
});
