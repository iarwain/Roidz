-- This premake script should be used with orx-customized version of premake4.
-- Its Hg repository can be found at https://bitbucket.org/orx/premake-stable.
-- A copy, including binaries, can also be found in the extern/premake folder.

--
-- Globals
--

function initconfigurations ()
    return
    {
        "Debug",
        "Profile",
        "Release",
        "Bundle"
    }
end

function initplatforms ()
    if os.is ("windows")
    or os.is ("linux") then
        if os.is64bit () then
            return
            {
                "x64",
                "x32",
                "web"
            }
        else
            return
            {
                "x32",
                "x64",
                "web"
            }
        end
    elseif os.is ("macosx") then
        return
        {
            "universal64",
            "x64",
            "web"
        }
    end
end

function defaultaction (name, action)
   if os.is (name) then
      _ACTION = _ACTION or action
   end
end

defaultaction ("windows", "vs2022")
defaultaction ("linux", "gmake")
defaultaction ("macosx", "gmake")

newoption
{
    trigger = "to",
    value   = "path",
    description = "Set the output location for the generated files"
}

if os.is ("macosx") then
    osname = "mac"
else
    osname = os.get()
end

destination = _OPTIONS["to"] or "./" .. osname .. "/" .. _ACTION
copybase = path.rebase ("..", os.getcwd (), os.getcwd () .. "/" .. destination)


--
-- Solution: Roidz
--

solution "Roidz"

    language ("C++")

    location (destination)

    kind ("ConsoleApp")

    configurations
    {
        initconfigurations ()
    }

    platforms
    {
        initplatforms ()
    }

    targetdir ("../bin")

    flags
    {
        "NoPCH",
        "NoManifest",
        "FloatFast",
        "NoNativeWChar",
        "NoExceptions",
        "NoIncrementalLink",
        "NoEditAndContinue",
        "NoMinimalRebuild",
        "Symbols"
    }

    configuration {"not web"}
        flags {"StaticRuntime"}

    configuration {"not xcode*", "not web"}
        includedirs {"$(ORX)/include"}
        libdirs {"$(ORX)/lib/dynamic"}

    configuration {"xcode*", "not web"}
        includedirs {"../include"}
        libdirs {"../lib/dynamic"}

    configuration {"x32"}
        flags {"EnableSSE2"}

    configuration {"not windows"}
        flags {"Unicode"}

    configuration {"*Debug*"}
        targetsuffix ("d")
        defines {"__orxDEBUG__"}
        links {"orxd"}

    configuration {"*Profile*"}
        targetsuffix ("p")
        defines {"__orxPROFILER__"}
        flags {"Optimize", "NoRTTI"}
        links {"orxp"}

    configuration {"*Release*"}
        flags {"Optimize", "NoRTTI"}
        links {"orx"}

    configuration {"*Bundle*"}
        flags {"Optimize", "NoRTTI"}
        links {"orx"}

    configuration {"windows", "*Release*", "not web"}
        kind ("WindowedApp")

    configuration {"web"}
        targetextension ".js"
        targetsuffix ""
        targetdir "../bin/web"
        buildoptions
        {
            "-DorxWEB_EXECUTABLE_NAME='\"Roidz.wasm\"'",
            "-pthread"
        }
        linkoptions
        {
            "--preload-file " .. copybase .. "/build/Roidz.obr@/",
            "-sPTHREAD_POOL_SIZE=navigator.hardwareConcurrency",
            "-sAUDIO_WORKLET=1",
            "-sWASM_WORKERS=1",
            "-sASYNCIFY",
            "-sSTACK_SIZE=1048576",
            "-sALLOW_MEMORY_GROWTH",
            "-sFULL_ES3=1",
            "-pthread",
            "-lidbfs.js",
            "$(ORX)/../extern/emscripten-glfw/lib/libglfw3.a",
            "--js-library $(ORX)/../extern/emscripten-glfw/lib/lib_emscripten_glfw3.js"
        }
        links
        {
            "basisu",
            "webpdecoder",
            "liquidfun"
        }
        includedirs {"$(ORX)/include"}
        libdirs {
            "$(ORX)/lib/static/web",
            "$(ORX)/../extern/emscripten-glfw/lib",
            "$(ORX)/../extern/basisu/lib/web",
            "$(ORX)/../extern/libwebp/lib/web",
            "$(ORX)/../extern/LiquidFun-1.1.0/lib/web"
        }

    configuration {"web", "*Release*"}
        links {"orx"}
        linkoptions {"-O2"}

    configuration {"web", "*Profile*"}
        links {"orxp"}
        linkoptions {"-O2"}

    configuration {"web", "*Debug*"}
        links {"orxd"}
        linkoptions {"-gsource-map"}

    configuration {"web", "Windows"}
        prelinkcommands {"cd " .. copybase .. "/bin && Roidz -b ../build/Roidz.obr"}
        postbuildcommands {"del " .. path.translate(copybase, "\\") .. "\\build\\Roidz.obr"}

    configuration {"web", "not Windows"}
        prelinkcommands {"cd " .. copybase .. "/bin && ./Roidz -b ../build/Roidz.obr"}
        postbuildcommands {"rm " .. copybase .. "/build/Roidz.obr"}


