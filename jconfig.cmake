/* jconfig.cmake --- jconfig.h configured header by cmake */
/* see jconfig.doc for explanations */

#cmakedefine HAVE_PROTOTYPES
#cmakedefine HAVE_UNSIGNED_CHAR
#cmakedefine HAVE_UNSIGNED_SHORT
#cmakedefine void char
#cmakedefine const
#cmakedefine CHAR_IS_UNSIGNED
#cmakedefine HAVE_STDDEF_H
#cmakedefine HAVE_STDLIB_H
#cmakedefine NEED_BSD_STRINGS
#cmakedefine NEED_SYS_TYPES_H
#cmakedefine NEED_FAR_POINTERS	/* we presume a 32-bit flat memory model */
#cmakedefine NEED_SHORT_EXTERNAL_NAMES
#cmakedefine INCOMPLETE_TYPES_BROKEN

/* Define "boolean" as unsigned char, not int, per Windows custom */
#ifndef __RPCNDR_H__		/* don't conflict if rpcndr.h already read */
typedef unsigned char boolean;
#endif
#define HAVE_BOOLEAN		/* prevent jmorecfg.h from redefining it */


#ifdef JPEG_INTERNALS

#cmakedefine RIGHT_SHIFT_IS_UNSIGNED
#cmakedefine INLINE

/* These are for configuring the JPEG memory manager. */
#cmakedefine DEFAULT_MAX_MEM
#cmakedefine NO_MKTEMP

#endif /* JPEG_INTERNALS */

#ifdef JPEG_CJPEG_DJPEG

#cmakedefine BMP_SUPPORTED		/* BMP image file format */
#cmakedefine GIF_SUPPORTED		/* GIF image file format */
#cmakedefine PPM_SUPPORTED		/* PBMPLUS PPM/PGM image file format */
#cmakedefine RLE_SUPPORTED		/* Utah RLE image file format */
#cmakedefine TARGA_SUPPORTED		/* Targa image file format */

#cmakedefine TWO_FILE_COMMANDLINE	/* optional */
#cmakedefine USE_SETMODE		/* Microsoft has setmode() */
#cmakedefine NEED_SIGNAL_CATCHER
#cmakedefine DONT_USE_B_MODE
#cmakedefine PROGRESS_REPORT		/* optional */

#endif /* JPEG_CJPEG_DJPEG */

