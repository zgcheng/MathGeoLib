if (MSVC)
	add_definitions(/EHsc -D_CRT_SECURE_NO_WARNINGS)

	# Perform extremely aggressive optimization on Release builds:
	# Optimization: Full Optimization (/Ox)
	# Inline Function Expansion: Any Suitable (/Ob2)
	# Enable Intrinsic Functions: Yes (/Oi)
	# Favor Size Or Speed: Favor fast code (/Ot)
	# Omit Frame Pointers: Yes (/Oy)
	# Enable Fiber-Safe Optimizations: Yes (/GT)
	# Whole Program Optimization: Yes (/GL)
	# Enable String Pooling: Yes (/GF)
	# Buffer Security Check: No (/GS-)
	# Floating Point Model: Fast (/fp:fast)
	# Enable Floating Point Exceptions: No (/fp:except-)
	set(CMAKE_C_FLAGS_RELEASE     "${CMAKE_C_FLAGS_RELEASE} /Ox /Ob2 /Oi /Ot /Oy /GT /GL /GF /GS- /fp:fast /fp:except-")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Ox /Ob2 /Oi /Ot /Oy /GT /GL /GF /GS- /fp:fast /fp:except-")

	# Don't omit frame pointers, but add Debug database (/Zi).
	set(CMAKE_C_FLAGS_RELWITHDEBINFO     "${CMAKE_C_FLAGS_RELWITHDEBINFO} /Zi /GS- /Ox /Ob2 /Oi /Ot /GT /GL /GF /GS- /fp:fast /fp:except-")
	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /Zi /GS- /Ox /Ob2 /Oi /Ot /GT /GL /GF /GS- /fp:fast /fp:except-")

	if (MSVC11)
		# SDL checks: No (/sdl-)
		set(CMAKE_C_FLAGS_RELEASE     "${CMAKE_C_FLAGS_RELEASE} /sdl-")
		set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /sdl-")
		set(CMAKE_C_FLAGS_RELWITHDEBINFO     "${CMAKE_C_FLAGS_RELWITHDEBINFO} /sdl-")
		set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /sdl-")
	endif()
else()
#	GCC 4.7.2 generates broken code that fails Float4Normalize4 test and others under -O3 -ffast-math, so don't do that.
#	set(OPT_FLAGS "-O3 -ffast-math")
#	set(CMAKE_C_FLAGS_RELEASE     "${CMAKE_C_FLAGS_RELEASE} ${OPT_FLAGS}")
#	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${OPT_FLAGS}")
#	set(CMAKE_C_FLAGS_RELWITHDEBINFO     "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${OPT_FLAGS}")
#	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${OPT_FLAGS}")
endif()

if (EMSCRIPTEN)
	SET(CMAKE_LINK_LIBRARY_SUFFIX "")

	SET(CMAKE_STATIC_LIBRARY_PREFIX "")
	SET(CMAKE_STATIC_LIBRARY_SUFFIX ".bc")
	SET(CMAKE_SHARED_LIBRARY_PREFIX "")
	SET(CMAKE_SHARED_LIBRARY_SUFFIX ".bc")
	if (EMSCRIPTEN_BUILD_JS)
		SET(CMAKE_EXECUTABLE_SUFFIX ".js")
	else()
		SET(CMAKE_EXECUTABLE_SUFFIX ".html")
	endif()
	SET(CMAKE_DL_LIBS "" )

	SET(CMAKE_FIND_LIBRARY_PREFIXES "")
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".bc")
	
	add_definitions(-Wno-warn-absolute-paths)
endif()

if (FLASCC)
	SET(CMAKE_LINK_LIBRARY_SUFFIX "")

	SET(CMAKE_STATIC_LIBRARY_PREFIX "")
	SET(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
	SET(CMAKE_SHARED_LIBRARY_PREFIX "")
	SET(CMAKE_SHARED_LIBRARY_SUFFIX ".a")
	if (FLASCC_BUILD_EXE)
		SET(CMAKE_EXECUTABLE_SUFFIX ".exe")
	else()
		SET(CMAKE_EXECUTABLE_SUFFIX ".swf")
	endif()
	SET(CMAKE_DL_LIBS "" )

	SET(CMAKE_FIND_LIBRARY_PREFIXES "")
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

	set(CMAKE_C_FLAGS_RELEASE   "${CMAKE_C_FLAGS_RELEASE} -O4")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O4")
endif()

if (LINUX)
	add_definitions(-DLINUX)
endif()

if (MINGW)
	# Require Windows XP.
	# See http://msdn.microsoft.com/en-us/library/6sehtctf.aspx
	add_definitions(-DWINVER=0x0501)
	add_definitions(-D_WIN32_WINNT=0x0501)
endif()

if(MSVC)
  # Force to always compile with W4
  if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
  endif()
elseif(CMAKE_C_COMPILER_ID MATCHES "PathScale")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-long-long")
elseif(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_C_COMPILER MATCHES ".*(gcc|clang|emcc).*" OR CMAKE_C_COMPILER_ID MATCHES ".*(GCC|Clang|emcc).*")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-long-long -Wno-variadic-macros")
else()
  message(WARNING "Unknown compiler '${CMAKE_C_COMPILER}'/'${CMAKE_C_COMPILER_ID}' used! Cannot set up max warning level.")
endif()

if (MATH_AVX)
	add_definitions(-DMATH_AVX)
	if (MSVC)
		add_definitions(/arch:AVX)
	else()
		add_definitions(-mavx)
	endif()
endif()

if (MATH_SSE41)
	add_definitions(-DMATH_SSE41)
endif()

if (MATH_SSE3)
	add_definitions(-DMATH_SSE3)
endif()

if (MATH_SSE2)
	add_definitions(-DMATH_SSE2)
endif()

if (MATH_SSE)
	add_definitions(-DMATH_SSE)
endif()

if (MATH_NEON)
	add_definitions(-DMATH_NEON)
	if (NOT MSVC)
		add_definitions(-mfpu=neon)
	endif()
endif()

if (MATH_AUTOMATIC_SSE)
	add_definitions(-DMATH_AUTOMATIC_SSE)
endif()
