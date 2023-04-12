; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "E-m:m-p:32:32-i8:8:32-i16:16:32-i64:64-n32-S64"
target triple = "mips-32-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i32, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i32, i32, [40 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.Random_struct = type { [17 x i32], i32, i32, i32, i32, double, double, double }
%struct.Stopwatch_struct = type { i32, double, double }

@history = dso_local global [2 x [56 x i32]] [[56 x i32] [i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 0, i32 1, i32 2, i32 4, i32 2, i32 1, i32 0, i32 -1, i32 1, i32 3, i32 5, i32 7, i32 5, i32 3, i32 1, i32 -1, i32 2, i32 5, i32 8, i32 10, i32 8, i32 5, i32 2, i32 -1, i32 2, i32 5, i32 8, i32 10, i32 8, i32 5, i32 2, i32 -1, i32 1, i32 3, i32 5, i32 7, i32 5, i32 3, i32 1, i32 -1, i32 0, i32 1, i32 2, i32 4, i32 2, i32 1, i32 0], [56 x i32] [i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 0, i32 1, i32 2, i32 4, i32 2, i32 1, i32 0, i32 -1, i32 1, i32 3, i32 5, i32 7, i32 5, i32 3, i32 1, i32 -1, i32 2, i32 5, i32 8, i32 10, i32 8, i32 5, i32 2, i32 -1, i32 2, i32 5, i32 8, i32 10, i32 8, i32 5, i32 2, i32 -1, i32 1, i32 3, i32 5, i32 7, i32 5, i32 3, i32 1, i32 -1, i32 0, i32 1, i32 2, i32 4, i32 2, i32 1, i32 0]], align 4
@nodes = common dso_local global i64 0, align 8
@msecs = common dso_local global i64 0, align 8
@plycnt = external dso_local global i32, align 4
@height = external dso_local global [0 x i32], align 4
@columns = external dso_local global [0 x i32], align 4
@colthr = external dso_local global [0 x i32], align 4
@.str.1 = private unnamed_addr constant [9 x i8] c"##-<=>+#\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"%c%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"Fhourstones 2.0\00", align 1
@.str.3 = private unnamed_addr constant [54 x i8] c"Using %d transposition table entries with %d probes.\0A\00", align 1
@.str.4 = private unnamed_addr constant [31 x i8] c"Solving %d-ply position after \00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c" . . .\00", align 1
@.str.6 = private unnamed_addr constant [28 x i8] c"score = %d (%c)  work = %d\0A\00", align 1
@.str.7 = private unnamed_addr constant [36 x i8] c"%lu pos / %lu msec = %.1f Kpos/sec\0A\00", align 1
@.str.8 = private unnamed_addr constant [43 x i8] c"FFT: Data length is not a power of 2!: %d \00", align 1
@dm1 = internal global double 0.000000e+00, align 8
@RESOLUTION_DEFAULT = dso_local constant double 2.000000e+00, align 8
@RANDOM_SEED = dso_local constant i32 101010, align 4
@FFT_SIZE = dso_local constant i32 1024, align 4
@SOR_SIZE = dso_local constant i32 100, align 4
@SPARSE_SIZE_M = dso_local constant i32 1000, align 4
@SPARSE_SIZE_nz = dso_local constant i32 5000, align 4
@LU_SIZE = dso_local constant i32 100, align 4
@LG_FFT_SIZE = dso_local constant i32 1048576, align 4
@LG_SOR_SIZE = dso_local constant i32 1000, align 4
@LG_SPARSE_SIZE_M = dso_local constant i32 100000, align 4
@LG_SPARSE_SIZE_nz = dso_local constant i32 1000000, align 4
@LG_LU_SIZE = dso_local constant i32 1000, align 4
@TINY_FFT_SIZE = dso_local constant i32 16, align 4
@TINY_SOR_SIZE = dso_local constant i32 10, align 4
@TINY_SPARSE_SIZE_M = dso_local constant i32 10, align 4
@TINY_SPARSE_SIZE_N = dso_local constant i32 10, align 4
@TINY_SPARSE_SIZE_nz = dso_local constant i32 50, align 4
@TINY_LU_SIZE = dso_local constant i32 10, align 4
@.str.27 = private unnamed_addr constant [6 x i8] c"-help\00", align 1
@.str.1.28 = private unnamed_addr constant [3 x i8] c"-h\00", align 1
@stderr = external dso_local global %struct._IO_FILE*, align 4
@.str.2.29 = private unnamed_addr constant [32 x i8] c"Usage: [-large] [minimum_time]\0A\00", align 1
@.str.3.30 = private unnamed_addr constant [7 x i8] c"-large\00", align 1
@.str.4.31 = private unnamed_addr constant [42 x i8] c"Using %10.2f seconds min time per kenel.\0A\00", align 1
@.str.5.32 = private unnamed_addr constant [60 x i8] c"NOTE!!! All Mflops disabled to prevent diffs from failing!\0A\00", align 1
@.str.6.33 = private unnamed_addr constant [31 x i8] c"Composite Score:        %8.2f\0A\00", align 1
@.str.7.34 = private unnamed_addr constant [41 x i8] c"FFT             Mflops: %8.2f    (N=%d)\0A\00", align 1
@.str.8.35 = private unnamed_addr constant [44 x i8] c"SOR             Mflops: %8.2f    (%d x %d)\0A\00", align 1
@.str.9 = private unnamed_addr constant [31 x i8] c"MonteCarlo:     Mflops: %8.2f\0A\00", align 1
@.str.10 = private unnamed_addr constant [48 x i8] c"Sparse matmult  Mflops: %8.2f    (N=%d, nz=%d)\0A\00", align 1
@.str.11 = private unnamed_addr constant [47 x i8] c"LU              Mflops: %8.2f    (M=%d, N=%d)\0A\00", align 1
@.str.12 = private unnamed_addr constant [68 x i8] c"**                                                              **\0A\00", align 1
@.str.13 = private unnamed_addr constant [68 x i8] c"** SciMark2 Numeric Benchmark, see http://math.nist.gov/scimark **\0A\00", align 1
@.str.14 = private unnamed_addr constant [68 x i8] c"** for details. (Results can be submitted to pozo@nist.gov)     **\0A\00", align 1
@seconds.t = internal global double 0.000000e+00, align 8
@ht = common dso_local global i32* null, align 4
@he = common dso_local global i8* null, align 4
@hits = common dso_local global i64 0, align 8
@posed = common dso_local global i64 0, align 8
@lock = common dso_local global i32 0, align 4
@htindex = common dso_local global i32 0, align 4
@stride = common dso_local global i32 0, align 4
@.str.58 = private unnamed_addr constant [30 x i8] c"Failed to allocate %u bytes.\0A\00", align 1
@.str.1.69 = private unnamed_addr constant [19 x i8] c"store rate = %.3f\0A\00", align 1
@.str.2.70 = private unnamed_addr constant [45 x i8] c"- %5.3f  < %5.3f  = %5.3f  > %5.3f  + %5.3f\0A\00", align 1
@.str.3.71 = private unnamed_addr constant [6 x i8] c"%7d%c\00", align 1

; Function Attrs: noinline nounwind optnone
define dso_local double** @new_Array2D_double(i32 signext %0, i32 signext %1) #0 {
  %3 = alloca double**, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca double**, align 4
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 0, i32* %6, align 4
  store i32 0, i32* %7, align 4
  %9 = load i32, i32* %4, align 4
  %10 = mul i32 4, %9
  %11 = call noalias i8* @malloc(i32 signext %10) #7
  %12 = bitcast i8* %11 to double**
  store double** %12, double*** %8, align 4
  %13 = load double**, double*** %8, align 4
  %14 = icmp eq double** %13, null
  br i1 %14, label %15, label %16

15:                                               ; preds = %2
  store double** null, double*** %3, align 4
  br label %62

16:                                               ; preds = %2
  store i32 0, i32* %6, align 4
  br label %17

17:                                               ; preds = %36, %16
  %18 = load i32, i32* %6, align 4
  %19 = load i32, i32* %4, align 4
  %20 = icmp slt i32 %18, %19
  br i1 %20, label %21, label %39

21:                                               ; preds = %17
  %22 = load i32, i32* %5, align 4
  %23 = mul i32 %22, 8
  %24 = call noalias i8* @malloc(i32 signext %23) #7
  %25 = bitcast i8* %24 to double*
  %26 = load double**, double*** %8, align 4
  %27 = load i32, i32* %6, align 4
  %28 = getelementptr inbounds double*, double** %26, i32 %27
  store double* %25, double** %28, align 4
  %29 = load double**, double*** %8, align 4
  %30 = load i32, i32* %6, align 4
  %31 = getelementptr inbounds double*, double** %29, i32 %30
  %32 = load double*, double** %31, align 4
  %33 = icmp eq double* %32, null
  br i1 %33, label %34, label %35

34:                                               ; preds = %21
  store i32 1, i32* %7, align 4
  br label %39

35:                                               ; preds = %21
  br label %36

36:                                               ; preds = %35
  %37 = load i32, i32* %6, align 4
  %38 = add nsw i32 %37, 1
  store i32 %38, i32* %6, align 4
  br label %17

39:                                               ; preds = %34, %17
  %40 = load i32, i32* %7, align 4
  %41 = icmp ne i32 %40, 0
  br i1 %41, label %42, label %60

42:                                               ; preds = %39
  %43 = load i32, i32* %6, align 4
  %44 = add nsw i32 %43, -1
  store i32 %44, i32* %6, align 4
  br label %45

45:                                               ; preds = %54, %42
  %46 = load i32, i32* %6, align 4
  %47 = icmp sle i32 %46, 0
  br i1 %47, label %48, label %57

48:                                               ; preds = %45
  %49 = load double**, double*** %8, align 4
  %50 = load i32, i32* %6, align 4
  %51 = getelementptr inbounds double*, double** %49, i32 %50
  %52 = load double*, double** %51, align 4
  %53 = bitcast double* %52 to i8*
  call void @free(i8* %53) #7
  br label %54

54:                                               ; preds = %48
  %55 = load i32, i32* %6, align 4
  %56 = add nsw i32 %55, -1
  store i32 %56, i32* %6, align 4
  br label %45

57:                                               ; preds = %45
  %58 = load double**, double*** %8, align 4
  %59 = bitcast double** %58 to i8*
  call void @free(i8* %59) #7
  store double** null, double*** %3, align 4
  br label %62

60:                                               ; preds = %39
  %61 = load double**, double*** %8, align 4
  store double** %61, double*** %3, align 4
  br label %62

62:                                               ; preds = %60, %57, %15
  %63 = load double**, double*** %3, align 4
  ret double** %63
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i32 signext) #1

; Function Attrs: nounwind
declare dso_local void @free(i8*) #1

