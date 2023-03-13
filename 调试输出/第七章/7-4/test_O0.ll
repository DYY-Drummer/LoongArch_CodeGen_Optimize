; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "E-m:m-p:32:32-i8:8:32-i16:16:32-i64:64-n32-S64"
target triple = "mips-unknown-linux-gnu"

@g1 = dso_local global i32 1, align 4
@g2 = dso_local global i32 2, align 4
@g3 = dso_local global i32 100, align 4
@g4 = dso_local global i32 50, align 4

; Function Attrs: noinline nounwind optnone
define dso_local i32 @test_select() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 1, i32* %1, align 4
  store i32 0, i32* %2, align 4
  %3 = load i32, i32* %1, align 4
  %4 = icmp ne i32 %3, 0
  %5 = xor i1 %4, true
  %6 = zext i1 %5 to i64
  %7 = select i1 %5, i32 1, i32 2
  store i32 %7, i32* %2, align 4
  %8 = load i32, i32* %2, align 4
  ret i32 %8
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @test_select_global() #0 {
  %1 = alloca i32, align 4
  %2 = load i32, i32* @g1, align 4
  %3 = load i32, i32* @g2, align 4
  %4 = icmp slt i32 %2, %3
  br i1 %4, label %5, label %7

5:                                                ; preds = %0
  %6 = load i32, i32* @g3, align 4
  store i32 %6, i32* %1, align 4
  br label %9

7:                                                ; preds = %0
  %8 = load i32, i32* @g4, align 4
  store i32 %8, i32* %1, align 4
  br label %9

9:                                                ; preds = %7, %5
  %10 = load i32, i32* %1, align 4
  ret i32 %10
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
