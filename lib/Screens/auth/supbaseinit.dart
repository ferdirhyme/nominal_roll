// import 'package:supabase/supabase.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = SupabaseClient(
  'https://ecwmnvmovjrqmrcvawwo.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjd21udm1vdmpycW1yY3Zhd3dvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkxOTEwNjksImV4cCI6MjAxNDc2NzA2OX0.5YKlbFhpZjePsnOXRI3BjVwZHrqfCLSglPt5MHSG-Nc',
);

// class supabaseHandler {

//   addData(data, table) async {
//     var response = await supabase.from(table).insert({data});
//     return response;
//   }
// }