; Function Attrs: noinline nounwind optnone
define dso_local void @Array2D_double_delete(i32 signext %0, i32 signext %1, double** %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca double**, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store double** %2, double*** %6, align 4
  %8 = load double**, double*** %6, align 4
  %9 = icmp eq double** %8, null
  br i1 %9, label %10, label %11

10:                                               ; preds = %3
  br label %28

11:                                               ; preds = %3
  store i32 0, i32* %7, align 4
  br label %12

12:                                               ; preds = %22, %11
  %13 = load i32, i32* %7, align 4
  %14 = load i32, i32* %4, align 4
  %15 = icmp slt i32 %13, %14
  br i1 %15, label %16, label %25

16:                                               ; preds = %12
  %17 = load double**, double*** %6, align 4
  %18 = load i32, i32* %7, align 4
  %19 = getelementptr inbounds double*, double** %17, i32 %18
  %20 = load double*, double** %19, align 4
  %21 = bitcast double* %20 to i8*
  call void @free(i8* %21) #7
  br label %22

22:                                               ; preds = %16
  %23 = load i32, i32* %7, align 4
  %24 = add nsw i32 %23, 1
  store i32 %24, i32* %7, align 4
  br label %12

25:                                               ; preds = %12
  %26 = load double**, double*** %6, align 4
  %27 = bitcast double** %26 to i8*
  call void @free(i8* %27) #7
  br label %28

28:                                               ; preds = %25, %10
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @Array2D_double_copy(i32 signext %0, i32 signext %1, double** %2, double** %3) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca double**, align 4
  %8 = alloca double**, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca double*, align 4
  %13 = alloca double*, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store double** %2, double*** %7, align 4
  store double** %3, double*** %8, align 4
  %14 = load i32, i32* %6, align 4
  %15 = and i32 %14, 3
  store i32 %15, i32* %9, align 4
  store i32 0, i32* %10, align 4
  store i32 0, i32* %11, align 4
  store i32 0, i32* %10, align 4
  br label %16

16:                                               ; preds = %89, %4
  %17 = load i32, i32* %10, align 4
  %18 = load i32, i32* %5, align 4
  %19 = icmp slt i32 %17, %18
  br i1 %19, label %20, label %92

20:                                               ; preds = %16
  %21 = load double**, double*** %7, align 4
  %22 = load i32, i32* %10, align 4
  %23 = getelementptr inbounds double*, double** %21, i32 %22
  %24 = load double*, double** %23, align 4
  store double* %24, double** %12, align 4
  %25 = load double**, double*** %8, align 4
  %26 = load i32, i32* %10, align 4
  %27 = getelementptr inbounds double*, double** %25, i32 %26
  %28 = load double*, double** %27, align 4
  store double* %28, double** %13, align 4
  store i32 0, i32* %11, align 4
  br label %29

29:                                               ; preds = %41, %20
  %30 = load i32, i32* %11, align 4
  %31 = load i32, i32* %9, align 4
  %32 = icmp slt i32 %30, %31
  br i1 %32, label %33, label %44

33:                                               ; preds = %29
  %34 = load double*, double** %13, align 4
  %35 = load i32, i32* %11, align 4
  %36 = getelementptr inbounds double, double* %34, i32 %35
  %37 = load double, double* %36, align 8
  %38 = load double*, double** %12, align 4
  %39 = load i32, i32* %11, align 4
  %40 = getelementptr inbounds double, double* %38, i32 %39
  store double %37, double* %40, align 8
  br label %41

41:                                               ; preds = %33
  %42 = load i32, i32* %11, align 4
  %43 = add nsw i32 %42, 1
  store i32 %43, i32* %11, align 4
  br label %29

44:                                               ; preds = %29
  %45 = load i32, i32* %9, align 4
  store i32 %45, i32* %11, align 4
  br label %46

46:                                               ; preds = %85, %44
  %47 = load i32, i32* %11, align 4
  %48 = load i32, i32* %6, align 4
  %49 = icmp slt i32 %47, %48
  br i1 %49, label %50, label %88

50:                                               ; preds = %46
  %51 = load double*, double** %13, align 4
  %52 = load i32, i32* %11, align 4
  %53 = getelementptr inbounds double, double* %51, i32 %52
  %54 = load double, double* %53, align 8
  %55 = load double*, double** %12, align 4
  %56 = load i32, i32* %11, align 4
  %57 = getelementptr inbounds double, double* %55, i32 %56
  store double %54, double* %57, align 8
  %58 = load double*, double** %13, align 4
  %59 = load i32, i32* %11, align 4
  %60 = add nsw i32 %59, 1
  %61 = getelementptr inbounds double, double* %58, i32 %60
  %62 = load double, double* %61, align 8
  %63 = load double*, double** %12, align 4
  %64 = load i32, i32* %11, align 4
  %65 = add nsw i32 %64, 1
  %66 = getelementptr inbounds double, double* %63, i32 %65
  store double %62, double* %66, align 8
  %67 = load double*, double** %13, align 4
  %68 = load i32, i32* %11, align 4
  %69 = add nsw i32 %68, 2
  %70 = getelementptr inbounds double, double* %67, i32 %69
  %71 = load double, double* %70, align 8
  %72 = load double*, double** %12, align 4
  %73 = load i32, i32* %11, align 4
  %74 = add nsw i32 %73, 2
  %75 = getelementptr inbounds double, double* %72, i32 %74
  store double %71, double* %75, align 8
  %76 = load double*, double** %13, align 4
  %77 = load i32, i32* %11, align 4
  %78 = add nsw i32 %77, 3
  %79 = getelementptr inbounds double, double* %76, i32 %78
  %80 = load double, double* %79, align 8
  %81 = load double*, double** %12, align 4
  %82 = load i32, i32* %11, align 4
  %83 = add nsw i32 %82, 3
  %84 = getelementptr inbounds double, double* %81, i32 %83
  store double %80, double* %84, align 8
  br label %85

85:                                               ; preds = %50
  %86 = load i32, i32* %11, align 4
  %87 = add nsw i32 %86, 4
  store i32 %87, i32* %11, align 4
  br label %46

88:                                               ; preds = %46
  br label %89

89:                                               ; preds = %88
  %90 = load i32, i32* %10, align 4
  %91 = add nsw i32 %90, 1
  store i32 %91, i32* %10, align 4
  br label %16

92:                                               ; preds = %16
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @c4_init() #0 {
  %1 = call i32 bitcast (void ()* @trans_init to i32 ()*)()
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @ab(i32 signext %0, i32 signext %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca [8 x i32], align 4
  %19 = alloca i64, align 8
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  %22 = load i64, i64* @nodes, align 8
  %23 = add nsw i64 %22, 1
  store i64 %23, i64* @nodes, align 8
  %24 = load i32, i32* @plycnt, align 4
  %25 = icmp eq i32 %24, 41
  br i1 %25, label %26, label %27

26:                                               ; preds = %2
  store i32 0, i32* %3, align 4
  br label %334

27:                                               ; preds = %2
  %28 = load i32, i32* @plycnt, align 4
  %29 = and i32 %28, 1
  store i32 %29, i32* %21, align 4
  %30 = xor i32 %29, 1
  store i32 %30, i32* %20, align 4
  store i32 0, i32* %17, align 4
  store i32 0, i32* %7, align 4
  br label %31

31:                                               ; preds = %110, %27
  %32 = load i32, i32* %7, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, i32* %7, align 4
  %34 = icmp sle i32 %33, 7
  br i1 %34, label %35, label %111

35:                                               ; preds = %31
  %36 = load i32, i32* %7, align 4
  %37 = getelementptr inbounds [0 x i32], [0 x i32]* @height, i32 0, i32 %36
  %38 = load i32, i32* %37, align 4
  store i32 %38, i32* %9, align 4
  %39 = icmp sle i32 %38, 6
  br i1 %39, label %40, label %110

40:                                               ; preds = %35
  %41 = load i32, i32* %7, align 4
  %42 = load i32, i32* %9, align 4
  %43 = call i32 bitcast (i32 (...)* @wins to i32 (i32, i32, i32)*)(i32 signext %41, i32 signext %42, i32 signext 3)
  %44 = icmp ne i32 %43, 0
  br i1 %44, label %52, label %45

45:                                               ; preds = %40
  %46 = load i32, i32* %7, align 4
  %47 = getelementptr inbounds [0 x i32], [0 x i32]* @columns, i32 0, i32 %46
  %48 = load i32, i32* %47, align 4
  %49 = getelementptr inbounds [0 x i32], [0 x i32]* @colthr, i32 0, i32 %48
  %50 = load i32, i32* %49, align 4
  %51 = icmp ne i32 %50, 0
  br i1 %51, label %52, label %92

52:                                               ; preds = %45, %40
  %53 = load i32, i32* %9, align 4
  %54 = add nsw i32 %53, 1
  %55 = icmp sle i32 %54, 6
  br i1 %55, label %56, label %65

56:                                               ; preds = %52
  %57 = load i32, i32* %7, align 4
  %58 = load i32, i32* %9, align 4
  %59 = add nsw i32 %58, 1
  %60 = load i32, i32* %21, align 4
  %61 = shl i32 1, %60
  %62 = call i32 bitcast (i32 (...)* @wins to i32 (i32, i32, i32)*)(i32 signext %57, i32 signext %59, i32 signext %61)
  %63 = icmp ne i32 %62, 0
  br i1 %63, label %64, label %65

64:                                               ; preds = %56
  store i32 -2, i32* %3, align 4
  br label %334

65:                                               ; preds = %56, %52
  %66 = load i32, i32* %7, align 4
  %67 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 0
  store i32 %66, i32* %67, align 4
  br label %68

68:                                               ; preds = %90, %65
  %69 = load i32, i32* %7, align 4
  %70 = add nsw i32 %69, 1
  store i32 %70, i32* %7, align 4
  %71 = icmp sle i32 %70, 7
  br i1 %71, label %72, label %91

72:                                               ; preds = %68
  %73 = load i32, i32* %7, align 4
  %74 = getelementptr inbounds [0 x i32], [0 x i32]* @height, i32 0, i32 %73
  %75 = load i32, i32* %74, align 4
  store i32 %75, i32* %9, align 4
  %76 = icmp sle i32 %75, 6
  br i1 %76, label %77, label %90

77:                                               ; preds = %72
  %78 = load i32, i32* %7, align 4
  %79 = load i32, i32* %9, align 4
  %80 = call i32 bitcast (i32 (...)* @wins to i32 (i32, i32, i32)*)(i32 signext %78, i32 signext %79, i32 signext 3)
  %81 = icmp ne i32 %80, 0
  br i1 %81, label %89, label %82

82:                                               ; preds = %77
  %83 = load i32, i32* %7, align 4
  %84 = getelementptr inbounds [0 x i32], [0 x i32]* @columns, i32 0, i32 %83
  %85 = load i32, i32* %84, align 4
  %86 = getelementptr inbounds [0 x i32], [0 x i32]* @colthr, i32 0, i32 %85
  %87 = load i32, i32* %86, align 4
  %88 = icmp ne i32 %87, 0
  br i1 %88, label %89, label %90

89:                                               ; preds = %82, %77
  store i32 -2, i32* %3, align 4
  br label %334

90:                                               ; preds = %82, %72
  br label %68

91:                                               ; preds = %68
  store i32 1, i32* %17, align 4
  br label %111

92:                                               ; preds = %45
  %93 = load i32, i32* %9, align 4
  %94 = add nsw i32 %93, 1
  %95 = icmp sle i32 %94, 6
  br i1 %95, label %96, label %104

96:                                               ; preds = %92
  %97 = load i32, i32* %7, align 4
  %98 = load i32, i32* %9, align 4
  %99 = add nsw i32 %98, 1
  %100 = load i32, i32* %21, align 4
  %101 = shl i32 1, %100
  %102 = call i32 bitcast (i32 (...)* @wins to i32 (i32, i32, i32)*)(i32 signext %97, i32 signext %99, i32 signext %101)
  %103 = icmp ne i32 %102, 0
  br i1 %103, label %109, label %104

104:                                              ; preds = %96, %92
  %105 = load i32, i32* %7, align 4
  %106 = load i32, i32* %17, align 4
  %107 = add nsw i32 %106, 1
  store i32 %107, i32* %17, align 4
  %108 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %106
  store i32 %105, i32* %108, align 4
  br label %109

109:                                              ; preds = %104, %96
  br label %110

110:                                              ; preds = %109, %35
  br label %31

111:                                              ; preds = %91, %31
  %112 = load i32, i32* %17, align 4
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %114, label %115

114:                                              ; preds = %111
  store i32 -2, i32* %3, align 4
  br label %334

115:                                              ; preds = %111
  %116 = load i32, i32* %17, align 4
  %117 = icmp eq i32 %116, 1
  br i1 %117, label %118, label %130

118:                                              ; preds = %115
  %119 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 0
  %120 = load i32, i32* %119, align 4
  %121 = call i32 bitcast (i32 (...)* @makemove to i32 (i32)*)(i32 signext %120)
  %122 = load i32, i32* %5, align 4
  %123 = sub nsw i32 0, %122
  %124 = load i32, i32* %4, align 4
  %125 = sub nsw i32 0, %124
  %126 = call i32 @ab(i32 signext %123, i32 signext %125)
  %127 = sub nsw i32 0, %126
  store i32 %127, i32* %13, align 4
  %128 = call i32 bitcast (i32 (...)* @backmove to i32 ()*)()
  %129 = load i32, i32* %13, align 4
  store i32 %129, i32* %3, align 4
  br label %334

130:                                              ; preds = %115
  %131 = call i32 @transpose()
  store i32 %131, i32* %14, align 4
  %132 = icmp ne i32 %131, -128
  br i1 %132, label %133, label %157

133:                                              ; preds = %130
  %134 = load i32, i32* %14, align 4
  %135 = ashr i32 %134, 5
  store i32 %135, i32* %13, align 4
  %136 = load i32, i32* %13, align 4
  %137 = icmp eq i32 %136, -1
  br i1 %137, label %138, label %144

138:                                              ; preds = %133
  store i32 0, i32* %5, align 4
  %139 = load i32, i32* %4, align 4
  %140 = icmp sle i32 0, %139
  br i1 %140, label %141, label %143

141:                                              ; preds = %138
  %142 = load i32, i32* %13, align 4
  store i32 %142, i32* %3, align 4
  br label %334

143:                                              ; preds = %138
  br label %156

144:                                              ; preds = %133
  %145 = load i32, i32* %13, align 4
  %146 = icmp eq i32 %145, 1
  br i1 %146, label %147, label %153

147:                                              ; preds = %144
  store i32 0, i32* %4, align 4
  %148 = load i32, i32* %5, align 4
  %149 = icmp sge i32 0, %148
  br i1 %149, label %150, label %152

150:                                              ; preds = %147
  %151 = load i32, i32* %13, align 4
  store i32 %151, i32* %3, align 4
  br label %334

152:                                              ; preds = %147
  br label %155

153:                                              ; preds = %144
  %154 = load i32, i32* %13, align 4
  store i32 %154, i32* %3, align 4
  br label %334

155:                                              ; preds = %152
  br label %156

156:                                              ; preds = %155, %143
  br label %157

157:                                              ; preds = %156, %130
  %158 = load i64, i64* @posed, align 8
  store i64 %158, i64* %19, align 8
  store i32 0, i32* %6, align 4
  store i32 0, i32* %11, align 4
  store i32 -999999, i32* %13, align 4
  store i32 0, i32* %7, align 4
  br label %159

159:                                              ; preds = %243, %157
  %160 = load i32, i32* %7, align 4
  %161 = load i32, i32* %17, align 4
  %162 = icmp slt i32 %160, %161
  br i1 %162, label %163, label %246

163:                                              ; preds = %159
  %164 = load i32, i32* %7, align 4
  store i32 %164, i32* %8, align 4
  store i32 -999999, i32* %12, align 4
  br label %165

165:                                              ; preds = %190, %163
  %166 = load i32, i32* %8, align 4
  %167 = load i32, i32* %17, align 4
  %168 = icmp slt i32 %166, %167
  br i1 %168, label %169, label %193

169:                                              ; preds = %165
  %170 = load i32, i32* %8, align 4
  %171 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %170
  %172 = load i32, i32* %171, align 4
  store i32 %172, i32* %10, align 4
  %173 = load i32, i32* %20, align 4
  %174 = getelementptr inbounds [2 x [56 x i32]], [2 x [56 x i32]]* @history, i32 0, i32 %173
  %175 = load i32, i32* %10, align 4
  %176 = getelementptr inbounds [0 x i32], [0 x i32]* @height, i32 0, i32 %175
  %177 = load i32, i32* %176, align 4
  %178 = shl i32 %177, 3
  %179 = load i32, i32* %10, align 4
  %180 = or i32 %178, %179
  %181 = getelementptr inbounds [56 x i32], [56 x i32]* %174, i32 0, i32 %180
  %182 = load i32, i32* %181, align 4
  store i32 %182, i32* %15, align 4
  %183 = load i32, i32* %15, align 4
  %184 = load i32, i32* %12, align 4
  %185 = icmp sgt i32 %183, %184
  br i1 %185, label %186, label %189

186:                                              ; preds = %169
  %187 = load i32, i32* %15, align 4
  store i32 %187, i32* %12, align 4
  %188 = load i32, i32* %8, align 4
  store i32 %188, i32* %11, align 4
  br label %189

189:                                              ; preds = %186, %169
  br label %190

190:                                              ; preds = %189
  %191 = load i32, i32* %8, align 4
  %192 = add nsw i32 %191, 1
  store i32 %192, i32* %8, align 4
  br label %165

193:                                              ; preds = %165
  %194 = load i32, i32* %11, align 4
  %195 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %194
  %196 = load i32, i32* %195, align 4
  store i32 %196, i32* %8, align 4
  %197 = load i32, i32* %7, align 4
  %198 = load i32, i32* %11, align 4
  %199 = icmp ne i32 %197, %198
  br i1 %199, label %200, label %209

200:                                              ; preds = %193
  %201 = load i32, i32* %7, align 4
  %202 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %201
  %203 = load i32, i32* %202, align 4
  %204 = load i32, i32* %11, align 4
  %205 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %204
  store i32 %203, i32* %205, align 4
  %206 = load i32, i32* %8, align 4
  %207 = load i32, i32* %7, align 4
  %208 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %207
  store i32 %206, i32* %208, align 4
  br label %209

209:                                              ; preds = %200, %193
  %210 = load i32, i32* %8, align 4
  %211 = call i32 bitcast (i32 (...)* @makemove to i32 (i32)*)(i32 signext %210)
  %212 = load i32, i32* %5, align 4
  %213 = sub nsw i32 0, %212
  %214 = load i32, i32* %4, align 4
  %215 = sub nsw i32 0, %214
  %216 = call i32 @ab(i32 signext %213, i32 signext %215)
  %217 = sub nsw i32 0, %216
  store i32 %217, i32* %12, align 4
  %218 = call i32 bitcast (i32 (...)* @backmove to i32 ()*)()
  %219 = load i32, i32* %12, align 4
  %220 = load i32, i32* %13, align 4
  %221 = icmp sgt i32 %219, %220
  br i1 %221, label %222, label %242

222:                                              ; preds = %209
  %223 = load i32, i32* %7, align 4
  store i32 %223, i32* %6, align 4
  %224 = load i32, i32* %12, align 4
  store i32 %224, i32* %13, align 4
  %225 = load i32, i32* %4, align 4
  %226 = icmp sgt i32 %224, %225
  br i1 %226, label %227, label %241

227:                                              ; preds = %222
  %228 = load i32, i32* %12, align 4
  store i32 %228, i32* %4, align 4
  %229 = load i32, i32* %5, align 4
  %230 = icmp sge i32 %228, %229
  br i1 %230, label %231, label %241

231:                                              ; preds = %227
  %232 = load i32, i32* %13, align 4
  %233 = icmp eq i32 %232, 0
  br i1 %233, label %234, label %240

234:                                              ; preds = %231
  %235 = load i32, i32* %7, align 4
  %236 = load i32, i32* %17, align 4
  %237 = sub nsw i32 %236, 1
  %238 = icmp slt i32 %235, %237
  br i1 %238, label %239, label %240

239:                                              ; preds = %234
  store i32 1, i32* %13, align 4
  br label %240

240:                                              ; preds = %239, %234, %231
  br label %246

241:                                              ; preds = %227, %222
  br label %242

242:                                              ; preds = %241, %209
  br label %243

243:                                              ; preds = %242
  %244 = load i32, i32* %7, align 4
  %245 = add nsw i32 %244, 1
  store i32 %245, i32* %7, align 4
  br label %159

246:                                              ; preds = %240, %159
  %247 = load i32, i32* %6, align 4
  %248 = icmp sgt i32 %247, 0
  br i1 %248, label %249, label %290

249:                                              ; preds = %246
  store i32 0, i32* %7, align 4
  br label %250

250:                                              ; preds = %270, %249
  %251 = load i32, i32* %7, align 4
  %252 = load i32, i32* %6, align 4
  %253 = icmp slt i32 %251, %252
  br i1 %253, label %254, label %273

254:                                              ; preds = %250
  %255 = load i32, i32* %20, align 4
  %256 = getelementptr inbounds [2 x [56 x i32]], [2 x [56 x i32]]* @history, i32 0, i32 %255
  %257 = load i32, i32* %7, align 4
  %258 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %257
  %259 = load i32, i32* %258, align 4
  %260 = getelementptr inbounds [0 x i32], [0 x i32]* @height, i32 0, i32 %259
  %261 = load i32, i32* %260, align 4
  %262 = shl i32 %261, 3
  %263 = load i32, i32* %7, align 4
  %264 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %263
  %265 = load i32, i32* %264, align 4
  %266 = or i32 %262, %265
  %267 = getelementptr inbounds [56 x i32], [56 x i32]* %256, i32 0, i32 %266
  %268 = load i32, i32* %267, align 4
  %269 = add nsw i32 %268, -1
  store i32 %269, i32* %267, align 4
  br label %270

270:                                              ; preds = %254
  %271 = load i32, i32* %7, align 4
  %272 = add nsw i32 %271, 1
  store i32 %272, i32* %7, align 4
  br label %250

273:                                              ; preds = %250
  %274 = load i32, i32* %6, align 4
  %275 = load i32, i32* %20, align 4
  %276 = getelementptr inbounds [2 x [56 x i32]], [2 x [56 x i32]]* @history, i32 0, i32 %275
  %277 = load i32, i32* %6, align 4
  %278 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %277
  %279 = load i32, i32* %278, align 4
  %280 = getelementptr inbounds [0 x i32], [0 x i32]* @height, i32 0, i32 %279
  %281 = load i32, i32* %280, align 4
  %282 = shl i32 %281, 3
  %283 = load i32, i32* %6, align 4
  %284 = getelementptr inbounds [8 x i32], [8 x i32]* %18, i32 0, i32 %283
  %285 = load i32, i32* %284, align 4
  %286 = or i32 %282, %285
  %287 = getelementptr inbounds [56 x i32], [56 x i32]* %276, i32 0, i32 %286
  %288 = load i32, i32* %287, align 4
  %289 = add nsw i32 %288, %274
  store i32 %289, i32* %287, align 4
  br label %290

290:                                              ; preds = %273, %246
  %291 = load i64, i64* @posed, align 8
  %292 = load i64, i64* %19, align 8
  %293 = sub nsw i64 %291, %292
  store i64 %293, i64* %19, align 8
  store i32 1, i32* %16, align 4
  br label %294

294:                                              ; preds = %299, %290
  %295 = load i64, i64* %19, align 8
  %296 = ashr i64 %295, 1
  store i64 %296, i64* %19, align 8
  %297 = icmp ne i64 %296, 0
  br i1 %297, label %298, label %302

298:                                              ; preds = %294
  br label %299

299:                                              ; preds = %298
  %300 = load i32, i32* %16, align 4
  %301 = add nsw i32 %300, 1
  store i32 %301, i32* %16, align 4
  br label %294

302:                                              ; preds = %294
  %303 = load i32, i32* %14, align 4
  %304 = icmp ne i32 %303, -128
  br i1 %304, label %305, label %316

305:                                              ; preds = %302
  %306 = load i32, i32* %13, align 4
  %307 = load i32, i32* %14, align 4
  %308 = ashr i32 %307, 5
  %309 = sub nsw i32 0, %308
  %310 = icmp eq i32 %306, %309
  br i1 %310, label %311, label %312

311:                                              ; preds = %305
  store i32 0, i32* %13, align 4
  br label %312

312:                                              ; preds = %311, %305
  %313 = load i32, i32* %13, align 4
  %314 = load i32, i32* %16, align 4
  %315 = call i32 bitcast (void (i32, i32)* @transrestore to i32 (i32, i32)*)(i32 signext %313, i32 signext %314)
  br label %320

316:                                              ; preds = %302
  %317 = load i32, i32* %13, align 4
  %318 = load i32, i32* %16, align 4
  %319 = call i32 bitcast (void (i32, i32)* @transtore to i32 (i32, i32)*)(i32 signext %317, i32 signext %318)
  br label %320

320:                                              ; preds = %316, %312
  %321 = load i32, i32* @plycnt, align 4
  %322 = icmp eq i32 %321, 8
  br i1 %322, label %323, label %332

323:                                              ; preds = %320
  %324 = call i32 bitcast (i32 (...)* @printMoves to i32 ()*)()
  %325 = load i32, i32* %13, align 4
  %326 = add nsw i32 4, %325
  %327 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.1, i32 0, i32 %326
  %328 = load i8, i8* %327, align 1
  %329 = sext i8 %328 to i32
  %330 = load i32, i32* %16, align 4
  %331 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i32 0, i32 0), i32 signext %329, i32 signext %330)
  br label %332

332:                                              ; preds = %323, %320
  %333 = load i32, i32* %13, align 4
  store i32 %333, i32* %3, align 4
  br label %334

334:                                              ; preds = %332, %153, %150, %141, %118, %114, %89, %64, %26
  %335 = load i32, i32* %3, align 4
  ret i32 %335
}

declare dso_local i32 @wins(...) #2

declare dso_local i32 @makemove(...) #2

declare dso_local i32 @backmove(...) #2

declare dso_local i32 @printMoves(...) #2

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone
define dso_local i32 @solve() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store i64 0, i64* @nodes, align 8
  store i64 1, i64* @msecs, align 8
  %8 = load i32, i32* @plycnt, align 4
  %9 = add nsw i32 %8, 1
  %10 = and i32 %9, 1
  store i32 %10, i32* %3, align 4
  store i32 0, i32* %2, align 4
  br label %11

11:                                               ; preds = %45, %0
  %12 = load i32, i32* %2, align 4
  %13 = add nsw i32 %12, 1
  store i32 %13, i32* %2, align 4
  %14 = icmp sle i32 %13, 7
  br i1 %14, label %15, label %46

15:                                               ; preds = %11
  %16 = load i32, i32* %2, align 4
  %17 = getelementptr inbounds [0 x i32], [0 x i32]* @height, i32 0, i32 %16
  %18 = load i32, i32* %17, align 4
  %19 = icmp sle i32 %18, 6
  br i1 %19, label %20, label %45

20:                                               ; preds = %15
  %21 = load i32, i32* %2, align 4
  %22 = load i32, i32* %2, align 4
  %23 = getelementptr inbounds [0 x i32], [0 x i32]* @height, i32 0, i32 %22
  %24 = load i32, i32* %23, align 4
  %25 = load i32, i32* %3, align 4
  %26 = shl i32 1, %25
  %27 = call i32 bitcast (i32 (...)* @wins to i32 (i32, i32, i32)*)(i32 signext %21, i32 signext %24, i32 signext %26)
  %28 = icmp ne i32 %27, 0
  br i1 %28, label %38, label %29

29:                                               ; preds = %20
  %30 = load i32, i32* %2, align 4
  %31 = getelementptr inbounds [0 x i32], [0 x i32]* @columns, i32 0, i32 %30
  %32 = load i32, i32* %31, align 4
  %33 = getelementptr inbounds [0 x i32], [0 x i32]* @colthr, i32 0, i32 %32
  %34 = load i32, i32* %33, align 4
  %35 = load i32, i32* %3, align 4
  %36 = shl i32 1, %35
  %37 = icmp eq i32 %34, %36
  br i1 %37, label %38, label %44

38:                                               ; preds = %29, %20
  %39 = load i32, i32* %3, align 4
  %40 = icmp ne i32 %39, 0
  %41 = zext i1 %40 to i64
  %42 = select i1 %40, i32 2, i32 -2
  %43 = shl i32 %42, 5
  store i32 %43, i32* %1, align 4
  br label %77

44:                                               ; preds = %29
  br label %45

45:                                               ; preds = %44, %15
  br label %11

46:                                               ; preds = %11
  %47 = call i32 @transpose()
  store i32 %47, i32* %4, align 4
  %48 = icmp ne i32 %47, -128
  br i1 %48, label %49, label %56

49:                                               ; preds = %46
  %50 = load i32, i32* %4, align 4
  %51 = and i32 %50, 32
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %53, label %55

53:                                               ; preds = %49
  %54 = load i32, i32* %4, align 4
  store i32 %54, i32* %1, align 4
  br label %77

55:                                               ; preds = %49
  br label %56

56:                                               ; preds = %55, %46
  %57 = call i64 bitcast (i64 (...)* @millisecs to i64 ()*)()
  %58 = sub nsw i64 %57, 1
  store i64 %58, i64* @msecs, align 8
  %59 = call i32 @ab(i32 signext -2, i32 signext 2)
  store i32 %59, i32* %6, align 4
  %60 = load i64, i64* @posed, align 8
  store i64 %60, i64* %7, align 8
  store i32 1, i32* %5, align 4
  br label %61

61:                                               ; preds = %66, %56
  %62 = load i64, i64* %7, align 8
  %63 = ashr i64 %62, 1
  store i64 %63, i64* %7, align 8
  %64 = icmp ne i64 %63, 0
  br i1 %64, label %65, label %69

65:                                               ; preds = %61
  br label %66

66:                                               ; preds = %65
  %67 = load i32, i32* %5, align 4
  %68 = add nsw i32 %67, 1
  store i32 %68, i32* %5, align 4
  br label %61

69:                                               ; preds = %61
  %70 = call i64 bitcast (i64 (...)* @millisecs to i64 ()*)()
  %71 = load i64, i64* @msecs, align 8
  %72 = sub nsw i64 %70, %71
  store i64 %72, i64* @msecs, align 8
  %73 = load i32, i32* %6, align 4
  %74 = shl i32 %73, 5
  %75 = load i32, i32* %5, align 4
  %76 = or i32 %74, %75
  store i32 %76, i32* %1, align 4
  br label %77

77:                                               ; preds = %69, %53, %38
  %78 = load i32, i32* %1, align 4
  ret i32 %78
}

declare dso_local i64 @millisecs(...) #2

