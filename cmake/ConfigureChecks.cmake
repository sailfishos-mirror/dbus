include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckSymbolExists)
include(CheckStructMember)
include(CheckTypeSize)
include(CheckCSourceCompiles)
include(CheckCSourceRuns)

set(CMAKE_REQUIRED_DEFINITIONS -D_GNU_SOURCE)

# keep in sync with check_headers in meson.build
check_include_files("winsock2.h;afunix.h"   HAVE_AFUNIX_H)
check_include_file(alloca.h     HAVE_ALLOCA_H)
check_include_file(byteswap.h     HAVE_BYTESWAP_H)
check_include_file(crt/externs.h     HAVE_CRT_EXTERNS_H)
check_include_file(dirent.h     HAVE_DIRENT_H)  # dbus-sysdeps-util.c
check_include_file(errno.h     HAVE_ERRNO_H)    # dbus-sysdeps.c
check_include_file(inttypes.h     HAVE_INTTYPES_H)   # dbus-pipe.h
check_include_file(io.h         HAVE_IO_H)      # internal
check_include_file(linux/close_range.h HAVE_LINUX_CLOSE_RANGE_H)
check_include_file(linux/magic.h HAVE_LINUX_MAGIC_H)
check_include_file(locale.h     HAVE_LOCALE_H)
check_include_file(signal.h     HAVE_SIGNAL_H)
check_include_file(stdatomic.h  HAVE_STDATOMIC_H)
check_include_file(stdio.h      HAVE_STDIO_H)   # dbus-sysdeps.h
check_include_files("stdint.h;sys/types.h;sys/event.h" HAVE_SYS_EVENT_H)
check_include_file(sys/inotify.h     HAVE_SYS_INOTIFY_H)
check_include_file(sys/inotify.h DBUS_BUS_ENABLE_INOTIFY)
check_include_file(sys/prctl.h  HAVE_SYS_PRCTL_H)
check_include_file(sys/random.h     HAVE_SYS_RANDOM_H)
check_include_file(sys/resource.h     HAVE_SYS_RESOURCE_H)
check_include_file(sys/syscall.h HAVE_SYS_SYSCALL_H)
check_include_file(sys/time.h   HAVE_SYS_TIME_H)# dbus-sysdeps-win.c
check_include_file(sys/ucred.h  HAVE_SYS_UCRED_H)# dbus-sysdeps-unix.c
check_include_file(sys/vfs.h    HAVE_SYS_VFS_H)
check_include_file(syslog.h     HAVE_SYSLOG_H)
check_include_file(unistd.h     HAVE_UNISTD_H)  # dbus-sysdeps-util-win.c
check_include_file(ws2tcpip.h   HAVE_WS2TCPIP_H)# dbus-sysdeps-win.c

find_package(Backtrace)  # dbus-sysdeps.c, dbus-sysdeps-win.c
set(HAVE_BACKTRACE ${Backtrace_FOUND})

# keep in sync with check_functions in meson.build
check_symbol_exists(LOG_PERROR   "syslog.h"                  HAVE_DECL_LOG_PERROR)
check_symbol_exists(MSG_NOSIGNAL "sys/socket.h"              HAVE_DECL_MSG_NOSIGNAL)
check_symbol_exists(SCM_RIGHTS    "sys/types.h;sys/socket.h;sys/un.h" HAVE_UNIX_FD_PASSING)
check_symbol_exists(SYS_pidfd_open "sys/syscall.h"  HAVE_DECL_SYS_PIDFD_OPEN) #  dbus-sysdeps-unix.c
check_symbol_exists(accept4      "sys/socket.h"             HAVE_ACCEPT4)
check_symbol_exists(clearenv     "stdlib.h"         HAVE_CLEARENV)           #  dbus-sysdeps.c
check_symbol_exists(close_range  "unistd.h"         HAVE_CLOSE_RANGE)        #  dbus-sysdeps-unix.c
check_symbol_exists(closefrom    "unistd.h"         HAVE_CLOSEFROM)          #  dbus-sysdeps-unix.c
check_symbol_exists(environ      "unistd.h"                  HAVE_DECL_ENVIRON)
check_symbol_exists(fstatfs      "sys/vfs.h"                 HAVE_FSTATFS)
check_symbol_exists(getgrouplist "grp.h"            HAVE_GETGROUPLIST)       #  dbus-sysdeps.c
check_symbol_exists(getpeerucred "ucred.h"          HAVE_GETPEERUCRED)       #  dbus-sysdeps.c, dbus-sysdeps-win.c
check_symbol_exists(getpwnam_r   "errno.h;pwd.h"    HAVE_GETPWNAM_R)         #  dbus-sysdeps-util-unix.c
check_symbol_exists(getrandom    "sys/random.h"             HAVE_GETRANDOM)
check_symbol_exists(getresuid    "unistd.h"                  HAVE_GETRESUID)
check_symbol_exists(getrlimit    "sys/resource.h;sys/time.h" HAVE_GETRLIMIT)
check_symbol_exists(inotify_init1 "sys/inotify.h"           HAVE_INOTIFY_INIT1)
check_symbol_exists(localeconv   "locale.h"         HAVE_LOCALECONV)         #  dbus-sysdeps.c
check_symbol_exists(nanosleep    "time.h"           HAVE_NANOSLEEP)          #  dbus-sysdeps.c
check_symbol_exists(pipe2        "fcntl.h;unistd.h"         HAVE_PIPE2)
check_symbol_exists(poll         "poll.h"           HAVE_POLL)               #  dbus-sysdeps-unix.c
check_symbol_exists(prctl        "sys/prctl.h"              HAVE_PRCTL)
check_symbol_exists(prlimit      "sys/resource.h;sys/time.h" HAVE_PRLIMIT)
check_symbol_exists(raise        "signal.h"                 HAVE_RAISE)
check_symbol_exists(setenv       "stdlib.h"         HAVE_SETENV)             #  dbus-sysdeps.c
check_symbol_exists(setlocale    "locale.h"         HAVE_SETLOCALE)          #  dbus-test-main.c
check_symbol_exists(setresuid    "unistd.h"                  HAVE_SETRESUID)
check_symbol_exists(setrlimit    "sys/resource.h"   HAVE_SETRLIMIT)          #  dbus-sysdeps.c, dbus-sysdeps-win.c, test/test-segfault.c
check_symbol_exists(setrlimit    "sys/resource.h;sys/time.h" HAVE_SETRLIMIT)
check_symbol_exists(socketpair   "sys/socket.h"     HAVE_SOCKETPAIR)         #  dbus-sysdeps.c
check_symbol_exists(unsetenv     "stdlib.h"         HAVE_UNSETENV)           #  dbus-sysdeps.c
check_symbol_exists(writev       "sys/uio.h"        HAVE_WRITEV)             #  dbus-sysdeps.c, dbus-sysdeps-win.c

