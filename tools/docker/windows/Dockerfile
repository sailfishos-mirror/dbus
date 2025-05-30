# escape=`

FROM 'mcr.microsoft.com/windows/servercore:ltsc2022'

# Make sure any failure in PowerShell scripts is fatal
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
ENV ErrorActionPreference='Stop'

# Install Chocolatey
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Install required packages
RUN choco install -y vcredist140
RUN choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'
RUN choco install -y git --params '/NoAutoCrlf /NoCredentialManager /NoShellHereIntegration /NoGuiHereIntegration /NoShellIntegration'
RUN choco install -y windows-sdk-8.1
RUN choco install -y python3
RUN choco install -y msys2 --params '/NoPath /NoUpdate /InstallDir:C:\\msys64'

RUN 'git config --global user.email "cirunner@dbus.freedesktop.org"; git config --global user.name "D-Bus CI system"'

RUN pip3 install meson
# FIXME: Python fails to validate SSL certificates, for unclear reasons
# try various ways to update the store, certifi-win32 seems to work as long as we fetch before
# See also: https://bugs.python.org/issue36011
RUN pip3 install --upgrade certifi
RUN pip3 install python-certifi-win32
RUN (New-Object System.Net.WebClient).DownloadString('https://sourceforge.net/robots.txt') >$null
RUN (New-Object System.Net.WebClient).DownloadString('https://wrapdb.mesonbuild.com/v2/pcre_8.37-2/get_patch') >$null
RUN (New-Object System.Net.WebClient).DownloadString('https://zlib.net/fossils/') >$null

# MinGW environment
RUN c:\msys64\usr\bin\bash -lc 'pacman -S --noconfirm mingw-w64-ucrt-x86_64-toolchain expat glib2-devel ninja'

# Visual Studio can't be installed with choco.
# It depends on dotnetfx v4.8.0.20190930, which requires a reboot: dotnetfx (exit code 3010)
# https://github.com/microsoft/vs-dockerfiles/blob/main/native-desktop/
# Set up environment to collect install errors.
COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe
# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/15/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman
# Download and install Build Tools for Visual Studio 2017 for native desktop workload.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended`
    --installPath C:\BuildTools

# Upstream expat doesn't ship devel? let's build it then...
# ADD https://github.com/libexpat/libexpat/releases/download/R_2_4_1/expat-win32bin-2.4.1.exe C:\TEMP\expat.exe
# RUN C:\TEMP\expat.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
RUN git clone --depth 1 --branch R_2_4_2 https://github.com/libexpat/libexpat
WORKDIR "/libexpat/expat"
RUN cmake --install-prefix c:/ -G '"Visual Studio 15 2017 Win64"' .
RUN cmake --build . --config Release
RUN cmake --install . --config Release

# Build glib for MSVC
RUN git clone --depth 1 --branch 2.82.5 https://gitlab.gnome.org/GNOME/glib.git \glib
WORKDIR "/glib"
RUN cmd /c 'C:\BuildTools\Common7\Tools\VsDevCmd.bat -arch=amd64 & meson setup builddir'
RUN meson compile -C builddir
RUN meson install --no-rebuild -C builddir