; Function Attrs: noinline nounwind optnone
define dso_local i32 @main_2() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @c4_init()
  %5 = call i32 @puts(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0))
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.3, i32 0, i32 0), i32 signext 1050011, i32 signext 8)
  br label %7

7:                                                ; preds = %56, %0
  %8 = call i32 bitcast (i32 (...)* @reset to i32 ()*)()
  br label %9

9:                                                ; preds = %51, %7
  %10 = call i32 @getchar()
  store i32 %10, i32* %2, align 4
  %11 = icmp ne i32 %10, -1
  br i1 %11, label %12, label %52

12:                                               ; preds = %9
  %13 = load i32, i32* %2, align 4
  %14 = icmp sge i32 %13, 49
  br i1 %14, label %15, label %22

15:                                               ; preds = %12
  %16 = load i32, i32* %2, align 4
  %17 = icmp sle i32 %16, 55
  br i1 %17, label %18, label %22

18:                                               ; preds = %15
  %19 = load i32, i32* %2, align 4
  %20 = sub nsw i32 %19, 48
  %21 = call i32 bitcast (i32 (...)* @makemove to i32 (i32)*)(i32 signext %20)
  br label %51

22:                                               ; preds = %15, %12
  %23 = load i32, i32* %2, align 4
  %24 = icmp sge i32 %23, 65
  br i1 %24, label %25, label %33

25:                                               ; preds = %22
  %26 = load i32, i32* %2, align 4
  %27 = icmp sle i32 %26, 71
  br i1 %27, label %28, label %33

28:                                               ; preds = %25
  %29 = load i32, i32* %2, align 4
  %30 = sub nsw i32 %29, 65
  %31 = add nsw i32 %30, 1
  %32 = call i32 bitcast (i32 (...)* @makemove to i32 (i32)*)(i32 signext %31)
  br label %50

33:                                               ; preds = %25, %22
  %34 = load i32, i32* %2, align 4
  %35 = icmp sge i32 %34, 97
  br i1 %35, label %36, label %44

36:                                               ; preds = %33
  %37 = load i32, i32* %2, align 4
  %38 = icmp sle i32 %37, 103
  br i1 %38, label %39, label %44

39:                                               ; preds = %36
  %40 = load i32, i32* %2, align 4
  %41 = sub nsw i32 %40, 97
  %42 = add nsw i32 %41, 1
  %43 = call i32 bitcast (i32 (...)* @makemove to i32 (i32)*)(i32 signext %42)
  br label %49

44:                                               ; preds = %36, %33
  %45 = load i32, i32* %2, align 4
  %46 = icmp eq i32 %45, 10
  br i1 %46, label %47, label %48

47:                                               ; preds = %44
  br label %52

48:                                               ; preds = %44
  br label %49

49:                                               ; preds = %48, %39
  br label %50

50:                                               ; preds = %49, %28
  br label %51

51:                                               ; preds = %50, %18
  br label %9

52:                                               ; preds = %47, %9
  %53 = load i32, i32* %2, align 4
  %54 = icmp eq i32 %53, -1
  br i1 %54, label %55, label %56

55:                                               ; preds = %52
  br label %85

56:                                               ; preds = %52
  %57 = load i32, i32* @plycnt, align 4
  %58 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.4, i32 0, i32 0), i32 signext %57)
  %59 = call i32 bitcast (i32 (...)* @printMoves to i32 ()*)()
  %60 = call i32 @puts(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  %61 = call i32 bitcast (void ()* @emptyTT to i32 ()*)()
  %62 = call i32 @solve()
  store i32 %62, i32* %4, align 4
  %63 = load i32, i32* %4, align 4
  %64 = ashr i32 %63, 5
  %65 = load i32, i32* %4, align 4
  %66 = ashr i32 %65, 5
  %67 = add nsw i32 4, %66
  %68 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.1, i32 0, i32 %67
  %69 = load i8, i8* %68, align 1
  %70 = sext i8 %69 to i32
  %71 = load i32, i32* %4, align 4
  %72 = and i32 %71, 31
  %73 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.6, i32 0, i32 0), i32 signext %64, i32 signext %70, i32 signext %72)
  %74 = load i64, i64* @nodes, align 8
  %75 = trunc i64 %74 to i32
  %76 = load i64, i64* @msecs, align 8
  %77 = trunc i64 %76 to i32
  %78 = load i64, i64* @nodes, align 8
  %79 = sitofp i64 %78 to double
  %80 = load i64, i64* @msecs, align 8
  %81 = sitofp i64 %80 to double
  %82 = fdiv double %79, %81
  %83 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.7, i32 0, i32 0), i32 signext %75, i32 signext %77, double %82)
  %84 = call i32 bitcast (void ()* @htstat to i32 ()*)()
  br label %7

85:                                               ; preds = %55
  ret i32 0
}

declare dso_local i32 @puts(i8*) #2

declare dso_local i32 @reset(...) #2

declare dso_local i32 @getchar() #2

; Function Attrs: noinline nounwind optnone
define dso_local double @FFT_num_flops(i32 signext %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  store i32 %0, i32* %2, align 4
  %5 = load i32, i32* %2, align 4
  %6 = sitofp i32 %5 to double
  store double %6, double* %3, align 8
  %7 = load i32, i32* %2, align 4
  %8 = call i32 @int_log2(i32 signext %7)
  %9 = sitofp i32 %8 to double
  store double %9, double* %4, align 8
  %10 = load double, double* %3, align 8
  %11 = fmul double 5.000000e+00, %10
  %12 = fsub double %11, 2.000000e+00
  %13 = load double, double* %4, align 8
  %14 = fmul double %12, %13
  %15 = load double, double* %3, align 8
  %16 = fadd double %15, 1.000000e+00
  %17 = fmul double 2.000000e+00, %16
  %18 = fadd double %14, %17
  ret double %18
}

; Function Attrs: noinline nounwind optnone
define internal i32 @int_log2(i32 signext %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  store i32 1, i32* %3, align 4
  store i32 0, i32* %4, align 4
  br label %5

5:                                                ; preds = %10, %1
  %6 = load i32, i32* %3, align 4
  %7 = load i32, i32* %2, align 4
  %8 = icmp slt i32 %6, %7
  br i1 %8, label %9, label %15

9:                                                ; preds = %5
  br label %10

10:                                               ; preds = %9
  %11 = load i32, i32* %3, align 4
  %12 = mul nsw i32 %11, 2
  store i32 %12, i32* %3, align 4
  %13 = load i32, i32* %4, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, i32* %4, align 4
  br label %5

15:                                               ; preds = %5
  %16 = load i32, i32* %2, align 4
  %17 = load i32, i32* %4, align 4
  %18 = shl i32 1, %17
  %19 = icmp ne i32 %16, %18
  br i1 %19, label %20, label %23

20:                                               ; preds = %15
  %21 = load i32, i32* %2, align 4
  %22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.8, i32 0, i32 0), i32 signext %21)
  call void @exit(i32 signext 1) #8
  unreachable

23:                                               ; preds = %15
  %24 = load i32, i32* %4, align 4
  ret i32 %24
}

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32 signext) #3