-- Linux

    configuration {"linux", "not web"}
        buildoptions
        {
            "-Wno-unused-function"
        }
        linkoptions {"-Wl,-rpath ./", "-Wl,--export-dynamic"}
        links
        {
            "dl",
            "m",
            "rt"
        }

    -- This prevents an optimization bug from happening with some versions of gcc on linux
    configuration {"linux", "not *Debug*", "not web"}
        buildoptions {"-fschedule-insns"}


-- Mac OS X

    configuration {"macosx", "not web"}
        buildoptions
        {
            "-stdlib=libc++",
            "-gdwarf-2",
            "-Wno-unused-function",
            "-Wno-write-strings"
        }
        linkoptions
        {
            "-stdlib=libc++",
            "-dead_strip"
        }

    configuration {"macosx", "not codelite", "not codeblocks", "not web"}
        links
        {
            "Foundation.framework",
            "AppKit.framework"
        }

    configuration {"macosx", "codelite or codeblocks", "not web"}
        linkoptions
        {
            "-framework Foundation",
            "-framework AppKit"
        }

    configuration {"macosx", "x32", "not web"}
        buildoptions
        {
            "-mfix-and-continue"
        }


-- Windows

    configuration {"windows", "vs*", "not web"}
        buildoptions
        {
            "/MP",
            "/EHsc"
        }

    configuration {"windows", "gmake", "x32"}
        prebuildcommands
        {
            "$(eval CC := i686-w64-mingw32-gcc)",
            "$(eval CXX := i686-w64-mingw32-g++)",
            "$(eval AR := i686-w64-mingw32-gcc-ar)"
        }

    configuration {"windows", "gmake", "x64"}
        prebuildcommands
        {
            "$(eval CC := x86_64-w64-mingw32-gcc)",
            "$(eval CXX := x86_64-w64-mingw32-g++)",
            "$(eval AR := x86_64-w64-mingw32-gcc-ar)"
        }

    configuration {"windows", "codelite or codeblocks", "x32"}
        envs
        {
            "CC=i686-w64-mingw32-gcc",
            "CXX=i686-w64-mingw32-g++",
            "AR=i686-w64-mingw32-gcc-ar"
        }

    configuration {"windows", "codelite or codeblocks", "x64"}
        envs
        {
            "CC=x86_64-w64-mingw32-gcc",
            "CXX=x86_64-w64-mingw32-g++",
            "AR=x86_64-w64-mingw32-gcc-ar"
        }


--
-- Project: Roidz
--

project "Roidz"

    files
    {
        "../src/**.cpp",
        "../src/**.hpp",
        "../src/**.c",
        "../include/**.h",
        "../include/**.inc",
        "../build/premake4.lua",
        "../data/config/**.ini"
    }

    includedirs
    {
        "../include/extensions",
        "../include"
    }

    vpaths
    {
        ["bundle"] = {"**.inc"},
        ["build"] = {"**premake4.lua"},
        ["config/**"] = {"../data/config/**.ini"}
    }

    configuration {"*Bundle*", "not web"}
        debugargs {"-b", "Roidz.obr"}


-- Linux

    configuration {"linux", "not web"}
        postbuildcommands {"cp -f $(ORX)/lib/dynamic/liborx*.so " .. copybase .. "/bin"}


-- Mac OS X

    configuration {"macosx", "xcode*", "not web"}
        postbuildcommands {"cp -f ../lib/dynamic/liborx*.dylib " .. copybase .. "/bin"}

    configuration {"macosx", "not xcode*", "not web"}
        postbuildcommands {"cp -f $(ORX)/lib/dynamic/liborx*.dylib " .. copybase .. "/bin"}


-- Windows

    configuration {"windows", "not web"}
        postbuildcommands {"cmd /c copy /Y $(ORX)\\lib\\dynamic\\orx*.dll " .. path.translate(copybase, "\\") .. "\\bin"}
