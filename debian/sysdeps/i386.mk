libc-second_add-ons = $(libc_add-ons)
libc-headers_add-ons = $(libc_add-ons)

# We use -march=i686 and glibc's i686 routines use cmov, so require it.
# A Debian-local glibc patch adds cmov to the search path.
# The optimized libraries also use NPTL!
i686_add-ons = nptl $(add-ons)
i686_configure_target=i686-linux
i686_extra_cflags = -march=i686 -mtune=i686 -O3
i686_rtlddir = /lib
i686_slibdir = /lib/i686/cmov
i686_extra_config_options = $(extra_config_options) --disable-profile