; Function Attrs: noinline nounwind optnone
define dso_local void @FFT_bitreverse(i32 signext %0, double* %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca double*, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca double, align 8
  %13 = alloca double, align 8
  store i32 %0, i32* %3, align 4
  store double* %1, double** %4, align 4
  %14 = load i32, i32* %3, align 4
  %15 = sdiv i32 %14, 2
  store i32 %15, i32* %5, align 4
  %16 = load i32, i32* %5, align 4
  %17 = sub nsw i32 %16, 1
  store i32 %17, i32* %6, align 4
  store i32 0, i32* %7, align 4
  store i32 0, i32* %8, align 4
  br label %18

18:                                               ; preds = %82, %2
  %19 = load i32, i32* %7, align 4
  %20 = load i32, i32* %6, align 4
  %21 = icmp slt i32 %19, %20
  br i1 %21, label %22, label %85

22:                                               ; preds = %18
  %23 = load i32, i32* %7, align 4
  %24 = shl i32 %23, 1
  store i32 %24, i32* %9, align 4
  %25 = load i32, i32* %8, align 4
  %26 = shl i32 %25, 1
  store i32 %26, i32* %10, align 4
  %27 = load i32, i32* %5, align 4
  %28 = ashr i32 %27, 1
  store i32 %28, i32* %11, align 4
  %29 = load i32, i32* %7, align 4
  %30 = load i32, i32* %8, align 4
  %31 = icmp slt i32 %29, %30
  br i1 %31, label %32, label %67

32:                                               ; preds = %22
  %33 = load double*, double** %4, align 4
  %34 = load i32, i32* %9, align 4
  %35 = getelementptr inbounds double, double* %33, i32 %34
  %36 = load double, double* %35, align 8
  store double %36, double* %12, align 8
  %37 = load double*, double** %4, align 4
  %38 = load i32, i32* %9, align 4
  %39 = add nsw i32 %38, 1
  %40 = getelementptr inbounds double, double* %37, i32 %39
  %41 = load double, double* %40, align 8
  store double %41, double* %13, align 8
  %42 = load double*, double** %4, align 4
  %43 = load i32, i32* %10, align 4
  %44 = getelementptr inbounds double, double* %42, i32 %43
  %45 = load double, double* %44, align 8
  %46 = load double*, double** %4, align 4
  %47 = load i32, i32* %9, align 4
  %48 = getelementptr inbounds double, double* %46, i32 %47
  store double %45, double* %48, align 8
  %49 = load double*, double** %4, align 4
  %50 = load i32, i32* %10, align 4
  %51 = add nsw i32 %50, 1
  %52 = getelementptr inbounds double, double* %49, i32 %51
  %53 = load double, double* %52, align 8
  %54 = load double*, double** %4, align 4
  %55 = load i32, i32* %9, align 4
  %56 = add nsw i32 %55, 1
  %57 = getelementptr inbounds double, double* %54, i32 %56
  store double %53, double* %57, align 8
  %58 = load double, double* %12, align 8
  %59 = load double*, double** %4, align 4
  %60 = load i32, i32* %10, align 4
  %61 = getelementptr inbounds double, double* %59, i32 %60
  store double %58, double* %61, align 8
  %62 = load double, double* %13, align 8
  %63 = load double*, double** %4, align 4
  %64 = load i32, i32* %10, align 4
  %65 = add nsw i32 %64, 1
  %66 = getelementptr inbounds double, double* %63, i32 %65
  store double %62, double* %66, align 8
  br label %67

67:                                               ; preds = %32, %22
  br label %68

68:                                               ; preds = %72, %67
  %69 = load i32, i32* %11, align 4
  %70 = load i32, i32* %8, align 4
  %71 = icmp sle i32 %69, %70
  br i1 %71, label %72, label %78

72:                                               ; preds = %68
  %73 = load i32, i32* %11, align 4
  %74 = load i32, i32* %8, align 4
  %75 = sub nsw i32 %74, %73
  store i32 %75, i32* %8, align 4
  %76 = load i32, i32* %11, align 4
  %77 = ashr i32 %76, 1
  store i32 %77, i32* %11, align 4
  br label %68

78:                                               ; preds = %68
  %79 = load i32, i32* %11, align 4
  %80 = load i32, i32* %8, align 4
  %81 = add nsw i32 %80, %79
  store i32 %81, i32* %8, align 4
  br label %82

82:                                               ; preds = %78
  %83 = load i32, i32* %7, align 4
  %84 = add nsw i32 %83, 1
  store i32 %84, i32* %7, align 4
  br label %18

85:                                               ; preds = %18
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @FFT_transform(i32 signext %0, double* %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca double*, align 4
  store i32 %0, i32* %3, align 4
  store double* %1, double** %4, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load double*, double** %4, align 4
  call void @FFT_transform_internal(i32 signext %5, double* %6, i32 signext -1)
  ret void
}

; Function Attrs: noinline nounwind optnone
define internal void @FFT_transform_internal(i32 signext %0, double* %1, i32 signext %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca double*, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca double, align 8
  %12 = alloca double, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca double, align 8
  %16 = alloca double, align 8
  %17 = alloca double, align 8
  %18 = alloca double, align 8
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  %21 = alloca double, align 8
  %22 = alloca double, align 8
  %23 = alloca double, align 8
  %24 = alloca double, align 8
  %25 = alloca i32, align 4
  %26 = alloca i32, align 4
  %27 = alloca double, align 8
  %28 = alloca double, align 8
  %29 = alloca double, align 8
  %30 = alloca double, align 8
  store i32 %0, i32* %4, align 4
  store double* %1, double** %5, align 4
  store i32 %2, i32* %6, align 4
  %31 = load i32, i32* %4, align 4
  %32 = sdiv i32 %31, 2
  store i32 %32, i32* %7, align 4
  store i32 0, i32* %8, align 4
  store i32 1, i32* %10, align 4
  %33 = load i32, i32* %7, align 4
  %34 = icmp eq i32 %33, 1
  br i1 %34, label %35, label %36

35:                                               ; preds = %3
  br label %237

36:                                               ; preds = %3
  %37 = load i32, i32* %7, align 4
  %38 = call i32 @int_log2(i32 signext %37)
  store i32 %38, i32* %9, align 4
  %39 = load i32, i32* %4, align 4
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %41, label %42

41:                                               ; preds = %36
  br label %237

42:                                               ; preds = %36
  %43 = load i32, i32* %4, align 4
  %44 = load double*, double** %5, align 4
  call void @FFT_bitreverse(i32 signext %43, double* %44)
  store i32 0, i32* %8, align 4
  br label %45

45:                                               ; preds = %232, %42
  %46 = load i32, i32* %8, align 4
  %47 = load i32, i32* %9, align 4
  %48 = icmp slt i32 %46, %47
  br i1 %48, label %49, label %237

49:                                               ; preds = %45
  store double 1.000000e+00, double* %11, align 8
  store double 0.000000e+00, double* %12, align 8
  %50 = load i32, i32* %6, align 4
  %51 = sitofp i32 %50 to double
  %52 = fmul double 2.000000e+00, %51
  %53 = fmul double %52, 0x400921FB54442D18
  %54 = load i32, i32* %10, align 4
  %55 = sitofp i32 %54 to double
  %56 = fmul double 2.000000e+00, %55
  %57 = fdiv double %53, %56
  store double %57, double* %15, align 8
  %58 = load double, double* %15, align 8
  %59 = call double @sin(double %58) #7
  store double %59, double* %16, align 8
  %60 = load double, double* %15, align 8
  %61 = fdiv double %60, 2.000000e+00
  %62 = call double @sin(double %61) #7
  store double %62, double* %17, align 8
  %63 = load double, double* %17, align 8
  %64 = fmul double 2.000000e+00, %63
  %65 = load double, double* %17, align 8
  %66 = fmul double %64, %65
  store double %66, double* %18, align 8
  store i32 0, i32* %13, align 4
  store i32 0, i32* %14, align 4
  br label %67

67:                                               ; preds = %120, %49
  %68 = load i32, i32* %14, align 4
  %69 = load i32, i32* %7, align 4
  %70 = icmp slt i32 %68, %69
  br i1 %70, label %71, label %125

71:                                               ; preds = %67
  %72 = load i32, i32* %14, align 4
  %73 = mul nsw i32 2, %72
  store i32 %73, i32* %19, align 4
  %74 = load i32, i32* %14, align 4
  %75 = load i32, i32* %10, align 4
  %76 = add nsw i32 %74, %75
  %77 = mul nsw i32 2, %76
  store i32 %77, i32* %20, align 4
  %78 = load double*, double** %5, align 4
  %79 = load i32, i32* %20, align 4
  %80 = getelementptr inbounds double, double* %78, i32 %79
  %81 = load double, double* %80, align 8
  store double %81, double* %21, align 8
  %82 = load double*, double** %5, align 4
  %83 = load i32, i32* %20, align 4
  %84 = add nsw i32 %83, 1
  %85 = getelementptr inbounds double, double* %82, i32 %84
  %86 = load double, double* %85, align 8
  store double %86, double* %22, align 8
  %87 = load double*, double** %5, align 4
  %88 = load i32, i32* %19, align 4
  %89 = getelementptr inbounds double, double* %87, i32 %88
  %90 = load double, double* %89, align 8
  %91 = load double, double* %21, align 8
  %92 = fsub double %90, %91
  %93 = load double*, double** %5, align 4
  %94 = load i32, i32* %20, align 4
  %95 = getelementptr inbounds double, double* %93, i32 %94
  store double %92, double* %95, align 8
  %96 = load double*, double** %5, align 4
  %97 = load i32, i32* %19, align 4
  %98 = add nsw i32 %97, 1
  %99 = getelementptr inbounds double, double* %96, i32 %98
  %100 = load double, double* %99, align 8
  %101 = load double, double* %22, align 8
  %102 = fsub double %100, %101
  %103 = load double*, double** %5, align 4
  %104 = load i32, i32* %20, align 4
  %105 = add nsw i32 %104, 1
  %106 = getelementptr inbounds double, double* %103, i32 %105
  store double %102, double* %106, align 8
  %107 = load double, double* %21, align 8
  %108 = load double*, double** %5, align 4
  %109 = load i32, i32* %19, align 4
  %110 = getelementptr inbounds double, double* %108, i32 %109
  %111 = load double, double* %110, align 8
  %112 = fadd double %111, %107
  store double %112, double* %110, align 8
  %113 = load double, double* %22, align 8
  %114 = load double*, double** %5, align 4
  %115 = load i32, i32* %19, align 4
  %116 = add nsw i32 %115, 1
  %117 = getelementptr inbounds double, double* %114, i32 %116
  %118 = load double, double* %117, align 8
  %119 = fadd double %118, %113
  store double %119, double* %117, align 8
  br label %120

120:                                              ; preds = %71
  %121 = load i32, i32* %10, align 4
  %122 = mul nsw i32 2, %121
  %123 = load i32, i32* %14, align 4
  %124 = add nsw i32 %123, %122
  store i32 %124, i32* %14, align 4
  br label %67

125:                                              ; preds = %67
  store i32 1, i32* %13, align 4
  br label %126

126:                                              ; preds = %228, %125
  %127 = load i32, i32* %13, align 4
  %128 = load i32, i32* %10, align 4
  %129 = icmp slt i32 %127, %128
  br i1 %129, label %130, label %231

130:                                              ; preds = %126
  %131 = load double, double* %11, align 8
  %132 = load double, double* %16, align 8
  %133 = load double, double* %12, align 8
  %134 = fmul double %132, %133
  %135 = fsub double %131, %134
  %136 = load double, double* %18, align 8
  %137 = load double, double* %11, align 8
  %138 = fmul double %136, %137
  %139 = fsub double %135, %138
  store double %139, double* %23, align 8
  %140 = load double, double* %12, align 8
  %141 = load double, double* %16, align 8
  %142 = load double, double* %11, align 8
  %143 = fmul double %141, %142
  %144 = fadd double %140, %143
  %145 = load double, double* %18, align 8
  %146 = load double, double* %12, align 8
  %147 = fmul double %145, %146
  %148 = fsub double %144, %147
  store double %148, double* %24, align 8
  %149 = load double, double* %23, align 8
  store double %149, double* %11, align 8
  %150 = load double, double* %24, align 8
  store double %150, double* %12, align 8
  store i32 0, i32* %14, align 4
  br label %151

151:                                              ; preds = %222, %130
  %152 = load i32, i32* %14, align 4
  %153 = load i32, i32* %7, align 4
  %154 = icmp slt i32 %152, %153
  br i1 %154, label %155, label %227

155:                                              ; preds = %151
  %156 = load i32, i32* %14, align 4
  %157 = load i32, i32* %13, align 4
  %158 = add nsw i32 %156, %157
  %159 = mul nsw i32 2, %158
  store i32 %159, i32* %25, align 4
  %160 = load i32, i32* %14, align 4
  %161 = load i32, i32* %13, align 4
  %162 = add nsw i32 %160, %161
  %163 = load i32, i32* %10, align 4
  %164 = add nsw i32 %162, %163
  %165 = mul nsw i32 2, %164
  store i32 %165, i32* %26, align 4
  %166 = load double*, double** %5, align 4
  %167 = load i32, i32* %26, align 4
  %168 = getelementptr inbounds double, double* %166, i32 %167
  %169 = load double, double* %168, align 8
  store double %169, double* %27, align 8
  %170 = load double*, double** %5, align 4
  %171 = load i32, i32* %26, align 4
  %172 = add nsw i32 %171, 1
  %173 = getelementptr inbounds double, double* %170, i32 %172
  %174 = load double, double* %173, align 8
  store double %174, double* %28, align 8
  %175 = load double, double* %11, align 8
  %176 = load double, double* %27, align 8
  %177 = fmul double %175, %176
  %178 = load double, double* %12, align 8
  %179 = load double, double* %28, align 8
  %180 = fmul double %178, %179
  %181 = fsub double %177, %180
  store double %181, double* %29, align 8
  %182 = load double, double* %11, align 8
  %183 = load double, double* %28, align 8
  %184 = fmul double %182, %183
  %185 = load double, double* %12, align 8
  %186 = load double, double* %27, align 8
  %187 = fmul double %185, %186
  %188 = fadd double %184, %187
  store double %188, double* %30, align 8
  %189 = load double*, double** %5, align 4
  %190 = load i32, i32* %25, align 4
  %191 = getelementptr inbounds double, double* %189, i32 %190
  %192 = load double, double* %191, align 8
  %193 = load double, double* %29, align 8
  %194 = fsub double %192, %193
  %195 = load double*, double** %5, align 4
  %196 = load i32, i32* %26, align 4
  %197 = getelementptr inbounds double, double* %195, i32 %196
  store double %194, double* %197, align 8
  %198 = load double*, double** %5, align 4
  %199 = load i32, i32* %25, align 4
  %200 = add nsw i32 %199, 1
  %201 = getelementptr inbounds double, double* %198, i32 %200
  %202 = load double, double* %201, align 8
  %203 = load double, double* %30, align 8
  %204 = fsub double %202, %203
  %205 = load double*, double** %5, align 4
  %206 = load i32, i32* %26, align 4
  %207 = add nsw i32 %206, 1
  %208 = getelementptr inbounds double, double* %205, i32 %207
  store double %204, double* %208, align 8
  %209 = load double, double* %29, align 8
  %210 = load double*, double** %5, align 4
  %211 = load i32, i32* %25, align 4
  %212 = getelementptr inbounds double, double* %210, i32 %211
  %213 = load double, double* %212, align 8
  %214 = fadd double %213, %209
  store double %214, double* %212, align 8
  %215 = load double, double* %30, align 8
  %216 = load double*, double** %5, align 4
  %217 = load i32, i32* %25, align 4
  %218 = add nsw i32 %217, 1
  %219 = getelementptr inbounds double, double* %216, i32 %218
  %220 = load double, double* %219, align 8
  %221 = fadd double %220, %215
  store double %221, double* %219, align 8
  br label %222

222:                                              ; preds = %155
  %223 = load i32, i32* %10, align 4
  %224 = mul nsw i32 2, %223
  %225 = load i32, i32* %14, align 4
  %226 = add nsw i32 %225, %224
  store i32 %226, i32* %14, align 4
  br label %151

227:                                              ; preds = %151
  br label %228

228:                                              ; preds = %227
  %229 = load i32, i32* %13, align 4
  %230 = add nsw i32 %229, 1
  store i32 %230, i32* %13, align 4
  br label %126

231:                                              ; preds = %126
  br label %232

232:                                              ; preds = %231
  %233 = load i32, i32* %8, align 4
  %234 = add nsw i32 %233, 1
  store i32 %234, i32* %8, align 4
  %235 = load i32, i32* %10, align 4
  %236 = mul nsw i32 %235, 2
  store i32 %236, i32* %10, align 4
  br label %45

237:                                              ; preds = %45, %41, %35
  ret void
}

; Function Attrs: nounwind
declare dso_local double @sin(double) #1

; Function Attrs: noinline nounwind optnone
define dso_local void @FFT_inverse(i32 signext %0, double* %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca double*, align 4
  %5 = alloca i32, align 4
  %6 = alloca double, align 8
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store double* %1, double** %4, align 4
  %8 = load i32, i32* %3, align 4
  %9 = sdiv i32 %8, 2
  store i32 %9, i32* %5, align 4
  store double 0.000000e+00, double* %6, align 8
  store i32 0, i32* %7, align 4
  %10 = load i32, i32* %3, align 4
  %11 = load double*, double** %4, align 4
  call void @FFT_transform_internal(i32 signext %10, double* %11, i32 signext 1)
  %12 = load i32, i32* %5, align 4
  %13 = sitofp i32 %12 to double
  %14 = fdiv double 1.000000e+00, %13
  store double %14, double* %6, align 8
  store i32 0, i32* %7, align 4
  br label %15

15:                                               ; preds = %26, %2
  %16 = load i32, i32* %7, align 4
  %17 = load i32, i32* %3, align 4
  %18 = icmp slt i32 %16, %17
  br i1 %18, label %19, label %29

19:                                               ; preds = %15
  %20 = load double, double* %6, align 8
  %21 = load double*, double** %4, align 4
  %22 = load i32, i32* %7, align 4
  %23 = getelementptr inbounds double, double* %21, i32 %22
  %24 = load double, double* %23, align 8
  %25 = fmul double %24, %20
  store double %25, double* %23, align 8
  br label %26

26:                                               ; preds = %19
  %27 = load i32, i32* %7, align 4
  %28 = add nsw i32 %27, 1
  store i32 %28, i32* %7, align 4
  br label %15

29:                                               ; preds = %15
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local double @kernel_measureFFT(i32 signext %0, double %1, %struct.Random_struct* %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca %struct.Random_struct*, align 4
  %7 = alloca i32, align 4
  %8 = alloca double*, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.Stopwatch_struct*, align 4
  %11 = alloca i32, align 4
  %12 = alloca double, align 8
  store i32 %0, i32* %4, align 4
  store double %1, double* %5, align 8
  store %struct.Random_struct* %2, %struct.Random_struct** %6, align 4
  %13 = load i32, i32* %4, align 4
  %14 = mul nsw i32 2, %13
  store i32 %14, i32* %7, align 4
  %15 = load i32, i32* %7, align 4
  %16 = load %struct.Random_struct*, %struct.Random_struct** %6, align 4
  %17 = call double* @RandomVector(i32 signext %15, %struct.Random_struct* %16)
  store double* %17, double** %8, align 4
  store i32 1, i32* %9, align 4
  %18 = call %struct.Stopwatch_struct* @new_Stopwatch()
  store %struct.Stopwatch_struct* %18, %struct.Stopwatch_struct** %10, align 4
  store i32 0, i32* %11, align 4
  store double 0.000000e+00, double* %12, align 8
  br label %19

19:                                               ; preds = %39, %3
  %20 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  call void @Stopwatch_start(%struct.Stopwatch_struct* %20)
  store i32 0, i32* %11, align 4
  br label %21

21:                                               ; preds = %31, %19
  %22 = load i32, i32* %11, align 4
  %23 = load i32, i32* %9, align 4
  %24 = mul nsw i32 %23, 8
  %25 = icmp slt i32 %22, %24
  br i1 %25, label %26, label %34

26:                                               ; preds = %21
  %27 = load i32, i32* %7, align 4
  %28 = load double*, double** %8, align 4
  call void @FFT_transform(i32 signext %27, double* %28)
  %29 = load i32, i32* %7, align 4
  %30 = load double*, double** %8, align 4
  call void @FFT_inverse(i32 signext %29, double* %30)
  br label %31

31:                                               ; preds = %26
  %32 = load i32, i32* %11, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, i32* %11, align 4
  br label %21

34:                                               ; preds = %21
  %35 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  call void @Stopwatch_stop(%struct.Stopwatch_struct* %35)
  %36 = load i32, i32* %9, align 4
  %37 = icmp sgt i32 %36, 4096
  br i1 %37, label %38, label %39

38:                                               ; preds = %34
  br label %42

39:                                               ; preds = %34
  %40 = load i32, i32* %9, align 4
  %41 = mul nsw i32 %40, 2
  store i32 %41, i32* %9, align 4
  br label %19

42:                                               ; preds = %38
  %43 = load i32, i32* %4, align 4
  %44 = call double @FFT_num_flops(i32 signext %43)
  %45 = load i32, i32* %9, align 4
  %46 = sitofp i32 %45 to double
  %47 = fmul double %44, %46
  %48 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  %49 = call double @Stopwatch_read(%struct.Stopwatch_struct* %48)
  %50 = fdiv double %47, %49
  %51 = fmul double %50, 0x3EB0C6F7A0B5ED8D
  store double %51, double* %12, align 8
  %52 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  call void @Stopwatch_delete(%struct.Stopwatch_struct* %52)
  %53 = load double*, double** %8, align 4
  %54 = bitcast double* %53 to i8*
  call void @free(i8* %54) #7
  %55 = load double, double* %12, align 8
  ret double %55
}

; Function Attrs: noinline nounwind optnone
define dso_local double @kernel_measureSOR(i32 signext %0, double %1, %struct.Random_struct* %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca %struct.Random_struct*, align 4
  %7 = alloca double**, align 4
  %8 = alloca double, align 8
  %9 = alloca %struct.Stopwatch_struct*, align 4
  %10 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store double %1, double* %5, align 8
  store %struct.Random_struct* %2, %struct.Random_struct** %6, align 4
  %11 = load i32, i32* %4, align 4
  %12 = load i32, i32* %4, align 4
  %13 = load %struct.Random_struct*, %struct.Random_struct** %6, align 4
  %14 = call double** @RandomMatrix(i32 signext %11, i32 signext %12, %struct.Random_struct* %13)
  store double** %14, double*** %7, align 4
  store double 0.000000e+00, double* %8, align 8
  %15 = call %struct.Stopwatch_struct* @new_Stopwatch()
  store %struct.Stopwatch_struct* %15, %struct.Stopwatch_struct** %9, align 4
  store i32 1, i32* %10, align 4
  br label %16

16:                                               ; preds = %27, %3
  %17 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %9, align 4
  call void @Stopwatch_start(%struct.Stopwatch_struct* %17)
  %18 = load i32, i32* %4, align 4
  %19 = load i32, i32* %4, align 4
  %20 = load double**, double*** %7, align 4
  %21 = load i32, i32* %10, align 4
  %22 = mul nsw i32 %21, 16
  call void @SOR_execute(i32 signext %18, i32 signext %19, double 1.250000e+00, double** %20, i32 signext %22)
  %23 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %9, align 4
  call void @Stopwatch_stop(%struct.Stopwatch_struct* %23)
  %24 = load i32, i32* %10, align 4
  %25 = icmp sgt i32 %24, 4096
  br i1 %25, label %26, label %27

26:                                               ; preds = %16
  br label %30

27:                                               ; preds = %16
  %28 = load i32, i32* %10, align 4
  %29 = mul nsw i32 %28, 2
  store i32 %29, i32* %10, align 4
  br label %16

30:                                               ; preds = %26
  %31 = load i32, i32* %4, align 4
  %32 = load i32, i32* %4, align 4
  %33 = load i32, i32* %10, align 4
  %34 = call double @SOR_num_flops(i32 signext %31, i32 signext %32, i32 signext %33)
  %35 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %9, align 4
  %36 = call double @Stopwatch_read(%struct.Stopwatch_struct* %35)
  %37 = fdiv double %34, %36
  %38 = fmul double %37, 0x3EB0C6F7A0B5ED8D
  store double %38, double* %8, align 8
  %39 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %9, align 4
  call void @Stopwatch_delete(%struct.Stopwatch_struct* %39)
  %40 = load i32, i32* %4, align 4
  %41 = load i32, i32* %4, align 4
  %42 = load double**, double*** %7, align 4
  call void @Array2D_double_delete(i32 signext %40, i32 signext %41, double** %42)
  %43 = load double, double* %8, align 8
  ret double %43
}

; Function Attrs: noinline nounwind optnone
define dso_local double @kernel_measureMonteCarlo(double %0, %struct.Random_struct* %1) #0 {
  %3 = alloca double, align 8
  %4 = alloca %struct.Random_struct*, align 4
  %5 = alloca double, align 8
  %6 = alloca %struct.Stopwatch_struct*, align 4
  %7 = alloca i32, align 4
  store double %0, double* %3, align 8
  store %struct.Random_struct* %1, %struct.Random_struct** %4, align 4
  store double 0.000000e+00, double* %5, align 8
  %8 = call %struct.Stopwatch_struct* @new_Stopwatch()
  store %struct.Stopwatch_struct* %8, %struct.Stopwatch_struct** %6, align 4
  store i32 1, i32* %7, align 4
  br label %9

9:                                                ; preds = %18, %2
  %10 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %6, align 4
  call void @Stopwatch_start(%struct.Stopwatch_struct* %10)
  %11 = load i32, i32* %7, align 4
  %12 = mul nsw i32 %11, 65536
  %13 = call double @MonteCarlo_integrate(i32 signext %12)
  %14 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %6, align 4
  call void @Stopwatch_stop(%struct.Stopwatch_struct* %14)
  %15 = load i32, i32* %7, align 4
  %16 = icmp sgt i32 %15, 4096
  br i1 %16, label %17, label %18

17:                                               ; preds = %9
  br label %21

18:                                               ; preds = %9
  %19 = load i32, i32* %7, align 4
  %20 = mul nsw i32 %19, 2
  store i32 %20, i32* %7, align 4
  br label %9

21:                                               ; preds = %17
  %22 = load i32, i32* %7, align 4
  %23 = call double @MonteCarlo_num_flops(i32 signext %22)
  %24 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %6, align 4
  %25 = call double @Stopwatch_read(%struct.Stopwatch_struct* %24)
  %26 = fdiv double %23, %25
  %27 = fmul double %26, 0x3EB0C6F7A0B5ED8D
  store double %27, double* %5, align 8
  %28 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %6, align 4
  call void @Stopwatch_delete(%struct.Stopwatch_struct* %28)
  %29 = load double, double* %5, align 8
  ret double %29
}

; Function Attrs: noinline nounwind optnone
define dso_local double @kernel_measureSparseMatMult(i32 signext %0, i32 signext %1, double %2, %struct.Random_struct* %3) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca double, align 8
  %8 = alloca %struct.Random_struct*, align 4
  %9 = alloca double*, align 4
  %10 = alloca double*, align 4
  %11 = alloca double, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca double*, align 4
  %15 = alloca i32*, align 4
  %16 = alloca i32*, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca %struct.Stopwatch_struct*, align 4
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  %22 = alloca i32, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store double %2, double* %7, align 8
  store %struct.Random_struct* %3, %struct.Random_struct** %8, align 4
  %23 = load i32, i32* %5, align 4
  %24 = load %struct.Random_struct*, %struct.Random_struct** %8, align 4
  %25 = call double* @RandomVector(i32 signext %23, %struct.Random_struct* %24)
  store double* %25, double** %9, align 4
  %26 = load i32, i32* %5, align 4
  %27 = mul i32 8, %26
  %28 = call noalias i8* @malloc(i32 signext %27) #7
  %29 = bitcast i8* %28 to double*
  store double* %29, double** %10, align 4
  store double 0.000000e+00, double* %11, align 8
  %30 = load i32, i32* %6, align 4
  %31 = load i32, i32* %5, align 4
  %32 = sdiv i32 %30, %31
  store i32 %32, i32* %12, align 4
  %33 = load i32, i32* %12, align 4
  %34 = load i32, i32* %5, align 4
  %35 = mul nsw i32 %33, %34
  store i32 %35, i32* %13, align 4
  %36 = load i32, i32* %13, align 4
  %37 = load %struct.Random_struct*, %struct.Random_struct** %8, align 4
  %38 = call double* @RandomVector(i32 signext %36, %struct.Random_struct* %37)
  store double* %38, double** %14, align 4
  %39 = load i32, i32* %6, align 4
  %40 = mul i32 4, %39
  %41 = call noalias i8* @malloc(i32 signext %40) #7
  %42 = bitcast i8* %41 to i32*
  store i32* %42, i32** %15, align 4
  %43 = load i32, i32* %5, align 4
  %44 = add nsw i32 %43, 1
  %45 = mul i32 4, %44
  %46 = call noalias i8* @malloc(i32 signext %45) #7
  %47 = bitcast i8* %46 to i32*
  store i32* %47, i32** %16, align 4
  store i32 0, i32* %17, align 4
  store i32 1, i32* %18, align 4
  %48 = call %struct.Stopwatch_struct* @new_Stopwatch()
  store %struct.Stopwatch_struct* %48, %struct.Stopwatch_struct** %19, align 4
  %49 = load i32*, i32** %16, align 4
  %50 = getelementptr inbounds i32, i32* %49, i32 0
  store i32 0, i32* %50, align 4
  store i32 0, i32* %17, align 4
  br label %51

51:                                               ; preds = %91, %4
  %52 = load i32, i32* %17, align 4
  %53 = load i32, i32* %5, align 4
  %54 = icmp slt i32 %52, %53
  br i1 %54, label %55, label %94

55:                                               ; preds = %51
  %56 = load i32*, i32** %16, align 4
  %57 = load i32, i32* %17, align 4
  %58 = getelementptr inbounds i32, i32* %56, i32 %57
  %59 = load i32, i32* %58, align 4
  store i32 %59, i32* %20, align 4
  %60 = load i32, i32* %17, align 4
  %61 = load i32, i32* %12, align 4
  %62 = sdiv i32 %60, %61
  store i32 %62, i32* %21, align 4
  store i32 0, i32* %22, align 4
  %63 = load i32, i32* %20, align 4
  %64 = load i32, i32* %12, align 4
  %65 = add nsw i32 %63, %64
  %66 = load i32*, i32** %16, align 4
  %67 = load i32, i32* %17, align 4
  %68 = add nsw i32 %67, 1
  %69 = getelementptr inbounds i32, i32* %66, i32 %68
  store i32 %65, i32* %69, align 4
  %70 = load i32, i32* %21, align 4
  %71 = icmp slt i32 %70, 1
  br i1 %71, label %72, label %73

72:                                               ; preds = %55
  store i32 1, i32* %21, align 4
  br label %73

73:                                               ; preds = %72, %55
  store i32 0, i32* %22, align 4
  br label %74

74:                                               ; preds = %87, %73
  %75 = load i32, i32* %22, align 4
  %76 = load i32, i32* %12, align 4
  %77 = icmp slt i32 %75, %76
  br i1 %77, label %78, label %90

78:                                               ; preds = %74
  %79 = load i32, i32* %22, align 4
  %80 = load i32, i32* %21, align 4
  %81 = mul nsw i32 %79, %80
  %82 = load i32*, i32** %15, align 4
  %83 = load i32, i32* %20, align 4
  %84 = load i32, i32* %22, align 4
  %85 = add nsw i32 %83, %84
  %86 = getelementptr inbounds i32, i32* %82, i32 %85
  store i32 %81, i32* %86, align 4
  br label %87

87:                                               ; preds = %78
  %88 = load i32, i32* %22, align 4
  %89 = add nsw i32 %88, 1
  store i32 %89, i32* %22, align 4
  br label %74

90:                                               ; preds = %74
  br label %91

91:                                               ; preds = %90
  %92 = load i32, i32* %17, align 4
  %93 = add nsw i32 %92, 1
  store i32 %93, i32* %17, align 4
  br label %51

94:                                               ; preds = %51
  br label %95

95:                                               ; preds = %109, %94
  %96 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %19, align 4
  call void @Stopwatch_start(%struct.Stopwatch_struct* %96)
  %97 = load i32, i32* %5, align 4
  %98 = load double*, double** %10, align 4
  %99 = load double*, double** %14, align 4
  %100 = load i32*, i32** %16, align 4
  %101 = load i32*, i32** %15, align 4
  %102 = load double*, double** %9, align 4
  %103 = load i32, i32* %18, align 4
  %104 = mul nsw i32 %103, 64
  call void @SparseCompRow_matmult(i32 signext %97, double* %98, double* %99, i32* %100, i32* %101, double* %102, i32 signext %104)
  %105 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %19, align 4
  call void @Stopwatch_stop(%struct.Stopwatch_struct* %105)
  %106 = load i32, i32* %18, align 4
  %107 = icmp sgt i32 %106, 4096
  br i1 %107, label %108, label %109

108:                                              ; preds = %95
  br label %112

109:                                              ; preds = %95
  %110 = load i32, i32* %18, align 4
  %111 = mul nsw i32 %110, 2
  store i32 %111, i32* %18, align 4
  br label %95

112:                                              ; preds = %108
  %113 = load i32, i32* %5, align 4
  %114 = load i32, i32* %6, align 4
  %115 = load i32, i32* %18, align 4
  %116 = call double @SparseCompRow_num_flops(i32 signext %113, i32 signext %114, i32 signext %115)
  %117 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %19, align 4
  %118 = call double @Stopwatch_read(%struct.Stopwatch_struct* %117)
  %119 = fdiv double %116, %118
  %120 = fmul double %119, 0x3EB0C6F7A0B5ED8D
  store double %120, double* %11, align 8
  %121 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %19, align 4
  call void @Stopwatch_delete(%struct.Stopwatch_struct* %121)
  %122 = load i32*, i32** %16, align 4
  %123 = bitcast i32* %122 to i8*
  call void @free(i8* %123) #7
  %124 = load i32*, i32** %15, align 4
  %125 = bitcast i32* %124 to i8*
  call void @free(i8* %125) #7
  %126 = load double*, double** %14, align 4
  %127 = bitcast double* %126 to i8*
  call void @free(i8* %127) #7
  %128 = load double*, double** %10, align 4
  %129 = bitcast double* %128 to i8*
  call void @free(i8* %129) #7
  %130 = load double*, double** %9, align 4
  %131 = bitcast double* %130 to i8*
  call void @free(i8* %131) #7
  %132 = load double, double* %11, align 8
  ret double %132
}

