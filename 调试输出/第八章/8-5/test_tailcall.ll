; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "E-m:m-p:32:32-i8:8:32-i16:16:32-i64:64-n32-S64"
target triple = "mips-unknown-linux-gnu"

; Function Attrs: nounwind
define dso_local i32 @func_b(i32 signext %0) local_unnamed_addr #0 {
  %2 = add nsw i32 %0, 1
  %3 = add nsw i32 %0, -1
  %4 = tail call i32 bitcast (i32 (...)* @flop to i32 (i32)*)(i32 signext %3) #2
  %5 = mul nsw i32 %4, %2
  ret i32 %5
}

declare dso_local i32 @flop(...) local_unnamed_addr #1

; Function Attrs: nounwind
define dso_local i32 @func_a(i32 signext %0) local_unnamed_addr #0 {
  %2 = add nsw i32 %0, -1
  %3 = tail call i32 bitcast (i32 (...)* @flip to i32 (i32)*)(i32 signext %2) #2
  %4 = mul nsw i32 %3, %0
  ret i32 %4
}

declare dso_local i32 @flip(...) local_unnamed_addr #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
