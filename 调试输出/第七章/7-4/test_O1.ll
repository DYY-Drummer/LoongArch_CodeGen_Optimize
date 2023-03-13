; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "E-m:m-p:32:32-i8:8:32-i16:16:32-i64:64-n32-S64"
target triple = "mips-unknown-linux-gnu"

@g1 = dso_local local_unnamed_addr global i32 1, align 4
@g2 = dso_local local_unnamed_addr global i32 2, align 4
@g3 = dso_local local_unnamed_addr global i32 100, align 4
@g4 = dso_local local_unnamed_addr global i32 50, align 4

; Function Attrs: norecurse nounwind readnone
define dso_local i32 @test_select() local_unnamed_addr #0 {
  ret i32 2
}

; Function Attrs: norecurse nounwind readonly
define dso_local i32 @test_select_global() local_unnamed_addr #1 {
  %1 = load i32, i32* @g1, align 4, !tbaa !2
  %2 = load i32, i32* @g2, align 4, !tbaa !2
  %3 = icmp slt i32 %1, %2
  %4 = load i32, i32* @g3, align 4
  %5 = load i32, i32* @g4, align 4
  %6 = select i1 %3, i32 %4, i32 %5
  ret i32 %6
}

attributes #0 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