; Function Attrs: noinline nounwind optnone
define dso_local double @kernel_measureLU(i32 signext %0, double %1, %struct.Random_struct* %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca %struct.Random_struct*, align 4
  %7 = alloca double**, align 4
  %8 = alloca double**, align 4
  %9 = alloca i32*, align 4
  %10 = alloca %struct.Stopwatch_struct*, align 4
  %11 = alloca double, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store double %1, double* %5, align 8
  store %struct.Random_struct* %2, %struct.Random_struct** %6, align 4
  store double** null, double*** %7, align 4
  store double** null, double*** %8, align 4
  store i32* null, i32** %9, align 4
  %14 = call %struct.Stopwatch_struct* @new_Stopwatch()
  store %struct.Stopwatch_struct* %14, %struct.Stopwatch_struct** %10, align 4
  store double 0.000000e+00, double* %11, align 8
  store i32 0, i32* %12, align 4
  store i32 1, i32* %13, align 4
  %15 = load i32, i32* %4, align 4
  %16 = load i32, i32* %4, align 4
  %17 = load %struct.Random_struct*, %struct.Random_struct** %6, align 4
  %18 = call double** @RandomMatrix(i32 signext %15, i32 signext %16, %struct.Random_struct* %17)
  store double** %18, double*** %7, align 4
  %19 = icmp eq double** %18, null
  br i1 %19, label %20, label %21

20:                                               ; preds = %3
  call void @exit(i32 signext 1) #8
  unreachable

21:                                               ; preds = %3
  %22 = load i32, i32* %4, align 4
  %23 = load i32, i32* %4, align 4
  %24 = call double** @new_Array2D_double(i32 signext %22, i32 signext %23)
  store double** %24, double*** %8, align 4
  %25 = icmp eq double** %24, null
  br i1 %25, label %26, label %27

26:                                               ; preds = %21
  call void @exit(i32 signext 1) #8
  unreachable

27:                                               ; preds = %21
  %28 = load i32, i32* %4, align 4
  %29 = mul i32 %28, 4
  %30 = call noalias i8* @malloc(i32 signext %29) #7
  %31 = bitcast i8* %30 to i32*
  store i32* %31, i32** %9, align 4
  %32 = icmp eq i32* %31, null
  br i1 %32, label %33, label %34

33:                                               ; preds = %27
  call void @exit(i32 signext 1) #8
  unreachable

34:                                               ; preds = %27
  br label %35

35:                                               ; preds = %59, %34
  %36 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  call void @Stopwatch_start(%struct.Stopwatch_struct* %36)
  store i32 0, i32* %12, align 4
  br label %37

37:                                               ; preds = %51, %35
  %38 = load i32, i32* %12, align 4
  %39 = load i32, i32* %13, align 4
  %40 = icmp slt i32 %38, %39
  br i1 %40, label %41, label %54

41:                                               ; preds = %37
  %42 = load i32, i32* %4, align 4
  %43 = load i32, i32* %4, align 4
  %44 = load double**, double*** %8, align 4
  %45 = load double**, double*** %7, align 4
  call void @Array2D_double_copy(i32 signext %42, i32 signext %43, double** %44, double** %45)
  %46 = load i32, i32* %4, align 4
  %47 = load i32, i32* %4, align 4
  %48 = load double**, double*** %8, align 4
  %49 = load i32*, i32** %9, align 4
  %50 = call i32 @LU_factor(i32 signext %46, i32 signext %47, double** %48, i32* %49)
  br label %51

51:                                               ; preds = %41
  %52 = load i32, i32* %12, align 4
  %53 = add nsw i32 %52, 1
  store i32 %53, i32* %12, align 4
  br label %37

54:                                               ; preds = %37
  %55 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  call void @Stopwatch_stop(%struct.Stopwatch_struct* %55)
  %56 = load i32, i32* %13, align 4
  %57 = icmp sgt i32 %56, 4096
  br i1 %57, label %58, label %59

58:                                               ; preds = %54
  br label %62

59:                                               ; preds = %54
  %60 = load i32, i32* %13, align 4
  %61 = mul nsw i32 %60, 2
  store i32 %61, i32* %13, align 4
  br label %35

62:                                               ; preds = %58
  %63 = load i32, i32* %4, align 4
  %64 = call double @LU_num_flops(i32 signext %63)
  %65 = load i32, i32* %13, align 4
  %66 = sitofp i32 %65 to double
  %67 = fmul double %64, %66
  %68 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  %69 = call double @Stopwatch_read(%struct.Stopwatch_struct* %68)
  %70 = fdiv double %67, %69
  %71 = fmul double %70, 0x3EB0C6F7A0B5ED8D
  store double %71, double* %11, align 8
  %72 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %10, align 4
  call void @Stopwatch_delete(%struct.Stopwatch_struct* %72)
  %73 = load i32*, i32** %9, align 4
  %74 = bitcast i32* %73 to i8*
  call void @free(i8* %74) #7
  %75 = load i32, i32* %4, align 4
  %76 = load i32, i32* %4, align 4
  %77 = load double**, double*** %8, align 4
  call void @Array2D_double_delete(i32 signext %75, i32 signext %76, double** %77)
  %78 = load i32, i32* %4, align 4
  %79 = load i32, i32* %4, align 4
  %80 = load double**, double*** %7, align 4
  call void @Array2D_double_delete(i32 signext %78, i32 signext %79, double** %80)
  %81 = load double, double* %11, align 8
  ret double %81
}

; Function Attrs: noinline nounwind optnone
define dso_local double @LU_num_flops(i32 signext %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca double, align 8
  store i32 %0, i32* %2, align 4
  %4 = load i32, i32* %2, align 4
  %5 = sitofp i32 %4 to double
  store double %5, double* %3, align 8
  %6 = load double, double* %3, align 8
  %7 = fmul double 2.000000e+00, %6
  %8 = load double, double* %3, align 8
  %9 = fmul double %7, %8
  %10 = load double, double* %3, align 8
  %11 = fmul double %9, %10
  %12 = fdiv double %11, 3.000000e+00
  ret double %12
}

; Function Attrs: noinline nounwind optnone
define dso_local void @LU_copy_matrix(i32 signext %0, i32 signext %1, double** %2, double** %3) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca double**, align 4
  %8 = alloca double**, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store double** %2, double*** %7, align 4
  store double** %3, double*** %8, align 4
  store i32 0, i32* %9, align 4
  br label %11

11:                                               ; preds = %38, %4
  %12 = load i32, i32* %9, align 4
  %13 = load i32, i32* %5, align 4
  %14 = icmp slt i32 %12, %13
  br i1 %14, label %15, label %41

15:                                               ; preds = %11
  store i32 0, i32* %10, align 4
  br label %16

16:                                               ; preds = %34, %15
  %17 = load i32, i32* %10, align 4
  %18 = load i32, i32* %6, align 4
  %19 = icmp slt i32 %17, %18
  br i1 %19, label %20, label %37

20:                                               ; preds = %16
  %21 = load double**, double*** %8, align 4
  %22 = load i32, i32* %9, align 4
  %23 = getelementptr inbounds double*, double** %21, i32 %22
  %24 = load double*, double** %23, align 4
  %25 = load i32, i32* %10, align 4
  %26 = getelementptr inbounds double, double* %24, i32 %25
  %27 = load double, double* %26, align 8
  %28 = load double**, double*** %7, align 4
  %29 = load i32, i32* %9, align 4
  %30 = getelementptr inbounds double*, double** %28, i32 %29
  %31 = load double*, double** %30, align 4
  %32 = load i32, i32* %10, align 4
  %33 = getelementptr inbounds double, double* %31, i32 %32
  store double %27, double* %33, align 8
  br label %34

34:                                               ; preds = %20
  %35 = load i32, i32* %10, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, i32* %10, align 4
  br label %16

37:                                               ; preds = %16
  br label %38

38:                                               ; preds = %37
  %39 = load i32, i32* %9, align 4
  %40 = add nsw i32 %39, 1
  store i32 %40, i32* %9, align 4
  br label %11

41:                                               ; preds = %11
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @LU_factor(i32 signext %0, i32 signext %1, double** %2, i32* %3) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca double**, align 4
  %9 = alloca i32*, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca double, align 8
  %15 = alloca double, align 8
  %16 = alloca double*, align 4
  %17 = alloca double, align 8
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca double*, align 4
  %21 = alloca double*, align 4
  %22 = alloca double, align 8
  %23 = alloca i32, align 4
  store i32 %0, i32* %6, align 4
  store i32 %1, i32* %7, align 4
  store double** %2, double*** %8, align 4
  store i32* %3, i32** %9, align 4
  %24 = load i32, i32* %6, align 4
  %25 = load i32, i32* %7, align 4
  %26 = icmp slt i32 %24, %25
  br i1 %26, label %27, label %29

27:                                               ; preds = %4
  %28 = load i32, i32* %6, align 4
  br label %31

29:                                               ; preds = %4
  %30 = load i32, i32* %7, align 4
  br label %31

31:                                               ; preds = %29, %27
  %32 = phi i32 [ %28, %27 ], [ %30, %29 ]
  store i32 %32, i32* %10, align 4
  store i32 0, i32* %11, align 4
  store i32 0, i32* %11, align 4
  br label %33

33:                                               ; preds = %192, %31
  %34 = load i32, i32* %11, align 4
  %35 = load i32, i32* %10, align 4
  %36 = icmp slt i32 %34, %35
  br i1 %36, label %37, label %195

37:                                               ; preds = %33
  %38 = load i32, i32* %11, align 4
  store i32 %38, i32* %12, align 4
  %39 = load double**, double*** %8, align 4
  %40 = load i32, i32* %11, align 4
  %41 = getelementptr inbounds double*, double** %39, i32 %40
  %42 = load double*, double** %41, align 4
  %43 = load i32, i32* %11, align 4
  %44 = getelementptr inbounds double, double* %42, i32 %43
  %45 = load double, double* %44, align 8
  %46 = call double @llvm.fabs.f64(double %45)
  store double %46, double* %14, align 8
  %47 = load i32, i32* %11, align 4
  %48 = add nsw i32 %47, 1
  store i32 %48, i32* %13, align 4
  br label %49

49:                                               ; preds = %69, %37
  %50 = load i32, i32* %13, align 4
  %51 = load i32, i32* %6, align 4
  %52 = icmp slt i32 %50, %51
  br i1 %52, label %53, label %72

53:                                               ; preds = %49
  %54 = load double**, double*** %8, align 4
  %55 = load i32, i32* %13, align 4
  %56 = getelementptr inbounds double*, double** %54, i32 %55
  %57 = load double*, double** %56, align 4
  %58 = load i32, i32* %11, align 4
  %59 = getelementptr inbounds double, double* %57, i32 %58
  %60 = load double, double* %59, align 8
  %61 = call double @llvm.fabs.f64(double %60)
  store double %61, double* %15, align 8
  %62 = load double, double* %15, align 8
  %63 = load double, double* %14, align 8
  %64 = fcmp ogt double %62, %63
  br i1 %64, label %65, label %68

65:                                               ; preds = %53
  %66 = load i32, i32* %13, align 4
  store i32 %66, i32* %12, align 4
  %67 = load double, double* %15, align 8
  store double %67, double* %14, align 8
  br label %68

68:                                               ; preds = %65, %53
  br label %69

69:                                               ; preds = %68
  %70 = load i32, i32* %13, align 4
  %71 = add nsw i32 %70, 1
  store i32 %71, i32* %13, align 4
  br label %49

72:                                               ; preds = %49
  %73 = load i32, i32* %12, align 4
  %74 = load i32*, i32** %9, align 4
  %75 = load i32, i32* %11, align 4
  %76 = getelementptr inbounds i32, i32* %74, i32 %75
  store i32 %73, i32* %76, align 4
  %77 = load double**, double*** %8, align 4
  %78 = load i32, i32* %12, align 4
  %79 = getelementptr inbounds double*, double** %77, i32 %78
  %80 = load double*, double** %79, align 4
  %81 = load i32, i32* %11, align 4
  %82 = getelementptr inbounds double, double* %80, i32 %81
  %83 = load double, double* %82, align 8
  %84 = fcmp oeq double %83, 0.000000e+00
  br i1 %84, label %85, label %86

85:                                               ; preds = %72
  store i32 1, i32* %5, align 4
  br label %196

86:                                               ; preds = %72
  %87 = load i32, i32* %12, align 4
  %88 = load i32, i32* %11, align 4
  %89 = icmp ne i32 %87, %88
  br i1 %89, label %90, label %106

90:                                               ; preds = %86
  %91 = load double**, double*** %8, align 4
  %92 = load i32, i32* %11, align 4
  %93 = getelementptr inbounds double*, double** %91, i32 %92
  %94 = load double*, double** %93, align 4
  store double* %94, double** %16, align 4
  %95 = load double**, double*** %8, align 4
  %96 = load i32, i32* %12, align 4
  %97 = getelementptr inbounds double*, double** %95, i32 %96
  %98 = load double*, double** %97, align 4
  %99 = load double**, double*** %8, align 4
  %100 = load i32, i32* %11, align 4
  %101 = getelementptr inbounds double*, double** %99, i32 %100
  store double* %98, double** %101, align 4
  %102 = load double*, double** %16, align 4
  %103 = load double**, double*** %8, align 4
  %104 = load i32, i32* %12, align 4
  %105 = getelementptr inbounds double*, double** %103, i32 %104
  store double* %102, double** %105, align 4
  br label %106

106:                                              ; preds = %90, %86
  %107 = load i32, i32* %11, align 4
  %108 = load i32, i32* %6, align 4
  %109 = sub nsw i32 %108, 1
  %110 = icmp slt i32 %107, %109
  br i1 %110, label %111, label %140

111:                                              ; preds = %106
  %112 = load double**, double*** %8, align 4
  %113 = load i32, i32* %11, align 4
  %114 = getelementptr inbounds double*, double** %112, i32 %113
  %115 = load double*, double** %114, align 4
  %116 = load i32, i32* %11, align 4
  %117 = getelementptr inbounds double, double* %115, i32 %116
  %118 = load double, double* %117, align 8
  %119 = fdiv double 1.000000e+00, %118
  store double %119, double* %17, align 8
  %120 = load i32, i32* %11, align 4
  %121 = add nsw i32 %120, 1
  store i32 %121, i32* %18, align 4
  br label %122

122:                                              ; preds = %136, %111
  %123 = load i32, i32* %18, align 4
  %124 = load i32, i32* %6, align 4
  %125 = icmp slt i32 %123, %124
  br i1 %125, label %126, label %139

126:                                              ; preds = %122
  %127 = load double, double* %17, align 8
  %128 = load double**, double*** %8, align 4
  %129 = load i32, i32* %18, align 4
  %130 = getelementptr inbounds double*, double** %128, i32 %129
  %131 = load double*, double** %130, align 4
  %132 = load i32, i32* %11, align 4
  %133 = getelementptr inbounds double, double* %131, i32 %132
  %134 = load double, double* %133, align 8
  %135 = fmul double %134, %127
  store double %135, double* %133, align 8
  br label %136

136:                                              ; preds = %126
  %137 = load i32, i32* %18, align 4
  %138 = add nsw i32 %137, 1
  store i32 %138, i32* %18, align 4
  br label %122

139:                                              ; preds = %122
  br label %140

140:                                              ; preds = %139, %106
  %141 = load i32, i32* %11, align 4
  %142 = load i32, i32* %10, align 4
  %143 = sub nsw i32 %142, 1
  %144 = icmp slt i32 %141, %143
  br i1 %144, label %145, label %191

145:                                              ; preds = %140
  %146 = load i32, i32* %11, align 4
  %147 = add nsw i32 %146, 1
  store i32 %147, i32* %19, align 4
  br label %148

148:                                              ; preds = %187, %145
  %149 = load i32, i32* %19, align 4
  %150 = load i32, i32* %6, align 4
  %151 = icmp slt i32 %149, %150
  br i1 %151, label %152, label %190

152:                                              ; preds = %148
  %153 = load double**, double*** %8, align 4
  %154 = load i32, i32* %19, align 4
  %155 = getelementptr inbounds double*, double** %153, i32 %154
  %156 = load double*, double** %155, align 4
  store double* %156, double** %20, align 4
  %157 = load double**, double*** %8, align 4
  %158 = load i32, i32* %11, align 4
  %159 = getelementptr inbounds double*, double** %157, i32 %158
  %160 = load double*, double** %159, align 4
  store double* %160, double** %21, align 4
  %161 = load double*, double** %20, align 4
  %162 = load i32, i32* %11, align 4
  %163 = getelementptr inbounds double, double* %161, i32 %162
  %164 = load double, double* %163, align 8
  store double %164, double* %22, align 8
  %165 = load i32, i32* %11, align 4
  %166 = add nsw i32 %165, 1
  store i32 %166, i32* %23, align 4
  br label %167

167:                                              ; preds = %183, %152
  %168 = load i32, i32* %23, align 4
  %169 = load i32, i32* %7, align 4
  %170 = icmp slt i32 %168, %169
  br i1 %170, label %171, label %186

171:                                              ; preds = %167
  %172 = load double, double* %22, align 8
  %173 = load double*, double** %21, align 4
  %174 = load i32, i32* %23, align 4
  %175 = getelementptr inbounds double, double* %173, i32 %174
  %176 = load double, double* %175, align 8
  %177 = fmul double %172, %176
  %178 = load double*, double** %20, align 4
  %179 = load i32, i32* %23, align 4
  %180 = getelementptr inbounds double, double* %178, i32 %179
  %181 = load double, double* %180, align 8
  %182 = fsub double %181, %177
  store double %182, double* %180, align 8
  br label %183

183:                                              ; preds = %171
  %184 = load i32, i32* %23, align 4
  %185 = add nsw i32 %184, 1
  store i32 %185, i32* %23, align 4
  br label %167

186:                                              ; preds = %167
  br label %187

187:                                              ; preds = %186
  %188 = load i32, i32* %19, align 4
  %189 = add nsw i32 %188, 1
  store i32 %189, i32* %19, align 4
  br label %148

190:                                              ; preds = %148
  br label %191

191:                                              ; preds = %190, %140
  br label %192

192:                                              ; preds = %191
  %193 = load i32, i32* %11, align 4
  %194 = add nsw i32 %193, 1
  store i32 %194, i32* %11, align 4
  br label %33

195:                                              ; preds = %33
  store i32 0, i32* %5, align 4
  br label %196

196:                                              ; preds = %195, %85
  %197 = load i32, i32* %5, align 4
  ret i32 %197
}

; Function Attrs: nounwind readnone speculatable willreturn
declare double @llvm.fabs.f64(double) #4

; Function Attrs: noinline nounwind optnone
define dso_local double @MonteCarlo_num_flops(i32 signext %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = sitofp i32 %3 to double
  %5 = fmul double %4, 4.000000e+00
  ret double %5
}

; Function Attrs: noinline nounwind optnone
define dso_local double @MonteCarlo_integrate(i32 signext %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.Random_struct*, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca double, align 8
  %7 = alloca double, align 8
  store i32 %0, i32* %2, align 4
  %8 = call %struct.Random_struct* @new_Random_seed(i32 signext 113)
  store %struct.Random_struct* %8, %struct.Random_struct** %3, align 4
  store i32 0, i32* %4, align 4
  store i32 0, i32* %5, align 4
  br label %9

9:                                                ; preds = %30, %1
  %10 = load i32, i32* %5, align 4
  %11 = load i32, i32* %2, align 4
  %12 = icmp slt i32 %10, %11
  br i1 %12, label %13, label %33

13:                                               ; preds = %9
  %14 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %15 = call double @Random_nextDouble(%struct.Random_struct* %14)
  store double %15, double* %6, align 8
  %16 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %17 = call double @Random_nextDouble(%struct.Random_struct* %16)
  store double %17, double* %7, align 8
  %18 = load double, double* %6, align 8
  %19 = load double, double* %6, align 8
  %20 = fmul double %18, %19
  %21 = load double, double* %7, align 8
  %22 = load double, double* %7, align 8
  %23 = fmul double %21, %22
  %24 = fadd double %20, %23
  %25 = fcmp ole double %24, 1.000000e+00
  br i1 %25, label %26, label %29

26:                                               ; preds = %13
  %27 = load i32, i32* %4, align 4
  %28 = add nsw i32 %27, 1
  store i32 %28, i32* %4, align 4
  br label %29

29:                                               ; preds = %26, %13
  br label %30

30:                                               ; preds = %29
  %31 = load i32, i32* %5, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %5, align 4
  br label %9

33:                                               ; preds = %9
  %34 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  call void @Random_delete(%struct.Random_struct* %34)
  %35 = load i32, i32* %4, align 4
  %36 = sitofp i32 %35 to double
  %37 = load i32, i32* %2, align 4
  %38 = sitofp i32 %37 to double
  %39 = fdiv double %36, %38
  %40 = fmul double %39, 4.000000e+00
  ret double %40
}