# It doesn't really matter which specific header we use for these, as long as
# we include at least one glibc-provided header. time.h is suitable.
check_symbol_exists(__GLIBC__    "time.h"                    HAVE___GLIBC__)
check_symbol_exists(_FILE_OFFSET_BITS "time.h"               HAVE__FILE_OFFSET_BITS)
check_symbol_exists(_TIME_BITS   "time.h"                    HAVE__TIME_BITS)

# Opt-in to large inode number and timestamp support, which we know doesn't
# break libdbus ABI: https://gitlab.freedesktop.org/dbus/dbus/-/issues/465
if(HAVE___GLIBC__ AND CMAKE_SIZEOF_VOID_P EQUAL 4 AND NOT HAVE__FILE_OFFSET_BITS)
    set(_FILE_OFFSET_BITS 64)
endif()

if(HAVE___GLIBC__ AND CMAKE_SIZEOF_VOID_P EQUAL 4 AND NOT HAVE__TIME_BITS)
    set(_TIME_BITS 64)
endif()

check_struct_member(cmsgcred cmcred_pid "sys/types.h;sys/socket.h" HAVE_CMSGCRED)   #  dbus-sysdeps.c

CHECK_C_SOURCE_COMPILES("
#ifndef __linux__
#error This is not Linux
#endif
#include <sys/epoll.h>
int main() {
epoll_create1 (EPOLL_CLOEXEC);
}" DBUS_HAVE_LINUX_EPOLL)

CHECK_C_SOURCE_COMPILES("
int main() {
    int a = 4;
    int b = __sync_sub_and_fetch(&a, 4);
    return b;
}
" DBUS_USE_SYNC)

set(DBUS_SIZEOF_VOID_P ${CMAKE_SIZEOF_VOID_P})

check_type_size("short"     SIZEOF_SHORT)
check_type_size("int"       SIZEOF_INT)
check_type_size("long"      SIZEOF_LONG)
check_type_size("long long" SIZEOF_LONG_LONG)
check_type_size("__int64"   SIZEOF___INT64)
set(CMAKE_EXTRA_INCLUDE_FILES "sys/socket.h")
check_type_size("socklen_t" HAVE_SOCKLEN_T)          #  dbus-sysdeps-unix.c
set(CMAKE_EXTRA_INCLUDE_FILES)

# DBUS_INT64_TYPE
if(SIZEOF_INT EQUAL 8)
    set(DBUS_INT64_TYPE "int")
    set(DBUS_INT64_CONSTANT  "(val)")
    set(DBUS_UINT64_CONSTANT "(val##U)")
    set(DBUS_INT64_MODIFIER  "")
elseif(SIZEOF_LONG EQUAL 8)
    set(DBUS_INT64_TYPE "long")
    set(DBUS_INT64_CONSTANT  "(val##L)")
    set(DBUS_UINT64_CONSTANT "(val##UL)")
    set(DBUS_INT64_MODIFIER  "l")
elseif(SIZEOF_LONG_LONG EQUAL 8)
    set(DBUS_INT64_TYPE "long long")
    set(DBUS_INT64_CONSTANT  "(val##LL)")
    set(DBUS_UINT64_CONSTANT "(val##ULL)")
    set(DBUS_INT64_MODIFIER  "ll")
elseif(SIZEOF___INT64 EQUAL 8)
    set(DBUS_INT64_TYPE "__int64")
    set(DBUS_INT64_CONSTANT  "(val##i64)")
    set(DBUS_UINT64_CONSTANT "(val##ui64)")
    set(DBUS_INT64_MODIFIER  "I64")
else(SIZEOF_INT EQUAL 8)
    message(FATAL_ERROR "Could not find a 64-bit integer type")
endif()

# MSVCRT.dll printf() doesn't support %lld
if(WIN32 AND NOT CYGWIN)
    set(DBUS_INT64_MODIFIER  "I64")
endif()

# DBUS_INT32_TYPE
if(SIZEOF_INT EQUAL 4)
    set(DBUS_INT32_TYPE "int")
elseif(SIZEOF_LONG EQUAL 4)
    set(DBUS_INT32_TYPE "long")
elseif(SIZEOF_LONG_LONG EQUAL 4)
    set(DBUS_INT32_TYPE "long long")
endif()

# DBUS_INT16_TYPE
if(SIZEOF_INT EQUAL 2)
    set(DBUS_INT16_TYPE "int")
elseif(SIZEOF_SHORT EQUAL 2)
    set(DBUS_INT16_TYPE "short")
endif()

find_program(DOXYGEN doxygen)
find_program(XMLTO xmlto)
