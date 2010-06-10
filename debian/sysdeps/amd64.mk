libc_add-ons = nptl $(add-ons)
libc-second_add-ons = $(libc_add-ons)
libc-headers_add-ons = $(libc_add-ons)

libc_configure-args = libc_cv_slibdir=/lib

libc_slibdir = /lib
libc_libdir = /usr/lib
libc_rtlddir = /lib

# Force slibdir to be /lib: configure tries to be smart and changes slibdir to /lib64
libc_configure-args = libc_cv_slibdir=/lib

libc-headers_slibdir = $(libc_slibdir)
libc-headers_libdir = $(libc_libdir)
libc-headers_rtlddir = $(libc_rtlddir)
libc-headers_configure-args = $(libc_configure-args)

libc-second_slibdir = $(libc_slibdir)
libc-second_libdir = $(libc_libdir)
libc-second_rtlddir = $(libc_rtlddir)
libc-second_configure-args = $(libc_configure-args)