; Function Attrs: noinline nounwind optnone
define dso_local %struct.Random_struct* @new_Random_seed(i32 signext %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.Random_struct*, align 4
  store i32 %0, i32* %2, align 4
  %4 = call noalias i8* @malloc(i32 signext 112) #7
  %5 = bitcast i8* %4 to %struct.Random_struct*
  store %struct.Random_struct* %5, %struct.Random_struct** %3, align 4
  %6 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %7 = load i32, i32* %2, align 4
  call void @initialize(%struct.Random_struct* %6, i32 signext %7)
  %8 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %9 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %8, i32 0, i32 5
  store double 0.000000e+00, double* %9, align 8
  %10 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %11 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %10, i32 0, i32 6
  store double 1.000000e+00, double* %11, align 8
  %12 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %13 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %12, i32 0, i32 7
  store double 1.000000e+00, double* %13, align 8
  %14 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %15 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %14, i32 0, i32 4
  store i32 0, i32* %15, align 8
  %16 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  ret %struct.Random_struct* %16
}

; Function Attrs: noinline nounwind optnone
define internal void @initialize(%struct.Random_struct* %0, i32 signext %1) #0 {
  %3 = alloca %struct.Random_struct*, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %struct.Random_struct* %0, %struct.Random_struct** %3, align 4
  store i32 %1, i32* %4, align 4
  store double 0x3E00000000200000, double* @dm1, align 8
  %11 = load i32, i32* %4, align 4
  %12 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %13 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %12, i32 0, i32 1
  store i32 %11, i32* %13, align 4
  %14 = load i32, i32* %4, align 4
  %15 = icmp slt i32 %14, 0
  br i1 %15, label %16, label %19

16:                                               ; preds = %2
  %17 = load i32, i32* %4, align 4
  %18 = sub nsw i32 0, %17
  store i32 %18, i32* %4, align 4
  br label %19

19:                                               ; preds = %16, %2
  %20 = load i32, i32* %4, align 4
  %21 = icmp slt i32 %20, 2147483647
  br i1 %21, label %22, label %24

22:                                               ; preds = %19
  %23 = load i32, i32* %4, align 4
  br label %25

24:                                               ; preds = %19
  br label %25

25:                                               ; preds = %24, %22
  %26 = phi i32 [ %23, %22 ], [ 2147483647, %24 ]
  store i32 %26, i32* %5, align 4
  %27 = load i32, i32* %5, align 4
  %28 = srem i32 %27, 2
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %33

30:                                               ; preds = %25
  %31 = load i32, i32* %5, align 4
  %32 = add nsw i32 %31, -1
  store i32 %32, i32* %5, align 4
  br label %33

33:                                               ; preds = %30, %25
  store i32 9069, i32* %6, align 4
  store i32 0, i32* %7, align 4
  %34 = load i32, i32* %5, align 4
  %35 = srem i32 %34, 65536
  store i32 %35, i32* %8, align 4
  %36 = load i32, i32* %5, align 4
  %37 = sdiv i32 %36, 65536
  store i32 %37, i32* %9, align 4
  store i32 0, i32* %10, align 4
  br label %38

38:                                               ; preds = %66, %33
  %39 = load i32, i32* %10, align 4
  %40 = icmp slt i32 %39, 17
  br i1 %40, label %41, label %69

41:                                               ; preds = %38
  %42 = load i32, i32* %8, align 4
  %43 = load i32, i32* %6, align 4
  %44 = mul nsw i32 %42, %43
  store i32 %44, i32* %5, align 4
  %45 = load i32, i32* %5, align 4
  %46 = sdiv i32 %45, 65536
  %47 = load i32, i32* %8, align 4
  %48 = load i32, i32* %7, align 4
  %49 = mul nsw i32 %47, %48
  %50 = add nsw i32 %46, %49
  %51 = load i32, i32* %9, align 4
  %52 = load i32, i32* %6, align 4
  %53 = mul nsw i32 %51, %52
  %54 = add nsw i32 %50, %53
  %55 = srem i32 %54, 32768
  store i32 %55, i32* %9, align 4
  %56 = load i32, i32* %5, align 4
  %57 = srem i32 %56, 65536
  store i32 %57, i32* %8, align 4
  %58 = load i32, i32* %8, align 4
  %59 = load i32, i32* %9, align 4
  %60 = mul nsw i32 65536, %59
  %61 = add nsw i32 %58, %60
  %62 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %63 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %62, i32 0, i32 0
  %64 = load i32, i32* %10, align 4
  %65 = getelementptr inbounds [17 x i32], [17 x i32]* %63, i32 0, i32 %64
  store i32 %61, i32* %65, align 4
  br label %66

66:                                               ; preds = %41
  %67 = load i32, i32* %10, align 4
  %68 = add nsw i32 %67, 1
  store i32 %68, i32* %10, align 4
  br label %38

69:                                               ; preds = %38
  %70 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %71 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %70, i32 0, i32 2
  store i32 4, i32* %71, align 8
  %72 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %73 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %72, i32 0, i32 3
  store i32 16, i32* %73, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local %struct.Random_struct* @new_Random(i32 signext %0, double %1, double %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  %7 = alloca %struct.Random_struct*, align 4
  store i32 %0, i32* %4, align 4
  store double %1, double* %5, align 8
  store double %2, double* %6, align 8
  %8 = call noalias i8* @malloc(i32 signext 112) #7
  %9 = bitcast i8* %8 to %struct.Random_struct*
  store %struct.Random_struct* %9, %struct.Random_struct** %7, align 4
  %10 = load %struct.Random_struct*, %struct.Random_struct** %7, align 4
  %11 = load i32, i32* %4, align 4
  call void @initialize(%struct.Random_struct* %10, i32 signext %11)
  %12 = load double, double* %5, align 8
  %13 = load %struct.Random_struct*, %struct.Random_struct** %7, align 4
  %14 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %13, i32 0, i32 5
  store double %12, double* %14, align 8
  %15 = load double, double* %6, align 8
  %16 = load %struct.Random_struct*, %struct.Random_struct** %7, align 4
  %17 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %16, i32 0, i32 6
  store double %15, double* %17, align 8
  %18 = load double, double* %6, align 8
  %19 = load double, double* %5, align 8
  %20 = fsub double %18, %19
  %21 = load %struct.Random_struct*, %struct.Random_struct** %7, align 4
  %22 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %21, i32 0, i32 7
  store double %20, double* %22, align 8
  %23 = load %struct.Random_struct*, %struct.Random_struct** %7, align 4
  %24 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %23, i32 0, i32 4
  store i32 1, i32* %24, align 8
  %25 = load %struct.Random_struct*, %struct.Random_struct** %7, align 4
  ret %struct.Random_struct* %25
}

; Function Attrs: noinline nounwind optnone
define dso_local void @Random_delete(%struct.Random_struct* %0) #0 {
  %2 = alloca %struct.Random_struct*, align 4
  store %struct.Random_struct* %0, %struct.Random_struct** %2, align 4
  %3 = load %struct.Random_struct*, %struct.Random_struct** %2, align 4
  %4 = bitcast %struct.Random_struct* %3 to i8*
  call void @free(i8* %4) #7
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local double @Random_nextDouble(%struct.Random_struct* %0) #0 {
  %2 = alloca double, align 8
  %3 = alloca %struct.Random_struct*, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 4
  store %struct.Random_struct* %0, %struct.Random_struct** %3, align 4
  %8 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %9 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %8, i32 0, i32 2
  %10 = load i32, i32* %9, align 8
  store i32 %10, i32* %5, align 4
  %11 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %12 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %11, i32 0, i32 3
  %13 = load i32, i32* %12, align 4
  store i32 %13, i32* %6, align 4
  %14 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %15 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %14, i32 0, i32 0
  %16 = getelementptr inbounds [17 x i32], [17 x i32]* %15, i32 0, i32 0
  store i32* %16, i32** %7, align 4
  %17 = load i32*, i32** %7, align 4
  %18 = load i32, i32* %5, align 4
  %19 = getelementptr inbounds i32, i32* %17, i32 %18
  %20 = load i32, i32* %19, align 4
  %21 = load i32*, i32** %7, align 4
  %22 = load i32, i32* %6, align 4
  %23 = getelementptr inbounds i32, i32* %21, i32 %22
  %24 = load i32, i32* %23, align 4
  %25 = sub nsw i32 %20, %24
  store i32 %25, i32* %4, align 4
  %26 = load i32, i32* %4, align 4
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %28, label %31

28:                                               ; preds = %1
  %29 = load i32, i32* %4, align 4
  %30 = add nsw i32 %29, 2147483647
  store i32 %30, i32* %4, align 4
  br label %31

31:                                               ; preds = %28, %1
  %32 = load i32, i32* %4, align 4
  %33 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %34 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %33, i32 0, i32 0
  %35 = load i32, i32* %6, align 4
  %36 = getelementptr inbounds [17 x i32], [17 x i32]* %34, i32 0, i32 %35
  store i32 %32, i32* %36, align 4
  %37 = load i32, i32* %5, align 4
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %39, label %40

39:                                               ; preds = %31
  store i32 16, i32* %5, align 4
  br label %43

40:                                               ; preds = %31
  %41 = load i32, i32* %5, align 4
  %42 = add nsw i32 %41, -1
  store i32 %42, i32* %5, align 4
  br label %43

43:                                               ; preds = %40, %39
  %44 = load i32, i32* %5, align 4
  %45 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %46 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %45, i32 0, i32 2
  store i32 %44, i32* %46, align 8
  %47 = load i32, i32* %6, align 4
  %48 = icmp eq i32 %47, 0
  br i1 %48, label %49, label %50

49:                                               ; preds = %43
  store i32 16, i32* %6, align 4
  br label %53

50:                                               ; preds = %43
  %51 = load i32, i32* %6, align 4
  %52 = add nsw i32 %51, -1
  store i32 %52, i32* %6, align 4
  br label %53

53:                                               ; preds = %50, %49
  %54 = load i32, i32* %6, align 4
  %55 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %56 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %55, i32 0, i32 3
  store i32 %54, i32* %56, align 4
  %57 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %58 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %57, i32 0, i32 4
  %59 = load i32, i32* %58, align 8
  %60 = icmp ne i32 %59, 0
  br i1 %60, label %61, label %74

61:                                               ; preds = %53
  %62 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %63 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %62, i32 0, i32 5
  %64 = load double, double* %63, align 8
  %65 = load double, double* @dm1, align 8
  %66 = load i32, i32* %4, align 4
  %67 = sitofp i32 %66 to double
  %68 = fmul double %65, %67
  %69 = load %struct.Random_struct*, %struct.Random_struct** %3, align 4
  %70 = getelementptr inbounds %struct.Random_struct, %struct.Random_struct* %69, i32 0, i32 7
  %71 = load double, double* %70, align 8
  %72 = fmul double %68, %71
  %73 = fadd double %64, %72
  store double %73, double* %2, align 8
  br label %79

74:                                               ; preds = %53
  %75 = load double, double* @dm1, align 8
  %76 = load i32, i32* %4, align 4
  %77 = sitofp i32 %76 to double
  %78 = fmul double %75, %77
  store double %78, double* %2, align 8
  br label %79

79:                                               ; preds = %74, %61
  %80 = load double, double* %2, align 8
  ret double %80
}

; Function Attrs: noinline nounwind optnone
define dso_local double* @RandomVector(i32 signext %0, %struct.Random_struct* %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.Random_struct*, align 4
  %5 = alloca i32, align 4
  %6 = alloca double*, align 4
  store i32 %0, i32* %3, align 4
  store %struct.Random_struct* %1, %struct.Random_struct** %4, align 4
  %7 = load i32, i32* %3, align 4
  %8 = mul i32 8, %7
  %9 = call noalias i8* @malloc(i32 signext %8) #7
  %10 = bitcast i8* %9 to double*
  store double* %10, double** %6, align 4
  store i32 0, i32* %5, align 4
  br label %11

11:                                               ; preds = %21, %2
  %12 = load i32, i32* %5, align 4
  %13 = load i32, i32* %3, align 4
  %14 = icmp slt i32 %12, %13
  br i1 %14, label %15, label %24

15:                                               ; preds = %11
  %16 = load %struct.Random_struct*, %struct.Random_struct** %4, align 4
  %17 = call double @Random_nextDouble(%struct.Random_struct* %16)
  %18 = load double*, double** %6, align 4
  %19 = load i32, i32* %5, align 4
  %20 = getelementptr inbounds double, double* %18, i32 %19
  store double %17, double* %20, align 8
  br label %21

21:                                               ; preds = %15
  %22 = load i32, i32* %5, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %5, align 4
  br label %11

24:                                               ; preds = %11
  %25 = load double*, double** %6, align 4
  ret double* %25
}

; Function Attrs: noinline nounwind optnone
define dso_local double** @RandomMatrix(i32 signext %0, i32 signext %1, %struct.Random_struct* %2) #0 {
  %4 = alloca double**, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct.Random_struct*, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca double**, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store %struct.Random_struct* %2, %struct.Random_struct** %7, align 4
  %11 = load i32, i32* %5, align 4
  %12 = mul i32 4, %11
  %13 = call noalias i8* @malloc(i32 signext %12) #7
  %14 = bitcast i8* %13 to double**
  store double** %14, double*** %10, align 4
  %15 = load double**, double*** %10, align 4
  %16 = icmp eq double** %15, null
  br i1 %16, label %17, label %18

17:                                               ; preds = %3
  store double** null, double*** %4, align 4
  br label %62

18:                                               ; preds = %3
  store i32 0, i32* %8, align 4
  br label %19

19:                                               ; preds = %57, %18
  %20 = load i32, i32* %8, align 4
  %21 = load i32, i32* %5, align 4
  %22 = icmp slt i32 %20, %21
  br i1 %22, label %23, label %60

23:                                               ; preds = %19
  %24 = load i32, i32* %6, align 4
  %25 = mul i32 8, %24
  %26 = call noalias i8* @malloc(i32 signext %25) #7
  %27 = bitcast i8* %26 to double*
  %28 = load double**, double*** %10, align 4
  %29 = load i32, i32* %8, align 4
  %30 = getelementptr inbounds double*, double** %28, i32 %29
  store double* %27, double** %30, align 4
  %31 = load double**, double*** %10, align 4
  %32 = load i32, i32* %8, align 4
  %33 = getelementptr inbounds double*, double** %31, i32 %32
  %34 = load double*, double** %33, align 4
  %35 = icmp eq double* %34, null
  br i1 %35, label %36, label %39

36:                                               ; preds = %23
  %37 = load double**, double*** %10, align 4
  %38 = bitcast double** %37 to i8*
  call void @free(i8* %38) #7
  store double** null, double*** %4, align 4
  br label %62

39:                                               ; preds = %23
  store i32 0, i32* %9, align 4
  br label %40

40:                                               ; preds = %53, %39
  %41 = load i32, i32* %9, align 4
  %42 = load i32, i32* %6, align 4
  %43 = icmp slt i32 %41, %42
  br i1 %43, label %44, label %56

44:                                               ; preds = %40
  %45 = load %struct.Random_struct*, %struct.Random_struct** %7, align 4
  %46 = call double @Random_nextDouble(%struct.Random_struct* %45)
  %47 = load double**, double*** %10, align 4
  %48 = load i32, i32* %8, align 4
  %49 = getelementptr inbounds double*, double** %47, i32 %48
  %50 = load double*, double** %49, align 4
  %51 = load i32, i32* %9, align 4
  %52 = getelementptr inbounds double, double* %50, i32 %51
  store double %46, double* %52, align 8
  br label %53

53:                                               ; preds = %44
  %54 = load i32, i32* %9, align 4
  %55 = add nsw i32 %54, 1
  store i32 %55, i32* %9, align 4
  br label %40

56:                                               ; preds = %40
  br label %57

57:                                               ; preds = %56
  %58 = load i32, i32* %8, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %8, align 4
  br label %19

60:                                               ; preds = %19
  %61 = load double**, double*** %10, align 4
  store double** %61, double*** %4, align 4
  br label %62

62:                                               ; preds = %60, %36, %17
  %63 = load double**, double*** %4, align 4
  ret double** %63
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @main(i32 signext %0, i8** %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 4
  %6 = alloca double, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca [6 x double], align 8
  %14 = alloca %struct.Random_struct*, align 4
  %15 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 4
  store double 2.000000e+00, double* %6, align 8
  store i32 1024, i32* %7, align 4
  store i32 100, i32* %8, align 4
  store i32 1000, i32* %9, align 4
  store i32 5000, i32* %10, align 4
  store i32 100, i32* %11, align 4
  %16 = bitcast [6 x double]* %13 to i8*
  call void @llvm.memset.p0i8.i32(i8* align 8 %16, i8 0, i32 48, i1 false)
  %17 = call %struct.Random_struct* @new_Random_seed(i32 signext 101010)
  store %struct.Random_struct* %17, %struct.Random_struct** %14, align 4
  %18 = load i32, i32* %4, align 4
  %19 = icmp sgt i32 %18, 1
  br i1 %19, label %20, label %55

20:                                               ; preds = %2
  store i32 1, i32* %15, align 4
  %21 = load i8**, i8*** %5, align 4
  %22 = getelementptr inbounds i8*, i8** %21, i32 1
  %23 = load i8*, i8** %22, align 4
  %24 = call i32 @strcmp(i8* %23, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.27, i32 0, i32 0)) #9
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %32, label %26

26:                                               ; preds = %20
  %27 = load i8**, i8*** %5, align 4
  %28 = getelementptr inbounds i8*, i8** %27, i32 1
  %29 = load i8*, i8** %28, align 4
  %30 = call i32 @strcmp(i8* %29, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1.28, i32 0, i32 0)) #9
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %32, label %35

32:                                               ; preds = %26, %20
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4
  %34 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.2.29, i32 0, i32 0))
  call void @exit(i32 signext 0) #8
  unreachable

35:                                               ; preds = %26
  %36 = load i8**, i8*** %5, align 4
  %37 = getelementptr inbounds i8*, i8** %36, i32 1
  %38 = load i8*, i8** %37, align 4
  %39 = call i32 @strcmp(i8* %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3.30, i32 0, i32 0)) #9
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %41, label %44

41:                                               ; preds = %35
  store i32 1048576, i32* %7, align 4
  store i32 1000, i32* %8, align 4
  store i32 100000, i32* %9, align 4
  store i32 1000000, i32* %10, align 4
  store i32 1000, i32* %11, align 4
  %42 = load i32, i32* %15, align 4
  %43 = add nsw i32 %42, 1
  store i32 %43, i32* %15, align 4
  br label %44

44:                                               ; preds = %41, %35
  %45 = load i32, i32* %15, align 4
  %46 = load i32, i32* %4, align 4
  %47 = icmp slt i32 %45, %46
  br i1 %47, label %48, label %54

48:                                               ; preds = %44
  %49 = load i8**, i8*** %5, align 4
  %50 = load i32, i32* %15, align 4
  %51 = getelementptr inbounds i8*, i8** %49, i32 %50
  %52 = load i8*, i8** %51, align 4
  %53 = call double @atof(i8* %52) #9
  store double %53, double* %6, align 8
  br label %54

54:                                               ; preds = %48, %44
  br label %55

