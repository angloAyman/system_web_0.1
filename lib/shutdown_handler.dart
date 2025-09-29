// import 'dart:ffi';
// import 'dart:io';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:ffi/ffi.dart';
// import 'package:system/main.dart';
// import 'package:win32/win32.dart';
// import 'package:window_manager/window_manager.dart';
//
//
//
//
//
//
//
//
// typedef WindowProcC = Int32 Function(IntPtr hwnd, Uint32 msg, IntPtr wParam, IntPtr lParam);
// typedef WindowProcDart = int Function(int hwnd, int msg, int wParam, int lParam);
//
// late Pointer<NativeFunction<WindowProcC>> originalWndProcPtr;
// late Future<void> Function() _onShutdownHandler;
//
// void registerShutdownListener(Future<void> Function() onShutdown) {
//   _onShutdownHandler = onShutdown;
//
//   final hWnd = GetConsoleWindow();
//   if (hWnd == 0) {
//     print("No console window found.");
//     return;
//   }
//
//   originalWndProcPtr = Pointer.fromAddress(GetWindowLongPtr(hWnd, GWL_WNDPROC));
//   final wndProc = Pointer.fromFunction<WindowProcC>(_windowProc, 0);
//   SetWindowLongPtr(hWnd, GWL_WNDPROC, wndProc.address);
//
//   print("Windows shutdown & sleep listener registered!");
// }
//
// int _windowProc(int hwnd, int msg, int wParam, int lParam) {
//   // Handle system shutdown
//   if (msg == WM_QUERYENDSESSION) {
//     print("System is shutting down...");
//
//     _onShutdownHandler().catchError((e) {
//       print("Error during shutdown handler: $e");
//     });
//
//     return 1;
//   }
//
//   // Handle sleep
//   if (msg == WM_POWERBROADCAST) {
//     if (wParam == PBT_APMSUSPEND) {
//       print("System is going to sleep...");
//
//       _onShutdownHandler().catchError((e) {
//         print("Error during sleep handler: $e");
//       });
//
//       return 1;
//     }
//   }
//
//   return CallWindowProc(originalWndProcPtr.cast(), hwnd, msg, wParam, lParam);
// }
// // " befor pc Restart or shedown  make "
// void onWindowClose() async {
//   final user = supabase.auth.currentUser;
//   if (user != null) {
//     // 1. الحصول على الوقت الحالي وتحويله للمحلي
//     final now = DateTime.now().toLocal();
//
//     // 2. تنسيق الوقت المحلي كـ String
//     final logoutTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//
//     // 3. إرسال الوقت إلى Supabase
//     await supabase
//         .from('logins')
//         .update({'logout_time': logoutTime})
//         .eq('user_id', user.id);
//   }
//
//   await windowManager.destroy();
// }