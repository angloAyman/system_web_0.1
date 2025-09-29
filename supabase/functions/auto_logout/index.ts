import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

const AUTO_LOGOUT_MINUTES = 10;

Deno.serve(async (req) => {
  const now = new Date();

  // جلب جميع سجلات الدخول التي ليس لها logout_time ومضى عليها أكثر من 10 دقائق
  const { data, error } = await supabase
    .from("logins")
    .select("*")
    .is("logout_time", null);

  if (error) {
    console.error("خطأ أثناء جلب البيانات:", error);
    return new Response("Error fetching data", { status: 500 });
  }

  const expiredLogins = data.filter((login: any) => {
    const loginTime = new Date(login.login_time);
    const diffMinutes = (now.getTime() - loginTime.getTime()) / (1000 * 60);
    return diffMinutes > AUTO_LOGOUT_MINUTES;
  });

  // تحديث كل سجل منتهي الصلاحية بـ logout_time
  for (const login of expiredLogins) {
    await supabase
      .from("logins")
      .update({ logout_time: now.toISOString() })
      .eq("id", login.id);
  }

  return new Response(
    `✅ تم تحديث ${expiredLogins.length} سجل بسبب انتهاء الجلسة`,
    { status: 200 }
  );
});