55:                                               ; preds = %54, %2
  call void @print_banner()
  %56 = load double, double* %6, align 8
  %57 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.4.31, i32 0, i32 0), double %56)
  %58 = load i32, i32* %7, align 4
  %59 = load double, double* %6, align 8
  %60 = load %struct.Random_struct*, %struct.Random_struct** %14, align 4
  %61 = call double @kernel_measureFFT(i32 signext %58, double %59, %struct.Random_struct* %60)
  %62 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 1
  store double %61, double* %62, align 8
  %63 = load i32, i32* %8, align 4
  %64 = load double, double* %6, align 8
  %65 = load %struct.Random_struct*, %struct.Random_struct** %14, align 4
  %66 = call double @kernel_measureSOR(i32 signext %63, double %64, %struct.Random_struct* %65)
  %67 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 2
  store double %66, double* %67, align 8
  %68 = load double, double* %6, align 8
  %69 = load %struct.Random_struct*, %struct.Random_struct** %14, align 4
  %70 = call double @kernel_measureMonteCarlo(double %68, %struct.Random_struct* %69)
  %71 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 3
  store double %70, double* %71, align 8
  %72 = load i32, i32* %9, align 4
  %73 = load i32, i32* %10, align 4
  %74 = load double, double* %6, align 8
  %75 = load %struct.Random_struct*, %struct.Random_struct** %14, align 4
  %76 = call double @kernel_measureSparseMatMult(i32 signext %72, i32 signext %73, double %74, %struct.Random_struct* %75)
  %77 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 4
  store double %76, double* %77, align 8
  %78 = load i32, i32* %11, align 4
  %79 = load double, double* %6, align 8
  %80 = load %struct.Random_struct*, %struct.Random_struct** %14, align 4
  %81 = call double @kernel_measureLU(i32 signext %78, double %79, %struct.Random_struct* %80)
  %82 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 5
  store double %81, double* %82, align 8
  store i32 10000000, i32* %12, align 4
  %83 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 1
  %84 = load double, double* %83, align 8
  %85 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 2
  %86 = load double, double* %85, align 8
  %87 = fadd double %84, %86
  %88 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 3
  %89 = load double, double* %88, align 8
  %90 = fadd double %87, %89
  %91 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 4
  %92 = load double, double* %91, align 8
  %93 = fadd double %90, %92
  %94 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 5
  %95 = load double, double* %94, align 8
  %96 = fadd double %93, %95
  %97 = fdiv double %96, 5.000000e+00
  %98 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 0
  store double %97, double* %98, align 8
  %99 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.5.32, i32 0, i32 0))
  %100 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 0
  %101 = load double, double* %100, align 8
  %102 = load i32, i32* %12, align 4
  %103 = sitofp i32 %102 to double
  %104 = fdiv double %101, %103
  %105 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.6.33, i32 0, i32 0), double %104)
  %106 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 1
  %107 = load double, double* %106, align 8
  %108 = load i32, i32* %12, align 4
  %109 = sitofp i32 %108 to double
  %110 = fdiv double %107, %109
  %111 = load i32, i32* %7, align 4
  %112 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.7.34, i32 0, i32 0), double %110, i32 signext %111)
  %113 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 2
  %114 = load double, double* %113, align 8
  %115 = load i32, i32* %12, align 4
  %116 = sitofp i32 %115 to double
  %117 = fdiv double %114, %116
  %118 = load i32, i32* %8, align 4
  %119 = load i32, i32* %8, align 4
  %120 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.8.35, i32 0, i32 0), double %117, i32 signext %118, i32 signext %119)
  %121 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 3
  %122 = load double, double* %121, align 8
  %123 = load i32, i32* %12, align 4
  %124 = sitofp i32 %123 to double
  %125 = fdiv double %122, %124
  %126 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.9, i32 0, i32 0), double %125)
  %127 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 4
  %128 = load double, double* %127, align 8
  %129 = load i32, i32* %12, align 4
  %130 = sitofp i32 %129 to double
  %131 = fdiv double %128, %130
  %132 = load i32, i32* %9, align 4
  %133 = load i32, i32* %10, align 4
  %134 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @.str.10, i32 0, i32 0), double %131, i32 signext %132, i32 signext %133)
  %135 = getelementptr inbounds [6 x double], [6 x double]* %13, i32 0, i32 5
  %136 = load double, double* %135, align 8
  %137 = load i32, i32* %12, align 4
  %138 = sitofp i32 %137 to double
  %139 = fdiv double %136, %138
  %140 = load i32, i32* %11, align 4
  %141 = load i32, i32* %11, align 4
  %142 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([47 x i8], [47 x i8]* @.str.11, i32 0, i32 0), double %139, i32 signext %140, i32 signext %141)
  %143 = load %struct.Random_struct*, %struct.Random_struct** %14, align 4
  call void @Random_delete(%struct.Random_struct* %143)
  ret i32 0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1 immarg) #5

; Function Attrs: nounwind readonly
declare dso_local i32 @strcmp(i8*, i8*) #6

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: nounwind readonly
declare dso_local double @atof(i8*) #6

; Function Attrs: noinline nounwind optnone
define dso_local void @print_banner() #0 {
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([68 x i8], [68 x i8]* @.str.12, i32 0, i32 0))
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([68 x i8], [68 x i8]* @.str.13, i32 0, i32 0))
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([68 x i8], [68 x i8]* @.str.14, i32 0, i32 0))
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([68 x i8], [68 x i8]* @.str.12, i32 0, i32 0))
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local double @SOR_num_flops(i32 signext %0, i32 signext %1, i32 signext %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  %9 = alloca double, align 8
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %10 = load i32, i32* %4, align 4
  %11 = sitofp i32 %10 to double
  store double %11, double* %7, align 8
  %12 = load i32, i32* %5, align 4
  %13 = sitofp i32 %12 to double
  store double %13, double* %8, align 8
  %14 = load i32, i32* %6, align 4
  %15 = sitofp i32 %14 to double
  store double %15, double* %9, align 8
  %16 = load double, double* %7, align 8
  %17 = fsub double %16, 1.000000e+00
  %18 = load double, double* %8, align 8
  %19 = fsub double %18, 1.000000e+00
  %20 = fmul double %17, %19
  %21 = load double, double* %9, align 8
  %22 = fmul double %20, %21
  %23 = fmul double %22, 6.000000e+00
  ret double %23
}

; Function Attrs: noinline nounwind optnone
define dso_local void @SOR_execute(i32 signext %0, i32 signext %1, double %2, double** %3, i32 signext %4) #0 {
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca double, align 8
  %9 = alloca double**, align 4
  %10 = alloca i32, align 4
  %11 = alloca double, align 8
  %12 = alloca double, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca double*, align 4
  %19 = alloca double*, align 4
  %20 = alloca double*, align 4
  store i32 %0, i32* %6, align 4
  store i32 %1, i32* %7, align 4
  store double %2, double* %8, align 8
  store double** %3, double*** %9, align 4
  store i32 %4, i32* %10, align 4
  %21 = load double, double* %8, align 8
  %22 = fmul double %21, 2.500000e-01
  store double %22, double* %11, align 8
  %23 = load double, double* %8, align 8
  %24 = fsub double 1.000000e+00, %23
  store double %24, double* %12, align 8
  %25 = load i32, i32* %6, align 4
  %26 = sub nsw i32 %25, 1
  store i32 %26, i32* %13, align 4
  %27 = load i32, i32* %7, align 4
  %28 = sub nsw i32 %27, 1
  store i32 %28, i32* %14, align 4
  store i32 0, i32* %15, align 4
  br label %29

29:                                               ; preds = %99, %5
  %30 = load i32, i32* %15, align 4
  %31 = load i32, i32* %10, align 4
  %32 = icmp slt i32 %30, %31
  br i1 %32, label %33, label %102

33:                                               ; preds = %29
  store i32 1, i32* %16, align 4
  br label %34

34:                                               ; preds = %95, %33
  %35 = load i32, i32* %16, align 4
  %36 = load i32, i32* %13, align 4
  %37 = icmp slt i32 %35, %36
  br i1 %37, label %38, label %98

38:                                               ; preds = %34
  %39 = load double**, double*** %9, align 4
  %40 = load i32, i32* %16, align 4
  %41 = getelementptr inbounds double*, double** %39, i32 %40
  %42 = load double*, double** %41, align 4
  store double* %42, double** %18, align 4
  %43 = load double**, double*** %9, align 4
  %44 = load i32, i32* %16, align 4
  %45 = sub nsw i32 %44, 1
  %46 = getelementptr inbounds double*, double** %43, i32 %45
  %47 = load double*, double** %46, align 4
  store double* %47, double** %19, align 4
  %48 = load double**, double*** %9, align 4
  %49 = load i32, i32* %16, align 4
  %50 = add nsw i32 %49, 1
  %51 = getelementptr inbounds double*, double** %48, i32 %50
  %52 = load double*, double** %51, align 4
  store double* %52, double** %20, align 4
  store i32 1, i32* %17, align 4
  br label %53

53:                                               ; preds = %91, %38
  %54 = load i32, i32* %17, align 4
  %55 = load i32, i32* %14, align 4
  %56 = icmp slt i32 %54, %55
  br i1 %56, label %57, label %94

57:                                               ; preds = %53
  %58 = load double, double* %11, align 8
  %59 = load double*, double** %19, align 4
  %60 = load i32, i32* %17, align 4
  %61 = getelementptr inbounds double, double* %59, i32 %60
  %62 = load double, double* %61, align 8
  %63 = load double*, double** %20, align 4
  %64 = load i32, i32* %17, align 4
  %65 = getelementptr inbounds double, double* %63, i32 %64
  %66 = load double, double* %65, align 8
  %67 = fadd double %62, %66
  %68 = load double*, double** %18, align 4
  %69 = load i32, i32* %17, align 4
  %70 = sub nsw i32 %69, 1
  %71 = getelementptr inbounds double, double* %68, i32 %70
  %72 = load double, double* %71, align 8
  %73 = fadd double %67, %72
  %74 = load double*, double** %18, align 4
  %75 = load i32, i32* %17, align 4
  %76 = add nsw i32 %75, 1
  %77 = getelementptr inbounds double, double* %74, i32 %76
  %78 = load double, double* %77, align 8
  %79 = fadd double %73, %78
  %80 = fmul double %58, %79
  %81 = load double, double* %12, align 8
  %82 = load double*, double** %18, align 4
  %83 = load i32, i32* %17, align 4
  %84 = getelementptr inbounds double, double* %82, i32 %83
  %85 = load double, double* %84, align 8
  %86 = fmul double %81, %85
  %87 = fadd double %80, %86
  %88 = load double*, double** %18, align 4
  %89 = load i32, i32* %17, align 4
  %90 = getelementptr inbounds double, double* %88, i32 %89
  store double %87, double* %90, align 8
  br label %91

91:                                               ; preds = %57
  %92 = load i32, i32* %17, align 4
  %93 = add nsw i32 %92, 1
  store i32 %93, i32* %17, align 4
  br label %53

94:                                               ; preds = %53
  br label %95

95:                                               ; preds = %94
  %96 = load i32, i32* %16, align 4
  %97 = add nsw i32 %96, 1
  store i32 %97, i32* %16, align 4
  br label %34

98:                                               ; preds = %34
  br label %99

99:                                               ; preds = %98
  %100 = load i32, i32* %15, align 4
  %101 = add nsw i32 %100, 1
  store i32 %101, i32* %15, align 4
  br label %29

102:                                              ; preds = %29
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local double @SparseCompRow_num_flops(i32 signext %0, i32 signext %1, i32 signext %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %8 = load i32, i32* %5, align 4
  %9 = load i32, i32* %4, align 4
  %10 = sdiv i32 %8, %9
  %11 = load i32, i32* %4, align 4
  %12 = mul nsw i32 %10, %11
  store i32 %12, i32* %7, align 4
  %13 = load i32, i32* %7, align 4
  %14 = sitofp i32 %13 to double
  %15 = fmul double %14, 2.000000e+00
  %16 = load i32, i32* %6, align 4
  %17 = sitofp i32 %16 to double
  %18 = fmul double %15, %17
  ret double %18
}

; Function Attrs: noinline nounwind optnone
define dso_local void @SparseCompRow_matmult(i32 signext %0, double* %1, double* %2, i32* %3, i32* %4, double* %5, i32 signext %6) #0 {
  %8 = alloca i32, align 4
  %9 = alloca double*, align 4
  %10 = alloca double*, align 4
  %11 = alloca i32*, align 4
  %12 = alloca i32*, align 4
  %13 = alloca double*, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca double, align 8
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  store i32 %0, i32* %8, align 4
  store double* %1, double** %9, align 4
  store double* %2, double** %10, align 4
  store i32* %3, i32** %11, align 4
  store i32* %4, i32** %12, align 4
  store double* %5, double** %13, align 4
  store i32 %6, i32* %14, align 4
  store i32 0, i32* %15, align 4
  br label %21

21:                                               ; preds = %72, %7
  %22 = load i32, i32* %15, align 4
  %23 = load i32, i32* %14, align 4
  %24 = icmp slt i32 %22, %23
  br i1 %24, label %25, label %75

25:                                               ; preds = %21
  store i32 0, i32* %16, align 4
  br label %26

26:                                               ; preds = %68, %25
  %27 = load i32, i32* %16, align 4
  %28 = load i32, i32* %8, align 4
  %29 = icmp slt i32 %27, %28
  br i1 %29, label %30, label %71

30:                                               ; preds = %26
  store double 0.000000e+00, double* %18, align 8
  %31 = load i32*, i32** %11, align 4
  %32 = load i32, i32* %16, align 4
  %33 = getelementptr inbounds i32, i32* %31, i32 %32
  %34 = load i32, i32* %33, align 4
  store i32 %34, i32* %19, align 4
  %35 = load i32*, i32** %11, align 4
  %36 = load i32, i32* %16, align 4
  %37 = add nsw i32 %36, 1
  %38 = getelementptr inbounds i32, i32* %35, i32 %37
  %39 = load i32, i32* %38, align 4
  store i32 %39, i32* %20, align 4
  %40 = load i32, i32* %19, align 4
  store i32 %40, i32* %17, align 4
  br label %41

41:                                               ; preds = %60, %30
  %42 = load i32, i32* %17, align 4
  %43 = load i32, i32* %20, align 4
  %44 = icmp slt i32 %42, %43
  br i1 %44, label %45, label %63

45:                                               ; preds = %41
  %46 = load double*, double** %13, align 4
  %47 = load i32*, i32** %12, align 4
  %48 = load i32, i32* %17, align 4
  %49 = getelementptr inbounds i32, i32* %47, i32 %48
  %50 = load i32, i32* %49, align 4
  %51 = getelementptr inbounds double, double* %46, i32 %50
  %52 = load double, double* %51, align 8
  %53 = load double*, double** %10, align 4
  %54 = load i32, i32* %17, align 4
  %55 = getelementptr inbounds double, double* %53, i32 %54
  %56 = load double, double* %55, align 8
  %57 = fmul double %52, %56
  %58 = load double, double* %18, align 8
  %59 = fadd double %58, %57
  store double %59, double* %18, align 8
  br label %60

60:                                               ; preds = %45
  %61 = load i32, i32* %17, align 4
  %62 = add nsw i32 %61, 1
  store i32 %62, i32* %17, align 4
  br label %41

63:                                               ; preds = %41
  %64 = load double, double* %18, align 8
  %65 = load double*, double** %9, align 4
  %66 = load i32, i32* %16, align 4
  %67 = getelementptr inbounds double, double* %65, i32 %66
  store double %64, double* %67, align 8
  br label %68

68:                                               ; preds = %63
  %69 = load i32, i32* %16, align 4
  %70 = add nsw i32 %69, 1
  store i32 %70, i32* %16, align 4
  br label %26

71:                                               ; preds = %26
  br label %72

72:                                               ; preds = %71
  %73 = load i32, i32* %15, align 4
  %74 = add nsw i32 %73, 1
  store i32 %74, i32* %15, align 4
  br label %21

75:                                               ; preds = %21
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local double @seconds() #0 {
  %1 = load double, double* @seconds.t, align 8
  %2 = fadd double %1, 1.000000e+00
  store double %2, double* @seconds.t, align 8
  ret double %2
}

; Function Attrs: noinline nounwind optnone
define dso_local void @Stopwtach_reset(%struct.Stopwatch_struct* %0) #0 {
  %2 = alloca %struct.Stopwatch_struct*, align 4
  store %struct.Stopwatch_struct* %0, %struct.Stopwatch_struct** %2, align 4
  %3 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %4 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %3, i32 0, i32 0
  store i32 0, i32* %4, align 8
  %5 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %6 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %5, i32 0, i32 1
  store double 0.000000e+00, double* %6, align 8
  %7 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %8 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %7, i32 0, i32 2
  store double 0.000000e+00, double* %8, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local %struct.Stopwatch_struct* @new_Stopwatch() #0 {
  %1 = alloca %struct.Stopwatch_struct*, align 4
  %2 = alloca %struct.Stopwatch_struct*, align 4
  %3 = call noalias i8* @malloc(i32 signext 24) #7
  %4 = bitcast i8* %3 to %struct.Stopwatch_struct*
  store %struct.Stopwatch_struct* %4, %struct.Stopwatch_struct** %2, align 4
  %5 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %6 = icmp eq %struct.Stopwatch_struct* %5, null
  br i1 %6, label %7, label %8

7:                                                ; preds = %0
  store %struct.Stopwatch_struct* null, %struct.Stopwatch_struct** %1, align 4
  br label %11

8:                                                ; preds = %0
  %9 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  call void @Stopwtach_reset(%struct.Stopwatch_struct* %9)
  %10 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  store %struct.Stopwatch_struct* %10, %struct.Stopwatch_struct** %1, align 4
  br label %11

11:                                               ; preds = %8, %7
  %12 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %1, align 4
  ret %struct.Stopwatch_struct* %12
}

; Function Attrs: noinline nounwind optnone
define dso_local void @Stopwatch_delete(%struct.Stopwatch_struct* %0) #0 {
  %2 = alloca %struct.Stopwatch_struct*, align 4
  store %struct.Stopwatch_struct* %0, %struct.Stopwatch_struct** %2, align 4
  %3 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %4 = icmp ne %struct.Stopwatch_struct* %3, null
  br i1 %4, label %5, label %8

5:                                                ; preds = %1
  %6 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %7 = bitcast %struct.Stopwatch_struct* %6 to i8*
  call void @free(i8* %7) #7
  br label %8

8:                                                ; preds = %5, %1
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @Stopwatch_start(%struct.Stopwatch_struct* %0) #0 {
  %2 = alloca %struct.Stopwatch_struct*, align 4
  store %struct.Stopwatch_struct* %0, %struct.Stopwatch_struct** %2, align 4
  %3 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %4 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %3, i32 0, i32 0
  %5 = load i32, i32* %4, align 8
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %15, label %7

7:                                                ; preds = %1
  %8 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %9 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %8, i32 0, i32 0
  store i32 1, i32* %9, align 8
  %10 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %11 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %10, i32 0, i32 2
  store double 0.000000e+00, double* %11, align 8
  %12 = call double @seconds()
  %13 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %14 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %13, i32 0, i32 1
  store double %12, double* %14, align 8
  br label %15

15:                                               ; preds = %7, %1
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @Stopwatch_resume(%struct.Stopwatch_struct* %0) #0 {
  %2 = alloca %struct.Stopwatch_struct*, align 4
  store %struct.Stopwatch_struct* %0, %struct.Stopwatch_struct** %2, align 4
  %3 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %4 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %3, i32 0, i32 0
  %5 = load i32, i32* %4, align 8
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %13, label %7

7:                                                ; preds = %1
  %8 = call double @seconds()
  %9 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %10 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %9, i32 0, i32 1
  store double %8, double* %10, align 8
  %11 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %12 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %11, i32 0, i32 0
  store i32 1, i32* %12, align 8
  br label %13

13:                                               ; preds = %7, %1
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @Stopwatch_stop(%struct.Stopwatch_struct* %0) #0 {
  %2 = alloca %struct.Stopwatch_struct*, align 4
  store %struct.Stopwatch_struct* %0, %struct.Stopwatch_struct** %2, align 4
  %3 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %4 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %3, i32 0, i32 0
  %5 = load i32, i32* %4, align 8
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %7, label %19

7:                                                ; preds = %1
  %8 = call double @seconds()
  %9 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %10 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %9, i32 0, i32 1
  %11 = load double, double* %10, align 8
  %12 = fsub double %8, %11
  %13 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %14 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %13, i32 0, i32 2
  %15 = load double, double* %14, align 8
  %16 = fadd double %15, %12
  store double %16, double* %14, align 8
  %17 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %18 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %17, i32 0, i32 0
  store i32 0, i32* %18, align 8
  br label %19

19:                                               ; preds = %7, %1
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local double @Stopwatch_read(%struct.Stopwatch_struct* %0) #0 {
  %2 = alloca %struct.Stopwatch_struct*, align 4
  %3 = alloca double, align 8
  store %struct.Stopwatch_struct* %0, %struct.Stopwatch_struct** %2, align 4
  %4 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %5 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %4, i32 0, i32 0
  %6 = load i32, i32* %5, align 8
  %7 = icmp ne i32 %6, 0
  br i1 %7, label %8, label %22

8:                                                ; preds = %1
  %9 = call double @seconds()
  store double %9, double* %3, align 8
  %10 = load double, double* %3, align 8
  %11 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %12 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %11, i32 0, i32 1
  %13 = load double, double* %12, align 8
  %14 = fsub double %10, %13
  %15 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %16 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %15, i32 0, i32 2
  %17 = load double, double* %16, align 8
  %18 = fadd double %17, %14
  store double %18, double* %16, align 8
  %19 = load double, double* %3, align 8
  %20 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %21 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %20, i32 0, i32 1
  store double %19, double* %21, align 8
  br label %22

22:                                               ; preds = %8, %1
  %23 = load %struct.Stopwatch_struct*, %struct.Stopwatch_struct** %2, align 4
  %24 = getelementptr inbounds %struct.Stopwatch_struct, %struct.Stopwatch_struct* %23, i32 0, i32 2
  %25 = load double, double* %24, align 8
  ret double %25
}

; Function Attrs: noinline nounwind optnone
define dso_local void @trans_init() #0 {
  %1 = call i32 bitcast (i32 (...)* @play_init to i32 ()*)()
  %2 = call noalias i8* @calloc(i32 signext 1050011, i32 signext 4) #7
  %3 = bitcast i8* %2 to i32*
  store i32* %3, i32** @ht, align 4
  %4 = call noalias i8* @calloc(i32 signext 1050011, i32 signext 1) #7
  store i8* %4, i8** @he, align 4
  %5 = load i32*, i32** @ht, align 4
  %6 = icmp eq i32* %5, null
  br i1 %6, label %10, label %7

7:                                                ; preds = %0
  %8 = load i8*, i8** @he, align 4
  %9 = icmp eq i8* %8, null
  br i1 %9, label %10, label %12

10:                                               ; preds = %7, %0
  %11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.58, i32 0, i32 0), i32 signext 5250055)
  call void @exit(i32 signext 0) #8
  unreachable

12:                                               ; preds = %7
  ret void
}

declare dso_local i32 @play_init(...) #2

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i32 signext, i32 signext) #1

; Function Attrs: noinline nounwind optnone
define dso_local void @emptyTT() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %4

4:                                                ; preds = %30, %0
  %5 = load i32, i32* %1, align 4
  %6 = icmp slt i32 %5, 1050011
  br i1 %6, label %7, label %33

7:                                                ; preds = %4
  %8 = load i8*, i8** @he, align 4
  %9 = load i32, i32* %1, align 4
  %10 = getelementptr inbounds i8, i8* %8, i32 %9
  %11 = load i8, i8* %10, align 1
  %12 = sext i8 %11 to i32
  store i32 %12, i32* %2, align 4
  %13 = and i32 %12, 31
  store i32 %13, i32* %3, align 4
  %14 = icmp slt i32 %13, 31
  br i1 %14, label %15, label %29

15:                                               ; preds = %7
  %16 = load i32, i32* %2, align 4
  %17 = load i32, i32* %3, align 4
  %18 = icmp slt i32 %17, 16
  br i1 %18, label %19, label %21

19:                                               ; preds = %15
  %20 = load i32, i32* %3, align 4
  br label %22

21:                                               ; preds = %15
  br label %22

22:                                               ; preds = %21, %19
  %23 = phi i32 [ %20, %19 ], [ 4, %21 ]
  %24 = sub nsw i32 %16, %23
  %25 = trunc i32 %24 to i8
  %26 = load i8*, i8** @he, align 4
  %27 = load i32, i32* %1, align 4
  %28 = getelementptr inbounds i8, i8* %26, i32 %27
  store i8 %25, i8* %28, align 1
  br label %29

29:                                               ; preds = %22, %7
  br label %30

30:                                               ; preds = %29
  %31 = load i32, i32* %1, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %1, align 4
  br label %4

33:                                               ; preds = %4
  store i64 0, i64* @hits, align 8
  store i64 0, i64* @posed, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local double @hitRate() #0 {
  %1 = load i64, i64* @posed, align 8
  %2 = icmp ne i64 %1, 0
  br i1 %2, label %3, label %9

3:                                                ; preds = %0
  %4 = load i64, i64* @hits, align 8
  %5 = sitofp i64 %4 to double
  %6 = load i64, i64* @posed, align 8
  %7 = sitofp i64 %6 to double
  %8 = fdiv double %5, %7
  br label %10

9:                                                ; preds = %0
  br label %10

10:                                               ; preds = %9, %3
  %11 = phi double [ %8, %3 ], [ 0.000000e+00, %9 ]
  ret double %11
}

; Function Attrs: noinline nounwind optnone
define dso_local void @hash() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 1), align 4
  %5 = shl i32 %4, 7
  %6 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 2), align 4
  %7 = or i32 %5, %6
  %8 = shl i32 %7, 7
  %9 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 3), align 4
  %10 = or i32 %8, %9
  store i32 %10, i32* %1, align 4
  %11 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 7), align 4
  %12 = shl i32 %11, 7
  %13 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 6), align 4
  %14 = or i32 %12, %13
  %15 = shl i32 %14, 7
  %16 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 5), align 4
  %17 = or i32 %15, %16
  store i32 %17, i32* %2, align 4
  %18 = load i32, i32* %1, align 4
  %19 = load i32, i32* %2, align 4
  %20 = icmp ugt i32 %18, %19
  br i1 %20, label %21, label %31

21:                                               ; preds = %0
  %22 = load i32, i32* %1, align 4
  %23 = shl i32 %22, 7
  %24 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 4), align 4
  %25 = or i32 %23, %24
  %26 = zext i32 %25 to i64
  %27 = shl i64 %26, 21
  %28 = load i32, i32* %2, align 4
  %29 = zext i32 %28 to i64
  %30 = or i64 %27, %29
  br label %41

31:                                               ; preds = %0
  %32 = load i32, i32* %2, align 4
  %33 = shl i32 %32, 7
  %34 = load i32, i32* getelementptr inbounds ([0 x i32], [0 x i32]* @columns, i32 0, i32 4), align 4
  %35 = or i32 %33, %34
  %36 = zext i32 %35 to i64
  %37 = shl i64 %36, 21
  %38 = load i32, i32* %1, align 4
  %39 = zext i32 %38 to i64
  %40 = or i64 %37, %39
  br label %41

41:                                               ; preds = %31, %21
  %42 = phi i64 [ %30, %21 ], [ %40, %31 ]
  store i64 %42, i64* %3, align 8
  %43 = load i64, i64* %3, align 8
  %44 = ashr i64 %43, 17
  %45 = trunc i64 %44 to i32
  store i32 %45, i32* @lock, align 4
  %46 = load i64, i64* %3, align 8
  %47 = srem i64 %46, 1050011
  %48 = trunc i64 %47 to i32
  store i32 %48, i32* @htindex, align 4
  %49 = load i32, i32* @lock, align 4
  %50 = urem i32 %49, 179
  %51 = add i32 131072, %50
  store i32 %51, i32* @stride, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @transpose() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  call void @hash()
  %4 = load i32, i32* @htindex, align 4
  store i32 %4, i32* %3, align 4
  store i32 0, i32* %2, align 4
  br label %5

5:                                                ; preds = %30, %0
  %6 = load i32, i32* %2, align 4
  %7 = icmp slt i32 %6, 8
  br i1 %7, label %8, label %33

8:                                                ; preds = %5
  %9 = load i32*, i32** @ht, align 4
  %10 = load i32, i32* %3, align 4
  %11 = getelementptr inbounds i32, i32* %9, i32 %10
  %12 = load i32, i32* %11, align 4
  %13 = load i32, i32* @lock, align 4
  %14 = icmp eq i32 %12, %13
  br i1 %14, label %15, label %21

15:                                               ; preds = %8
  %16 = load i8*, i8** @he, align 4
  %17 = load i32, i32* %3, align 4
  %18 = getelementptr inbounds i8, i8* %16, i32 %17
  %19 = load i8, i8* %18, align 1
  %20 = sext i8 %19 to i32
  store i32 %20, i32* %1, align 4
  br label %34

21:                                               ; preds = %8
  %22 = load i32, i32* @stride, align 4
  %23 = load i32, i32* %3, align 4
  %24 = add nsw i32 %23, %22
  store i32 %24, i32* %3, align 4
  %25 = icmp sge i32 %24, 1050011
  br i1 %25, label %26, label %29

26:                                               ; preds = %21
  %27 = load i32, i32* %3, align 4
  %28 = sub nsw i32 %27, 1050011
  store i32 %28, i32* %3, align 4
  br label %29

29:                                               ; preds = %26, %21
  br label %30

30:                                               ; preds = %29
  %31 = load i32, i32* %2, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %2, align 4
  br label %5

33:                                               ; preds = %5
  store i32 -128, i32* %1, align 4
  br label %34

34:                                               ; preds = %33, %15
  %35 = load i32, i32* %1, align 4
  ret i32 %35
}

; Function Attrs: noinline nounwind optnone
define dso_local void @transput(i32 signext %0, i32 signext %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %7 = load i32, i32* @htindex, align 4
  store i32 %7, i32* %6, align 4
  store i32 0, i32* %5, align 4
  br label %8

8:                                                ; preds = %44, %2
  %9 = load i32, i32* %5, align 4
  %10 = icmp slt i32 %9, 8
  br i1 %10, label %11, label %47

11:                                               ; preds = %8
  %12 = load i32, i32* %4, align 4
  %13 = load i8*, i8** @he, align 4
  %14 = load i32, i32* %6, align 4
  %15 = getelementptr inbounds i8, i8* %13, i32 %14
  %16 = load i8, i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = and i32 %17, 31
  %19 = icmp sgt i32 %12, %18
  br i1 %19, label %20, label %35

20:                                               ; preds = %11
  %21 = load i64, i64* @hits, align 8
  %22 = add nsw i64 %21, 1
  store i64 %22, i64* @hits, align 8
  %23 = load i32, i32* @lock, align 4
  %24 = load i32*, i32** @ht, align 4
  %25 = load i32, i32* %6, align 4
  %26 = getelementptr inbounds i32, i32* %24, i32 %25
  store i32 %23, i32* %26, align 4
  %27 = load i32, i32* %3, align 4
  %28 = shl i32 %27, 5
  %29 = load i32, i32* %4, align 4
  %30 = or i32 %28, %29
  %31 = trunc i32 %30 to i8
  %32 = load i8*, i8** @he, align 4
  %33 = load i32, i32* %6, align 4
  %34 = getelementptr inbounds i8, i8* %32, i32 %33
  store i8 %31, i8* %34, align 1
  br label %47

35:                                               ; preds = %11
  %36 = load i32, i32* @stride, align 4
  %37 = load i32, i32* %6, align 4
  %38 = add nsw i32 %37, %36
  store i32 %38, i32* %6, align 4
  %39 = icmp sge i32 %38, 1050011
  br i1 %39, label %40, label %43

40:                                               ; preds = %35
  %41 = load i32, i32* %6, align 4
  %42 = sub nsw i32 %41, 1050011
  store i32 %42, i32* %6, align 4
  br label %43

43:                                               ; preds = %40, %35
  br label %44

44:                                               ; preds = %43
  %45 = load i32, i32* %5, align 4
  %46 = add nsw i32 %45, 1
  store i32 %46, i32* %5, align 4
  br label %8

47:                                               ; preds = %20, %8
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @transrestore(i32 signext %0, i32 signext %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %7 = load i32, i32* %4, align 4
  %8 = icmp sgt i32 %7, 31
  br i1 %8, label %9, label %10

9:                                                ; preds = %2
  store i32 31, i32* %4, align 4
  br label %10

10:                                               ; preds = %9, %2
  %11 = load i64, i64* @posed, align 8
  %12 = add nsw i64 %11, 1
  store i64 %12, i64* @posed, align 8
  call void @hash()
  %13 = load i32, i32* @htindex, align 4
  store i32 %13, i32* %6, align 4
  store i32 0, i32* %5, align 4
  br label %14

14:                                               ; preds = %44, %10
  %15 = load i32, i32* %5, align 4
  %16 = icmp slt i32 %15, 8
  br i1 %16, label %17, label %47

17:                                               ; preds = %14
  %18 = load i32*, i32** @ht, align 4
  %19 = load i32, i32* %6, align 4
  %20 = getelementptr inbounds i32, i32* %18, i32 %19
  %21 = load i32, i32* %20, align 4
  %22 = load i32, i32* @lock, align 4
  %23 = icmp eq i32 %21, %22
  br i1 %23, label %24, label %35

24:                                               ; preds = %17
  %25 = load i64, i64* @hits, align 8
  %26 = add nsw i64 %25, 1
  store i64 %26, i64* @hits, align 8
  %27 = load i32, i32* %3, align 4
  %28 = shl i32 %27, 5
  %29 = load i32, i32* %4, align 4
  %30 = or i32 %28, %29
  %31 = trunc i32 %30 to i8
  %32 = load i8*, i8** @he, align 4
  %33 = load i32, i32* %6, align 4
  %34 = getelementptr inbounds i8, i8* %32, i32 %33
  store i8 %31, i8* %34, align 1
  br label %50

35:                                               ; preds = %17
  %36 = load i32, i32* @stride, align 4
  %37 = load i32, i32* %6, align 4
  %38 = add nsw i32 %37, %36
  store i32 %38, i32* %6, align 4
  %39 = icmp sge i32 %38, 1050011
  br i1 %39, label %40, label %43

40:                                               ; preds = %35
  %41 = load i32, i32* %6, align 4
  %42 = sub nsw i32 %41, 1050011
  store i32 %42, i32* %6, align 4
  br label %43

43:                                               ; preds = %40, %35
  br label %44

44:                                               ; preds = %43
  %45 = load i32, i32* %5, align 4
  %46 = add nsw i32 %45, 1
  store i32 %46, i32* %5, align 4
  br label %14

47:                                               ; preds = %14
  %48 = load i32, i32* %3, align 4
  %49 = load i32, i32* %4, align 4
  call void @transput(i32 signext %48, i32 signext %49)
  br label %50

50:                                               ; preds = %47, %24
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @transtore(i32 signext %0, i32 signext %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = icmp sgt i32 %5, 31
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  store i32 31, i32* %4, align 4
  br label %8

8:                                                ; preds = %7, %2
  %9 = load i64, i64* @posed, align 8
  %10 = add nsw i64 %9, 1
  store i64 %10, i64* @posed, align 8
  call void @hash()
  %11 = load i32, i32* %3, align 4
  %12 = load i32, i32* %4, align 4
  call void @transput(i32 signext %11, i32 signext %12)
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local void @htstat() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca [32 x i32], align 4
  %4 = alloca [8 x i32], align 4
  store i32 0, i32* %2, align 4
  br label %5

5:                                                ; preds = %11, %0
  %6 = load i32, i32* %2, align 4
  %7 = icmp slt i32 %6, 32
  br i1 %7, label %8, label %14

8:                                                ; preds = %5
  %9 = load i32, i32* %2, align 4
  %10 = getelementptr inbounds [32 x i32], [32 x i32]* %3, i32 0, i32 %9
  store i32 0, i32* %10, align 4
  br label %11

11:                                               ; preds = %8
  %12 = load i32, i32* %2, align 4
  %13 = add nsw i32 %12, 1
  store i32 %13, i32* %2, align 4
  br label %5

14:                                               ; preds = %5
  store i32 0, i32* %2, align 4
  br label %15

15:                                               ; preds = %21, %14
  %16 = load i32, i32* %2, align 4
  %17 = icmp slt i32 %16, 8
  br i1 %17, label %18, label %24

18:                                               ; preds = %15
  %19 = load i32, i32* %2, align 4
  %20 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 %19
  store i32 0, i32* %20, align 4
  br label %21

21:                                               ; preds = %18
  %22 = load i32, i32* %2, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %2, align 4
  br label %15

24:                                               ; preds = %15
  store i32 0, i32* %2, align 4
  br label %25

25:                                               ; preds = %57, %24
  %26 = load i32, i32* %2, align 4
  %27 = icmp slt i32 %26, 1050011
  br i1 %27, label %28, label %60

28:                                               ; preds = %25
  %29 = load i8*, i8** @he, align 4
  %30 = load i32, i32* %2, align 4
  %31 = getelementptr inbounds i8, i8* %29, i32 %30
  %32 = load i8, i8* %31, align 1
  %33 = sext i8 %32 to i32
  %34 = and i32 %33, 31
  %35 = getelementptr inbounds [32 x i32], [32 x i32]* %3, i32 0, i32 %34
  %36 = load i32, i32* %35, align 4
  %37 = add nsw i32 %36, 1
  store i32 %37, i32* %35, align 4
  %38 = load i8*, i8** @he, align 4
  %39 = load i32, i32* %2, align 4
  %40 = getelementptr inbounds i8, i8* %38, i32 %39
  %41 = load i8, i8* %40, align 1
  %42 = sext i8 %41 to i32
  %43 = and i32 %42, 31
  %44 = icmp ne i32 %43, 0
  br i1 %44, label %45, label %56

45:                                               ; preds = %28
  %46 = load i8*, i8** @he, align 4
  %47 = load i32, i32* %2, align 4
  %48 = getelementptr inbounds i8, i8* %46, i32 %47
  %49 = load i8, i8* %48, align 1
  %50 = sext i8 %49 to i32
  %51 = ashr i32 %50, 5
  %52 = add nsw i32 4, %51
  %53 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 %52
  %54 = load i32, i32* %53, align 4
  %55 = add nsw i32 %54, 1
  store i32 %55, i32* %53, align 4
  br label %56

56:                                               ; preds = %45, %28
  br label %57

57:                                               ; preds = %56
  %58 = load i32, i32* %2, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %2, align 4
  br label %25

60:                                               ; preds = %25
  store i32 0, i32* %2, align 4
  store i32 0, i32* %1, align 4
  br label %61

61:                                               ; preds = %70, %60
  %62 = load i32, i32* %2, align 4
  %63 = icmp slt i32 %62, 8
  br i1 %63, label %64, label %73

64:                                               ; preds = %61
  %65 = load i32, i32* %2, align 4
  %66 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 %65
  %67 = load i32, i32* %66, align 4
  %68 = load i32, i32* %1, align 4
  %69 = add nsw i32 %68, %67
  store i32 %69, i32* %1, align 4
  br label %70

70:                                               ; preds = %64
  %71 = load i32, i32* %2, align 4
  %72 = add nsw i32 %71, 1
  store i32 %72, i32* %2, align 4
  br label %61

73:                                               ; preds = %61
  %74 = load i32, i32* %1, align 4
  %75 = icmp sgt i32 %74, 0
  br i1 %75, label %76, label %110

76:                                               ; preds = %73
  %77 = call double @hitRate()
  %78 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1.69, i32 0, i32 0), double %77)
  %79 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 2
  %80 = load i32, i32* %79, align 4
  %81 = sitofp i32 %80 to double
  %82 = load i32, i32* %1, align 4
  %83 = sitofp i32 %82 to double
  %84 = fdiv double %81, %83
  %85 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 3
  %86 = load i32, i32* %85, align 4
  %87 = sitofp i32 %86 to double
  %88 = load i32, i32* %1, align 4
  %89 = sitofp i32 %88 to double
  %90 = fdiv double %87, %89
  %91 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 4
  %92 = load i32, i32* %91, align 4
  %93 = sitofp i32 %92 to double
  %94 = load i32, i32* %1, align 4
  %95 = sitofp i32 %94 to double
  %96 = fdiv double %93, %95
  %97 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 5
  %98 = load i32, i32* %97, align 4
  %99 = sitofp i32 %98 to double
  %100 = load i32, i32* %1, align 4
  %101 = sitofp i32 %100 to double
  %102 = fdiv double %99, %101
  %103 = getelementptr inbounds [8 x i32], [8 x i32]* %4, i32 0, i32 6
  %104 = load i32, i32* %103, align 4
  %105 = sitofp i32 %104 to double
  %106 = load i32, i32* %1, align 4
  %107 = sitofp i32 %106 to double
  %108 = fdiv double %105, %107
  %109 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.2.70, i32 0, i32 0), double %84, double %90, double %96, double %102, double %108)
  br label %110

110:                                              ; preds = %76, %73
  store i32 0, i32* %2, align 4
  br label %111

111:                                              ; preds = %124, %110
  %112 = load i32, i32* %2, align 4
  %113 = icmp slt i32 %112, 32
  br i1 %113, label %114, label %127

114:                                              ; preds = %111
  %115 = load i32, i32* %2, align 4
  %116 = getelementptr inbounds [32 x i32], [32 x i32]* %3, i32 0, i32 %115
  %117 = load i32, i32* %116, align 4
  %118 = load i32, i32* %2, align 4
  %119 = and i32 %118, 7
  %120 = icmp eq i32 %119, 7
  %121 = zext i1 %120 to i64
  %122 = select i1 %120, i32 10, i32 9
  %123 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.3.71, i32 0, i32 0), i32 signext %117, i32 signext %122)
  br label %124

124:                                              ; preds = %114
  %125 = load i32, i32* %2, align 4
  %126 = add nsw i32 %125, 1
  store i32 %126, i32* %2, align 4
  br label %111

127:                                              ; preds = %111
  ret void
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readnone speculatable willreturn }
attributes #5 = { argmemonly nounwind willreturn }
attributes #6 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="mips32r2" "target-features"="+fpxx,+mips32r2,+nooddspreg,-noabicalls" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind }
attributes #8 = { noreturn nounwind }
attributes #9 = { nounwind readonly }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1}

!0 = !{!"clang version 10.0.0-4ubuntu1 "}
!1 = !{i32 1, !"wchar_size", i32 4}
